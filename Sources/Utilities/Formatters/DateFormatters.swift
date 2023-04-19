//
//  DateFormatters.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-04-01.
//

import Foundation

/// Formatters used globally

/// To convert API result date (ISO8601) to `Date`
var isoDateFormatterFract: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    let timeZone = TimeZone.current
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    formatter.timeZone = timeZone
    return formatter
}()

/// Used on event dates
var dateFormatterEvent: DateFormatter = {
    let eventDateFormatter = DateFormatter()
    let timeZone = TimeZone.current
    eventDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    eventDateFormatter.timeZone = timeZone
    return eventDateFormatter
}()

var dateFormatterComma: DateFormatter = {
    let formatter = DateFormatter()
    let timeZone = TimeZone.current
    formatter.dateFormat = "EEEE, MMMM d, yyyy"
    formatter.timeZone = timeZone
    return formatter
}()

var dateFormatterFull: DateFormatter = {
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

var dateFormatterSemi: DateFormatter = {
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

var isoDateFormatterDashed: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    let timeZone = TimeZone.current
    formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
    formatter.timeZone = timeZone
    return formatter
}()

var isoDateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    let timeZone = TimeZone.current
    formatter.timeZone = timeZone
    return formatter
}()

var isoDateFormatterResourceDate: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    return formatter
}()

var isoDateFormatterSemi: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    let timeZone = TimeZone.current
    formatter.formatOptions = [.withFullDate, .withTimeZone]
    formatter.timeZone = timeZone
    return formatter
}()

var dateFormatterUTC: DateFormatter = {
    let formatter = DateFormatter()
    let timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.timeZone = timeZone
    return formatter
}()

var dateFormatterLong: DateFormatter = {
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone.current
    dateFormatter.dateStyle = .long
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()