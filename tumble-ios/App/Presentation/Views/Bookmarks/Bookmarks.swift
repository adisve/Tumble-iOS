//
//  SchedulePageMainView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/21/22.
//

import SwiftUI

struct Bookmarks: View {
    
    @ObservedObject var viewModel: BookmarksViewModel
    @ObservedObject var parentViewModel: ParentViewModel
    @ObservedObject var appController: AppController
    
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                Picker("ViewType", selection: $viewModel.defaultViewType) {
                    ForEach(viewModel.scheduleViewTypes, id: \.self) {
                        Text(NSLocalizedString($0.displayName, comment: ""))
                            .foregroundColor(.onSurface)
                            .font(.caption)
                    }
                }
                .onChange(of: viewModel.defaultViewType) { defaultViewType in
                    viewModel.onChangeViewType(viewType: defaultViewType)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(.primary)
                
                switch viewModel.status {
                case .loading:
                    Spacer()
                    HStack {
                        Spacer()
                        CustomProgressIndicator()
                        Spacer()
                    }
                    Spacer()
                case .loaded:
                    switch viewModel.defaultViewType {
                    case .list:
                        BookmarkListView(
                            days: viewModel.scheduleListOfDays,
                            courseColors: viewModel.courseColors,
                            appController: appController
                        )
                        
                    case .calendar:
                        BookmarkCalendarView(
                            days: $viewModel.scheduleListOfDays,
                            courseColors: viewModel.courseColors,
                            appController: appController
                        )
                    }
                case .uninitialized:
                    Info(title: NSLocalizedString("No bookmarks yet", comment: ""), image: "bookmark.slash")
                case .error:
                    Info(title: NSLocalizedString("There was an error retrieving your schedules", comment: ""), image: "exclamationmark.circle")
                case .hiddenAll:
                    Info(title: NSLocalizedString("All your bookmarks are hidden", comment: ""), image: "bookmark.slash")
                }
            }
        }
        .background(Color.background)
        .padding(.bottom, -10)
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        /// Event sheet for both when a notification has been opened outside
        /// the application by the user and when triggered on click of event card.
        /// The shared eventSheet value is changed from AppDelegate and launched here,
        /// as well as in this view if an event is pressed.
        .sheet(item: $appController.eventSheet) { (eventSheet: EventDetailsSheetModel) in
            EventDetailsSheet(
                viewModel: viewModel.generateViewModelEventSheet(
                    event: eventSheet.event,
                    color: eventSheet.color),
                updateCourseColors: updateCourseColors)
        }
    }
    
    func updateCourseColors() -> Void {
        self.parentViewModel.delegateUpdateColorsBookmarks()
    }

    
}
