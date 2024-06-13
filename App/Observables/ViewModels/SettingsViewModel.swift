//
//  SettingsViewModel.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-02-08.
//

import Combine
import Foundation
import RealmSwift
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Inject var preferenceService: PreferenceService
    @Inject var userController: UserController
    @Inject var notificationManager: NotificationManager
    @Inject var schoolManager: SchoolManager
    @Inject var realmManager: RealmManager
    
    @Published var bookmarks: [Bookmark]?
    @Published var presentSidebarSheet: Bool = false
    @Published var authStatus: AuthStatus = .unAuthorized
    
    @Published var currentUserName: String? = nil
    @Published var allUserAccounts: [String:Int] = [String:Int]()
    
    let popupFactory: PopupFactory = PopupFactory.shared
    private lazy var schools: [School] = schoolManager.getSchools()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setUpDataPublishers()
    }
    
    private func setUpDataPublishers() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let allUserAccountsPublisher = preferenceService.$allUserAccounts.receive(on: RunLoop.main)
            let currentUserPublisher = userController.$user.receive(on: RunLoop.main)
            
            Publishers.CombineLatest(allUserAccountsPublisher, currentUserPublisher)
                .sink { allUserAccounts, currentUser in
                    self.allUserAccounts = allUserAccounts
                    self.currentUserName = currentUser?.username
                }
                .store(in: &cancellables)
            
            allUserAccountsPublisher
                .removeDuplicates()
                .sink { allUserAccounts in
                    self.allUserAccounts = allUserAccounts
                }
                .store(in: &cancellables)
        }
    }
    
    func removeUserAccount(username: String) {
        Task.detached(priority: .userInitiated) { [weak self] in
            try await self?.userController.logOut(username: username)
            self?.preferenceService.removeUserAccount(username: username)
        }
    }
    
    func changeUser(newUser: String) {
        Task.detached(priority: .userInitiated) { [weak self] in
            self?.preferenceService.updateMostRecentUser(to: newUser)
            await self?.userController.autoLogin()
        }
    }
    
    func removeNotifications(for id: String, referencing events: [Event]) {
        events.forEach { notificationManager.cancelNotification(for: $0.eventId) }
    }
    
    func clearAllNotifications() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.notificationManager.cancelNotifications()
        }
        PopupToast(popup: popupFactory.clearNotificationsAllEventsSuccess()).showAndStack()
    }
    
    func rescheduleNotifications(previousOffset: Int, newOffset: Int) {
        Task {
            do {
                try await notificationManager.rescheduleEventNotifications(
                    previousOffset: previousOffset,
                    userOffset: newOffset
                )
            } catch {
                // TODO: Show toast
                AppLogger.shared.error("Could not reschedule notifications")
            }
        }
    }
    
    func scheduleNotificationsForAllEvents(allEvents: [Event]) async {
        guard !allEvents.isEmpty else {
            PopupToast(popup: popupFactory.setNotificationsAllEventsFailed()).showAndStack()
            return
        }
        
        let totalNotifications = allEvents.count
        var scheduledNotifications = 0
        
        for event in allEvents {
            guard let notification = notificationManager.createNotificationFromEvent(
                event: event
            ) else {
                AppLogger.shared.error("Could not set notification for event \(event._id)")
                PopupToast(popup: popupFactory.setNotificationsAllEventsFailed()).showAndStack()
                return
            }
            
            do {
                try await notificationManager.scheduleNotification(
                    for: notification,
                    type: .event,
                    userOffset: preferenceService.getNotificationOffset()
                )
                scheduledNotifications += 1
                AppLogger.shared.debug("One notification set")
                
                if scheduledNotifications == totalNotifications {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        PopupToast(popup: self.popupFactory.setNotificationsAllEventsSuccess()).showAndStack()
                    }
                }
            } catch let failure {
                AppLogger.shared.error("\(failure)")
                // TODO: Show toast
            }
        }
    }

    
    func deleteBookmark(schedule: Schedule) {
        realmManager.deleteSchedule(schedule: schedule)
    }
    
    private func deleteAllSchedules() {
        realmManager.deleteAllSchedules()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }

}
