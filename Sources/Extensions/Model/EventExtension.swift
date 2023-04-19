//
//  EventExtension.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-09.
//

import Foundation

extension Event {
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["title"] = self.title
        dictionary["from"] = self.from
        dictionary["to"] = self.to
        dictionary["eventId"] = self.eventId
        dictionary["isSpecial"] = self.isSpecial
        dictionary["lastModified"] = self.lastModified
        
        var courseDict: [String: String] = [:]
        courseDict["englishName"] = self.course?.englishName
        courseDict["swedishName"] = self.course?.englishName
        courseDict["courseId"] = self.course?.courseId
        courseDict["color"] = self.course?.color
        dictionary["course"] = courseDict
        
        var locationsArray: [[String: Any]] = []
        for location in self.locations {
            var locationDict: [String: Any] = [:]
            locationDict["name"] = location.name
            locationDict["locationId"] = location.locationId
            locationDict["building"] = location.building
            locationDict["floor"] = location.floor
            locationDict["maxSeats"] = location.maxSeats // Int
            locationsArray.append(locationDict)
        }
        dictionary["locations"] = locationsArray
        
        var teachersArray: [[String: String]] = []
        for teacher in self.teachers {
            var teacherDict: [String: String] = [:]
            teacherDict["firstName"] = teacher.firstName
            teacherDict["lastName"] = teacher.lastName
            teacherDict["teacherId"] = teacher.teacherId
            teachersArray.append(teacherDict)
        }
        dictionary["teachers"] = teachersArray
        
        return dictionary
    }
    
    func isValidEvent() -> Bool {
        let today = Date()
        guard let eventStartDate = dateFormatterEvent.date(from: self.from) else { return false }
        return Calendar.current.startOfDay(for: eventStartDate) >= Calendar.current.startOfDay(for: today)
    }
}

extension [Event] {
    
    func sorted() -> [Event] {
        return self.sorted(by: {
            // Ascending order
            return dateFormatterEvent.date(from: $0.from)! < dateFormatterEvent.date(from: $1.from)!
        })
    }
}