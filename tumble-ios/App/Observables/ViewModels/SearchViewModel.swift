//
//  SearchView-ViewModel.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/17/22.
//

import Foundation
import SwiftUI

@MainActor final class SearchViewModel: ObservableObject {
    
    @Inject var courseColorService: CourseColorService
    @Inject var scheduleService: ScheduleService
    @Inject var preferenceService: PreferenceService
    @Inject var kronoxManager: KronoxManager
    @Inject var notificationManager: NotificationManager
    @Inject var schoolManager: SchoolManager
    
    @Published var status: SearchStatus = .initial
    @Published var programmeSearchResults: [Response.Programme] = []
    @Published var scheduleForPreview: Response.Schedule? = nil
    @Published var scheduleListOfDays: [DayUiModel]? = nil
    @Published var presentPreview: Bool = false
    @Published var schedulePreviewStatus: SchedulePreviewStatus = .loading
    @Published var schedulePreviewIsSaved: Bool = false
    @Published var courseColors: [String : String]? = nil
    @Published var school: School?
    @Published var errorMessagePreview: String? = nil
    @Published var errorMessageSearch: String? = nil
    @Published var previewButtonState: ButtonState = .loading
    
    
    
    init() {
        self.school = preferenceService.getDefaultSchoolName(schools: schoolManager.getSchools())
    }
    
    
    func update() -> Void {
        self.presentPreview = false
        self.status = .initial
        self.scheduleForPreview = nil
        self.programmeSearchResults.removeAll()
        self.courseColors = nil
        self.school = preferenceService.getDefaultSchoolName(schools: schoolManager.getSchools())
    }
    
    
    // When user presses a programme card
    func onOpenProgrammeSchedule(programmeId: String) -> Void {

        // Set sheet view as loading and reset possible old
        // value for the save button
        self.schedulePreviewIsSaved = false
        self.schedulePreviewStatus = .loading
        self.presentPreview = true
        self.scheduleForPreview = nil
        
        // Check if schedule is already saved, to set flag
        self.checkSavedSchedule(programmeId: programmeId) {
            
            // Always get latest schedule
            self.fetchSchedule(programmeId: programmeId) { fetchedSchedule in
                if fetchedSchedule {
                    // If the schedule is saved just make sure all colors are available
                    // and loaded into view
                    if self.schedulePreviewIsSaved {
                        self.loadProgrammeCourseColors { courseColors in
                            DispatchQueue.main.async {
                                self.courseColors = courseColors
                                self.previewButtonState = .saved
                                self.schedulePreviewStatus = .loaded
                            }
                        }
                    }
                    // Otherwise load random course colors
                    else {
                        self.assignRandomCourseColors { [weak self] (result: Result<[String : String], Error>) in
                            guard let self = self else { return }
                            switch result {
                            case .success(let courseColors):
                                // Assign possibly updated course colors
                                self.courseColors = courseColors
                                self.previewButtonState = .notSaved
                                self.schedulePreviewStatus = .loaded
                            case .failure(let failure):
                                AppLogger.shared.debug("\(failure)")
                                self.schedulePreviewStatus = .error
                            }
                            
                        }
                    }
                } else {
                    self.schedulePreviewStatus = .error
                    return
                }
            }
        }
    }
    
    
    func onSearchProgrammes(searchQuery: String) -> Void {
        self.status = .loading
        let _ = kronoxManager.get(.searchProgramme(
            searchQuery: searchQuery,
            schoolId: String(school!.id))) { [weak self] (result: Result<Response.Search, Response.ErrorMessage>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.parseSearchResults(result)
                case .failure(let failure):
                    switch failure.statusCode {
                    case 204:
                        self.errorMessageSearch = NSLocalizedString("There are no schedules that match your search", comment: "")
                        self.status = SearchStatus.error
                    default:
                        self.errorMessageSearch = NSLocalizedString("Something went wrong", comment: "")
                        self.status = SearchStatus.error
                    }
                    AppLogger.shared.debug("Encountered error when trying to search for programme \(searchQuery): \(failure)")
                }
        }
    }
    
    
    func onClearSearch(endEditing: Bool) -> Void {
        if (endEditing) {
            self.programmeSearchResults = []
            self.status = .initial
        }
    }
    
    
    func onBookmark(
        updateButtonState: @escaping () -> Void,
        checkForNewSchedules: @escaping () -> Void) -> Void {
            self.previewButtonState = .loading
            // If the schedule isn't already saved in the local database
            if !self.schedulePreviewIsSaved {
                self.saveSchedule(completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.preferenceService.setBookmarks(bookmark: self.scheduleForPreview!.id)
                        self.previewButtonState = .saved
                        updateButtonState()
                        checkForNewSchedules()
                        return
                    case .failure:
                        self.schedulePreviewStatus = .error
                    }
                })
            }
            // Otherwise we remove (untoggle) the schedule
            else {
                self.loadSchedules { [weak self] schedules in
                    guard let self = self else { return }
                    self.cancelNotifications(for: schedules, with: self.scheduleForPreview?.id)
                    self.removeSchedule(completion: { result in
                        switch result {
                        case .success:
                            self.previewButtonState = .notSaved
                            updateButtonState()
                            checkForNewSchedules()
                            return
                        case .failure:
                            self.schedulePreviewStatus = .error
                        }
                    })
                }
            }
    }

    
    func resetSearchResults() -> Void {
        self.programmeSearchResults = []
        self.status = .initial
    }
    
}
