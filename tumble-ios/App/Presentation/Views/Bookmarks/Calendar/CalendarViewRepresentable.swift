//
//  CalendarViewRepresentable.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-03-22.
//

import Foundation
import FSCalendar
import SwiftUI

struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    @Binding var selectedDate: Date
    @Binding var displayedDayEvents: [Response.Event]
    
    let calendar = FSCalendar()
    let days: [DayUiModel]
    let courseColors: CourseAndColorDict
    lazy var eventsByDate: [Date: [Response.Event]] = makeCalendarEvents()
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.locale = Locale(identifier: "en")
        calendar.appearance.weekdayTextColor = UIColor(named: "OnBackground")?.withAlphaComponent(0.7)
        calendar.appearance.titleDefaultColor = UIColor(named: "OnBackground")
        calendar.appearance.selectionColor = UIColor(named: "PrimaryColor")
        calendar.appearance.titleTodayColor = UIColor(named: "OnPrimary")
        calendar.appearance.todayColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.5)
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 20)
        calendar.appearance.headerTitleFont = UIFont(
            descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle), size: 25)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 30, weight: .black)
        calendar.appearance.headerTitleColor = UIColor(named: "OnBackground")
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.appearance.eventDefaultColor = UIColor(named: "PrimaryColor")
        calendar.appearance.eventSelectionColor = UIColor(named: "PrimaryColor")
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.clipsToBounds = false
        calendar.firstWeekday = 2
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
            uiView.scope = .month
            uiView.locale = Locale(identifier: "en")
            uiView.firstWeekday = 2
        uiView.appearance.weekdayTextColor = UIColor(named: "OnBackground")?.withAlphaComponent(0.7)
            uiView.appearance.titleDefaultColor = UIColor(named: "OnBackground")
            uiView.appearance.selectionColor = UIColor(named: "PrimaryColor")
            uiView.appearance.titleTodayColor = UIColor(named: "OnPrimary")
            uiView.appearance.todayColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.5)
            uiView.appearance.titleFont = .boldSystemFont(ofSize: 20)
            uiView.appearance.headerTitleFont = UIFont(
                descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle), size: 30)
            uiView.appearance.headerMinimumDissolvedAlpha = 0.12
            uiView.appearance.headerTitleFont = .systemFont(ofSize: 30, weight: .black)
            uiView.appearance.headerTitleColor = UIColor(named: "OnBackground")
            uiView.appearance.headerDateFormat = "MMMM"
        
            uiView.appearance.eventDefaultColor = UIColor(named: "PrimaryColor")
            uiView.appearance.eventSelectionColor = UIColor(named: "PrimaryColor")
        }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeCalendarEvents() -> [Date : [Response.Event]] {
        var dict = [Date: [Response.Event]]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for day in days {
            for event in day.events {
                if let date = dateFormatterEvent.date(from: event.from) {
                    let normalizedDate = Calendar.current.startOfDay(for: date)
                    if dict[normalizedDate] == nil {
                        dict[normalizedDate] = [event]
                    } else {
                        dict[normalizedDate]?.append(event)
                    }
                }
            }
        }
        return dict
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        
        var parent: CalendarViewRepresentable
        var displayedDayEventsByDate: [Date: [Response.Event]] = [:]
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        /// Set cell indicators on individual calendar cells,
        /// to display amount of events for a single date before pressing it
        func calendar(
                _ calendar: FSCalendar,
                willDisplay cell: FSCalendarCell,
                for date: Date, at monthPosition: FSCalendarMonthPosition) {
                    let filteredEvents = displayedDayEventsByDate[date] ?? []
                    cell.eventIndicator.isHidden = false
                    cell.eventIndicator.numberOfEvents = filteredEvents.count
            }
        
        /// Handle the click of a date cell
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            parent.displayedDayEvents = displayedDayEventsByDate[date] ?? []
            
            for cell in parent.calendar.visibleCells() {
                if let cellDate = parent.calendar.date(for: cell) {
                    let filteredEvents = displayedDayEventsByDate[cellDate] ?? []
                    cell.eventIndicator.isHidden = false
                    cell.eventIndicator.numberOfEvents = filteredEvents.count
                }
            }
        }

        /// Calculate number of events for a specific cell
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let filteredEvents = parent.eventsByDate[date] ?? []
            displayedDayEventsByDate[date] = filteredEvents
            return filteredEvents.count
        }

        
        /// All date cells are clickable
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            return true
        }
        
        func maximumDate(for calendar: FSCalendar) -> Date {
            let sixMonths = DateComponents(month: 6)
            return Calendar.current.date(byAdding: sixMonths, to: Date()) ?? Date()
        }

        
        func minimumDate(for calendar: FSCalendar) -> Date {
            Date.now
        }
    }
}
