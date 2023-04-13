//
//  SettingsViewModelExtension.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-04-01.
//

import Foundation

extension SettingsViewModel {
    
    func loadSchedules(completion: @escaping ([ScheduleData]) -> Void) -> Void {
        self.scheduleService.load(completion: {result in
            switch result {
            case .failure(_):
                return
            case .success(let bookmarks):
                DispatchQueue.main.async {
                    completion(bookmarks)
                }
            }
        })
    }
    
    func missingIDs(scheduleModels: [ScheduleData], bookmarks: [Bookmark]) -> [String] {
        let scheduleIDs = Set(scheduleModels.map { $0.id })
        let bookmarkIDs = Set(bookmarks.map { $0.id })
        return Array(bookmarkIDs.subtracting(scheduleIDs))
    }
    
    func setNewBookmarks(schedules: [ScheduleData], completion: @escaping ([Bookmark]) -> Void) -> Void {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            // Get current bookmarks in preferences
            var bookmarks = self.preferenceService.getBookmarks() ?? []
            
            // Find the one's that aren't supposed to be there
            let missingIds = self.missingIDs(scheduleModels: schedules, bookmarks: bookmarks)
            
            // Remove the missing id's
            bookmarks = self.removeMissingIDs(bookmarks: bookmarks, missingIDs: missingIds)
            
            self.preferenceService.setBookmarks(bookmarks: bookmarks)
            
            DispatchQueue.main.async {
                completion(bookmarks)
            }
        }
    }

    func removeMissingIDs(bookmarks: [Bookmark], missingIDs: [String]) -> [Bookmark] {
        return bookmarks.filter { !missingIDs.contains($0.id) }
    }
}
