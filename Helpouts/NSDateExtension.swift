//
//  NSDateExtension.swift
//  Helpouts
//
//  Created by Fabian Schilling on 4/19/15.
//  Copyright (c) 2015 Fabian Schilling. All rights reserved.
//

import Foundation

struct Weekday {
    static let Monday = "Monday"
    static let Tuesday = "Tuesday"
    static let Wednesday = "Wednesday"
    static let Thursday = "Thursday"
    static let Friday = "Friday"
    static let Saturday = "Saturday"
    static let Sunday = "Sunday"
    static let Someday = "Someday"
    static let Yesterday = "Yesterday"
}

extension Date {
    
    var humanReadable: String {
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60 // seconds in a minute
        let deltaHours = deltaMinutes / 60 // minutes in an hour
        let deltaDays = deltaHours / 24 // hours in a day
        let deltaWeeks = deltaDays / 7 // days in a week
        
        if deltaWeeks > 0 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: self)
        } else if deltaDays > 0 {
            if deltaDays == 1 {
                return Weekday.Yesterday
            }
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let weekdayComponents = calendar.components(.CalendarUnitWeekday, fromDate: self)
            switch weekdayComponents.weekday {
                case 1: return Weekday.Sunday
                case 2: return Weekday.Monday
                case 3: return Weekday.Tuesday
                case 4: return Weekday.Wednesday
                case 5: return Weekday.Thursday
                case 6: return Weekday.Friday
                case 7: return Weekday.Saturday
            default: return Weekday.Someday
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: self)
        }
    }
    
    var elapsed: String {
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60 // seconds in a minute
        let deltaHours = deltaMinutes / 60 // minutes in an hour
        let deltaDays = deltaHours / 24 // hours in a day
        let deltaWeeks = deltaDays / 7 // days in a week
        let deltaMonths = deltaWeeks / 4 // weeks in a month
        let deltaYears = deltaMonths / 12 // months in a year
        
        if deltaYears > 0 {
            if deltaYears == 1 {
                return "1 year ago"
            } else {
                return "\(deltaYears) years ago"
            }
        } else if deltaMonths > 0 {
            if deltaMonths == 1 {
                return "1 month ago"
            } else {
                return "\(deltaMonths) months ago"
            }
        } else if deltaWeeks > 0 {
            if deltaWeeks == 1 {
                return "1 week ago"
            } else {
                return "\(deltaWeeks) weeks ago"
            }
        } else if deltaDays > 0 {
            if deltaDays == 1 {
                return "1 day ago"
            } else {
                return "\(deltaDays) days ago"
            }
        } else if deltaHours > 0 {
            if deltaHours == 1 {
                return "1 hour ago"
            } else {
                return "\(deltaHours) hours ago"
            }
        } else if deltaMinutes > 0 {
            if deltaMinutes == 1 {
                return "1 minute ago"
            } else {
                return "\(deltaMinutes) minutes ago"
            }
        } else if deltaSeconds > 0 {
            if deltaSeconds == 1{
                return "1 second ago"
            } else {
                return "\(deltaSeconds) seconds ago"
            }
        } else {
            return "just now"
        }
    }
}
