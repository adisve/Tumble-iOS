//
//  SettingsViewModel.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-08.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

final class SettingsViewModel: ObservableObject {
    
    @Inject var preferenceService: PreferenceService
    @Inject var notificationManager: NotificationManager
    @Inject var userController: UserController
    @Inject var schoolManager: SchoolManager
    
    @Published var bookmarks: [Bookmark]?
    @Published var presentSidebarSheet: Bool = false
    @Published var authStatus: AuthStatus = .unAuthorized
    @Published var schoolId: Int = -1
    @Published var schoolName: String = ""
    
    lazy var schools: [School] = schoolManager.getSchools()
    var cancellables = Set<AnyCancellable>()
    
    
    init() { setUpDataPublishers() }
    
    private func setUpDataPublishers() -> Void {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let authStatusPublisher = self.userController.$authStatus
            let schoolIdPublisher = self.preferenceService.$schoolId
            
            Publishers.CombineLatest(
                schoolIdPublisher,
                authStatusPublisher
            )
            .receive(on: DispatchQueue.main)
            .sink { schoolId, authStatus in
                self.authStatus = authStatus
                self.schoolId = schoolId
                self.schoolName = self.schoolManager.getSchools().first(where: { $0.id == schoolId })?.name ?? ""
            }
            .store(in: &self.cancellables)
        }
    }
    
    func logOut() -> Void {
        userController.logOut(completion: { success in
            if success {
                AppLogger.shared.debug("Logged out")
                AppController.shared.toast = Toast(
                    type: .success,
                    title: NSLocalizedString("Logged out", comment: ""),
                    message: NSLocalizedString("You have successfully logged out of your account", comment: ""))
            } else {
                AppLogger.shared.debug("Could not log out")
                AppController.shared.toast = Toast(
                    type: .success,
                    title: NSLocalizedString("Error", comment: ""),
                    message: NSLocalizedString("Could not log out from your account", comment: ""))
            }
        })
    }
    
    func removeNotificationsFor(for id: String, referencing events: [Event]) -> Void {
        events.forEach { notificationManager.cancelNotification(for: $0.eventId) }
    }
    
    func clearAllNotifications() -> Void {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.notificationManager.cancelNotifications()
        }
        makeToast(
            type: .success,
            title: NSLocalizedString("Cancelled notifications", comment: ""),
            message: NSLocalizedString("Cancelled all available notifications set for events", comment: "")
        )
    }
    
    func rescheduleNotifications(previousOffset: Int, newOffset: Int) -> Void {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.notificationManager.rescheduleEventNotifications(
                previousOffset: previousOffset,
                userOffset: newOffset
            )
        }
    }
    
    
    func scheduleNotificationsForAllEvents(allEvents: [Event]) {
        guard !allEvents.isEmpty else {
            makeToast(
                type: .error,
                title: NSLocalizedString("Error", comment: ""),
                message: NSLocalizedString("Failed to set notifications for all available events", comment: "")
            )
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            
            let totalNotifications = allEvents.count
            var scheduledNotifications = 0
            
            for event in allEvents {
                guard let notification = self.notificationManager.createNotificationFromEvent(
                    event: event
                ) else {
                    AppLogger.shared.critical("Could not set notification for event \(event._id)")
                    self.makeToast(
                        type: .error,
                        title: NSLocalizedString("Error", comment: ""),
                        message: NSLocalizedString("Failed to set notifications for all available events", comment: "")
                    )
                    break
                }
                
                self.notificationManager.scheduleNotification(
                    for: notification,
                    type: .event,
                    userOffset: self.preferenceService.getNotificationOffset()
                ) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let success):
                        scheduledNotifications += 1
                        AppLogger.shared.debug("\(success) notification set")
                        
                        if scheduledNotifications == totalNotifications {
                            self.makeToast(
                                type: .success,
                                title: NSLocalizedString("Scheduled notifications", comment: ""),
                                message: NSLocalizedString("Scheduled notifications for all available events", comment: "")
                            )
                        }
                    case .failure(let failure):
                        AppLogger.shared.critical("\(failure)")
                    }
                }
            }
        }
    }
    
    private func deleteAllSchedules() {
        do {
            let realm = try Realm()
            let schedules = realm.objects(Schedule.self)
            try realm.write {
                realm.delete(schedules)
            }
            
        } catch (let error) {
            AppLogger.shared.error("Error deleting schedules: \(error)")
        }
    }

    
    func changeSchool(schoolId: Int) -> Void {
        if schoolIsAlreadySelected(schoolId: schoolId) {
            return
        }
        deleteAllSchedules()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.userController.logOut()
            self.preferenceService.setSchool(id: schoolId)
            self.notificationManager.cancelNotifications()
        }
        makeToast(
            type: .success,
            title: NSLocalizedString("New school", comment: ""),
            message: String(
                format: NSLocalizedString("Set %@ to default", comment: ""),
                self.schoolName
            ))
    }
    
    func makeToast(type: ToastStyle, title: String, message: String) -> Void {
        DispatchQueue.main.async {
            AppController.shared.toast = Toast(
                type: type,
                title: title,
                message: message)
        }
    }
    
    private func schoolIsAlreadySelected(schoolId: Int) -> Bool {
        if schoolId == self.schoolId {
            makeToast(
                type: .info,
                title: NSLocalizedString("School already selected", comment: ""),
                message: String(
                    format: NSLocalizedString("You already have '%@' as your default school", comment: ""),
                    schoolName
                ))
            return true
        }
        return false
    }
    
}

