//
//  NSDate_extension.swift
//  
//
//  Created by Don Willems on 08/12/15.
//
//

import Foundation


/**
 Instances of this class represent a moment in time as a date (and time) in a Gregorian Calendar.
 A `GregorianDate` may represent a specific moment with date and time with a precision up to a nanosecond, but
 may also represent a whole day, month, or even year. Furthermore, they may also represent a recurrent time, 
 for instance, 12:34 AM every day, or the second day of a month.
 
 This class can be used to specify values of all the different date and time datatypes as specified in the
 [XML Schema specification for datatypes](http://www.w3.org/TR/xmlschema-2/) such as `XSD.dateTime`,
 `XSD.gYear` or `XSD.gDay`.
 */
public class GregorianDate : CustomStringConvertible {
    
    // regex dateTime pattern: ^((?:[+-]?)(?:\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))T((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\.\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$
    private static let dateTimePattern = "^((?:[+-]?)(?:\\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))T((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\\.\\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let datePattern = "^((?:[+-]?)(?:\\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let gYearMonthPattern = "^((?:[+-]?)(?:\\d*))-((?:0[1-9])|(?:1[0-2]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let gYearPattern = "^((?:[+-]?)(?:\\d{4,}))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let timePattern = "^((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\\.\\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let gMonthDayPattern = "^--((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let gMonthPattern = "^--((?:0[1-9])|(?:1[0-2]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    private static let gDayPattern = "^---((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))?$"
    
    private static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    /**
     A textual description of the `GregorianDate`. If it has a XSD datatype, the textual representation for
     that datatype is used in the textual representation.
     */
    public var description : String {
        get {
            let datatype = XSDDataType
            if datatype == nil {
                return "GregorianDate"
            }
            var descr : String? = nil
            if datatype! == XSD.dateTime {
                descr = dateTime
            }else if datatype! == XSD.date {
                descr = date
            }else if datatype! == XSD.gYearMonth {
                descr = gYearMonth
            }else if datatype! == XSD.gYear {
                descr = gYear
            }else if datatype! == XSD.time {
                descr = time
            }else if datatype! == XSD.gMonthDay {
                descr = gMonthDay
            }else if datatype! == XSD.gMonth {
                descr = gMonth
            }else if datatype! == XSD.gDay {
                descr = gDay
            }
            if descr == nil {
                return "GregorianDate"
            }
            return descr!
        }
    }
    
    // MARK: Date component properties
    
    /// The year component of the `GregorianDate`. If this value is `nil`, the date/time will be a recurring date/time.
    public private(set) var year : Int?
    
    /// The month component of the `GregorianDate`.
    public private(set) var month : Int?
    
    /// The day component of the `GregorianDate`.
    public private(set) var day : Int?
    
    /// The hour component of the `GregorianDate`.
    public private(set) var hour : Int?
    
    /// The minute component of the `GregorianDate`.
    public private(set) var minute : Int?
    
    /// The second component of the `GregorianDate`.
    public private(set) var second : Double?
    
    /// The timezone used for this `GregorianDate`.
    public private(set) var timezone : NSTimeZone?
    
    
    
    
    // MARK: Time span components
    
    /**
     The start date of the `GregorianDate` is the date at which the moment represented by the `GregorianDate` starts.
     If the `GregorianDate` is a recurring date/time, the start date of the next occurrence will be returned, or if
     the recurring date/time is ongoing at the moment, the current start date will be returned.
    
     A `GregorianDate` can have a start and end time when for instance only a date and not the time of day is specified.
     In this case the duration of the `GregorianDate` will be one day.
     */
    public var startDate : NSDate? {
        get {
            if year != nil {
                let components = NSDateComponents()
                components.year = year!
                if month != nil {
                    components.month = month!
                    if day != nil {
                        components.day = day!
                        if hour != nil && minute != nil && second != nil { // xsd:dateTime
                            components.hour = hour!
                            components.minute = minute!
                            components.second = Int(second!)
                            let ns = Int((second!-Double(Int(second!)))*1e9)
                            components.nanosecond = ns
                        } else { // xsd:date
                            components.hour = 0
                            components.minute = 0
                            components.second = 0
                        }
                    } else { // xsd:gYearMonth
                        components.day = 1
                    }
                } else { // xsd:gYear
                    components.month = 1
                }
                if timezone != nil {
                    GregorianDate.calendar.timeZone = timezone!
                } else {
                    GregorianDate.calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                }
                let date = GregorianDate.calendar.dateFromComponents(components)
                return date
            } else {
                if isRecurringNow {
                    return previousStartTime
                } else {
                    return nextStartTime
                }
            }
        }
    }
    
    /**
     The end date of the `GregorianDate` is the date at which the moment represented by the `GregorianDate` ends.
     If the `GregorianDate` is a recurring date/time, the end date of the next occurrence will be returned, or if
     the recurring date/time is ongoing at the moment, the current end date will be returned.
     
     A `GregorianDate` can have a start and end time when for instance only a date and not the time of day is specified.
     In this case the duration of the `GregorianDate` will be one day.
     */
    public var endDate : NSDate? {
        get {
            if duration == nil {
                return nil
            }
            return self.addDuration(duration!)?.startDate
        }
    }
    
    /**
     The duration of the moment represented by the `GregorianDate`. A `GregorianDate` has a duration when for instance 
     only a date and not the time of day is specified.
     In this case the duration of the `GregorianDate` will be one day.
     */
    public var duration : Duration? {
        get {
            if second != nil {
                return Duration(positive: true, years: 0, months: 0, days: 0, hours: 0, minutes: 0, seconds: 1)
            } else if minute != nil {
                return Duration(positive: true, years: 0, months: 0, days: 0, hours: 0, minutes: 1, seconds: 0)
            } else if hour != nil {
                return Duration(positive: true, years: 0, months: 0, days: 0, hours: 1, minutes: 0, seconds: 0)
            } else if day != nil {
                return Duration(positive: true, years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0)
            } else if month != nil {
                return Duration(positive: true, years: 0, months: 1, days: 0, hours: 0, minutes: 0, seconds: 0)
            } else if year != nil {
                return Duration(positive: true, years: 1, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0)
            }
            return nil
        }
    }
    
    
    // MARK: Recurring dates and times
    
    /**
     This property is true when the Gregorian data represents, not a specifc moment in time, but  a recurring 
     moment in time such as a specific time of day that recurs every day (`XSD.time`) or a specific month in
     a year (`XSD.gMonth`) that recurs every year. 
    
     This implementation checks whether the optional parameter `year` is `nil`. If this is true, the Gregorian 
     Date is a recurring time or date.
     */
    public var isRecurring : Bool {
        get {
            return (year == nil)
        }
    }
    
    /**
     This property is true when the Gregorian Date is at this moment in time occurring or recurring. For instance
     when the Gregorian date is a date that recurs every 5th day of the month and today is the 5th of December,
     this property will be `true`.
     */
    public var isRecurringNow : Bool {
        return isRecurringAt(NSDate())
    }
    
    /**
     The first (non-recurring) Gregorian Date occurrence of this (possibly recurring) Gregorigan Date in the future. 
     See also: `previousGregorianDate`, `nextStartTime`, `previousGregorianDateBefore(_:)`, and `nextStartTimeAfter(_:)`.
     */
    public var nextGregorianDate : GregorianDate? {
        return nextGregorianDateAfter(NSDate())
    }
    
    /**
     The last (non-recurring) Gregorian Date occurrence of this (possibly recurring) Gregorigan Date in the past.
     If the Gregorian date is occurring at this moment, the current occurrence is returned. 
     See also: `nextGregorianDate`, `previousStartTime`, `previousGregorianDateBefore(_:)`, and `previousStartTimeBefore(_:)`.
     */
    public var previousGregorianDate : GregorianDate? {
        return previousGregorianDateBefore(NSDate())
    }
    
    /**
     The first start time of the Gregorian Date in the future.
     See also: `nextGregorianDate`, `previousStartTime`, `nextGregorianDateAfter(_:)`, and `nextStartTimeAfter(_:)`.
     */
    public var nextStartTime : NSDate? {
        return nextStartTimeAfter(NSDate())
    }
    
    /**
     The first end time of the Gregorian Date after the next start time (see `nextStartTime`).
     See also: `nextGregorianDate`, `previousEndTime`, `nextGregorianDateAfter(_:)`, and `nextEndTimeAfter(_:)`.
     */
    public var nextEndTime : NSDate? {
        let stime = nextStartTimeAfter(NSDate())
        if stime != nil {
            return nextEndTimeAfter(stime!)
        }
        return nil
    }
    
    /**
     The last start time of the Gregorian Date in the past.
     See also: `previousGregorianDate`, `nextStartTime`, `previousGregorianDateBefore(_:)`, and `previousStartTimeBefore(_:)`.
     */
    public var previousStartTime : NSDate? {
        let etime = previousEndTimeBefore(NSDate())
        if etime != nil {
            return previousStartTimeBefore(etime!)
        }
        return nil
    }
    
    /**
     The last end time of the Gregorian Date after the previous start time (see `previousStartTime`).
     See also: `previousGregorianDate`, `nextEndTime`, `previousGregorianDateBefore(_:)`, and `previousEndTimeBefore(_:)`.
     */
    public var previousEndTime : NSDate? {
        return previousEndTimeBefore(NSDate())
    }
    
    // MARK: XSD string representations
    
    /**
     The XSD data type for this Gregorian date. The `GregorianDate` class can represent all (recurring) date and
     time data types specified in the [XML Schema specification for datatypes](http://www.w3.org/TR/xmlschema-2/),
     such as `XSD.dateTime`, `XSD.date`, `XSD.gYearMonth`, `XSD.gYear`, and the recurring dates/times `XSD.time`,
     `XSD.gMonthDay`, `XSD.gMonth`, and `XSD.gDay`.
     */
    public var XSDDataType : Datatype? {
        get {
            if year != nil {
                if month != nil {
                    if day != nil {
                        if hour != nil && minute != nil && second != nil {
                            return XSD.dateTime
                        } else {
                            return XSD.date
                        }
                    } else {
                        return XSD.gYearMonth
                    }
                } else {
                    return XSD.gYear
                }
            }else if hour != nil && minute != nil && second != nil {
                return XSD.time
            }else if month != nil && day != nil {
                return XSD.gMonthDay
            }else if month != nil {
                return XSD.gMonth
            }else if day != nil {
                return XSD.gDay
            }
            return nil
        }
    }
    
    /**
     The `xsd:dateTime` textual representation of the `GregorianDate`. The textual representation is of the form:
     `±[year]-[month]-[day]T[hour]:[minute]:[second][timezone]`, e.g. `2015-12-14T11:29:54.2323+02:00`, or
     `-1203-03-02T23:12:04Z`. If `GregorianDate.XSDDataType` does not equal `XSD.dateTime`, this optional property
     will be `nil`.
     */
    public var dateTime : String? {
        get {
            if hour == nil || minute == nil || second == nil || day == nil || month == nil || year == nil {
                return nil
            }
            var dateTime = "\(year!)-"
            if month < 10 {
                dateTime += "0\(month!)-"
            } else {
                dateTime += "\(month!)-"
            }
            if day < 10 {
                dateTime += "0\(day!)"
            } else {
                dateTime += "\(day!)"
            }
            dateTime += "T"
            if hour < 10 {
                dateTime += "0\(hour!):"
            } else {
                dateTime += "\(hour!):"
            }
            if minute < 10 {
                dateTime += "0\(minute!):"
            } else {
                dateTime += "\(minute!):"
            }
            if Double(Int(second!)) == second! {
                if second < 10 {
                    dateTime += "0\(Int(second!))"
                } else {
                    dateTime += "\(Int(second!))"
                }
            } else {
                if second < 10 {
                    dateTime += "0\(second!)"
                } else {
                    dateTime += "\(second!)"
                }
            }
            let components = NSDateComponents()
            components.year = year!
            components.month = month!
            components.day = day!
            components.hour = hour!
            components.minute = minute!
            components.second = Int(second!)
            components.nanosecond = Int(second!-Double(Int(second!))*1e9)
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:date` textual representation of the `GregorianDate`. The textual representation is of the form:
     `±[year]-[month]-[day][timezone]`, e.g. `2015-12-14+02:00`, or
     `-1203-03-02Z`. If `GregorianDate.XSDDataType` does not equal `XSD.date`, this optional property
     will be `nil`.
     */
    public var date : String? {
        get {
            if day == nil || month == nil || year == nil {
                return nil
            }
            var dateTime = "\(year!)-"
            if month < 10 {
                dateTime += "0\(month!)-"
            } else {
                dateTime += "\(month!)-"
            }
            if day < 10 {
                dateTime += "0\(day!)"
            } else {
                dateTime += "\(day!)"
            }
            let components = NSDateComponents()
            components.year = year!
            components.month = month!
            components.day = day!
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:gYearMonth` textual representation of the `GregorianDate`. The textual representation is of the form:
     `±[year]-[month][timezone]`, e.g. `2015-12+02:00`, or
     `-1203-03Z`. If `GregorianDate.XSDDataType` does not equal `XSD.gYearMonth`, this optional property
     will be `nil`.
     */
    public var gYearMonth : String? {
        get {
            if month == nil || year == nil {
                return nil
            }
            var dateTime = "\(year!)-"
            if month < 10 {
                dateTime += "0\(month!)"
            } else {
                dateTime += "\(month!)"
            }
            let components = NSDateComponents()
            components.year = year!
            components.month = month!
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:gYear` textual representation of the `GregorianDate`. The textual representation is of the form:
     `±[year][timezone]`, e.g. `2015+02:00`, or
     `-1203Z`. If `GregorianDate.XSDDataType` does not equal `XSD.gYear`, this optional property
     will be `nil`.
     */
    public var gYear : String? {
        get {
            if year == nil {
                return nil
            }
            var dateTime = "\(year!)"
            let components = NSDateComponents()
            components.year = year!
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:time` textual representation of the `GregorianDate`. The textual representation is of the form:
     `[hour]:[minute]:[second][timezone]`, e.g. `11:29:54.2323+02:00`, or
     `23:12:04Z`. If `GregorianDate.XSDDataType` does not equal `XSD.time`, this optional property
     will be `nil`.
     */
    public var time : String? {
        get {
            if hour == nil || minute == nil || second == nil {
                return nil
            }
            var dateTime = ""
            if hour < 10 {
                dateTime += "0\(hour!):"
            } else {
                dateTime += "\(hour!):"
            }
            if minute < 10 {
                dateTime += "0\(minute!):"
            } else {
                dateTime += "\(minute!):"
            }
            if Double(Int(second!)) == second! {
                if second < 10 {
                    dateTime += "0\(Int(second!))"
                } else {
                    dateTime += "\(Int(second!))"
                }
            } else {
                if second < 10 {
                    dateTime += "0\(second!)"
                } else {
                    dateTime += "\(second!)"
                }
            }
            let components = NSDateComponents()
            components.hour = hour!
            components.minute = minute!
            components.second = Int(second!)
            components.nanosecond = Int(second!-Double(Int(second!))*1e9)
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:gMonthDay` textual representation of the `GregorianDate`. The textual representation is of the form:
     `--[month]-[day][timezone]`, e.g. `--12-14+02:00`, or
     `--03-02Z`. If `GregorianDate.XSDDataType` does not equal `XSD.gMonthDay`, this optional property
     will be `nil`.
     */
    public var gMonthDay : String? {
        get {
            if day == nil || month == nil {
                return nil
            }
            var dateTime = "--"
            if month < 10 {
                dateTime += "0\(month!)-"
            } else {
                dateTime += "\(month!)-"
            }
            if day < 10 {
                dateTime += "0\(day!)"
            } else {
                dateTime += "\(day!)"
            }
            let components = NSDateComponents()
            components.month = month!
            components.day = day!
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:gMonth` textual representation of the `GregorianDate`. The textual representation is of the form:
     `--[month][timezone]`, e.g. `--12+02:00`, or
     `--03Z`. If `GregorianDate.XSDDataType` does not equal `XSD.gMonth`, this optional property
     will be `nil`.
     */
    public var gMonth : String? {
        get {
            if month == nil {
                return nil
            }
            var dateTime = "--"
            if month < 10 {
                dateTime += "0\(month!)"
            } else {
                dateTime += "\(month!)"
            }
            let components = NSDateComponents()
            components.month = month!
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }
    
    /**
     The `xsd:gDay` textual representation of the `GregorianDate`. The textual representation is of the form:
     `---[day][timezone]`, e.g. `---14+02:00`, or
     `---02Z`. If `GregorianDate.XSDDataType` does not equal `XSD.gDay`, this optional property
     will be `nil`.
     */
    public var gDay : String? {
        get {
            if day == nil {
                return nil
            }
            var dateTime = "---"
            if day < 10 {
                dateTime += "0\(day!)"
            } else {
                dateTime += "\(day!)"
            }
            let components = NSDateComponents()
            components.day = day!
            let date = GregorianDate.calendar.dateFromComponents(components)
            if timezone != nil {
                let sgmt = timezone!.secondsFromGMTForDate(date!)
                var mgmt = Int(sgmt / 60)
                var hgmt = Int(mgmt / 60)
                mgmt = Int(abs(mgmt) % 60)
                if hgmt == 0 && mgmt == 0 {
                    dateTime += "Z"
                } else {
                    if hgmt < 0 {
                        dateTime += "-"
                    } else {
                        dateTime += "+"
                    }
                    hgmt = abs(hgmt)
                    if hgmt < 10 {
                        dateTime += "0\(hgmt):"
                    } else {
                        dateTime += "\(hgmt):"
                    }
                    if mgmt < 10 {
                        dateTime += "0\(mgmt)"
                    } else {
                        dateTime += "\(mgmt)"
                    }
                }
            }
            return dateTime
        }
    }

    
    
    // MARK: Initialisers
    
    /**
     Creates a new `GregorianDate` with the date and time for the current moment.
     */
    public convenience init() {
        self.init(date: NSDate())
    }
    
    /**
     Creates a new `GregorianDate` with the date and time of the specified `NSDate` object.
     The time zone of the Gregorian Date will be Greenwich Mean Time (GMT).
     
     - parameter date: The `NSDate` object that represents the date and time.
     */
    public convenience init(date: NSDate) {
        let tz = NSTimeZone(forSecondsFromGMT: 0)
        self.init(date:date, timeZone : tz)
    }
    
    /**
     Creates a new `GregorianDate` with the date and/or time of the specified `NSDate` object.
     The time zone of the Gregorian Date will be Greenwich Mean Time (GMT). Only those date components
     relevant for the specified datatype will be used. For instance, when the datatype is
     `xsd:date`, only the year, month, and day will be copied into the gregorian date, the hour, minute,
     and second will be set to 0. If the datatype is `xsd:gDay` only the day component will be copied and
     a recurring Gregorian date will be returned that will recur each month on the same day as the day
     component in the date.
     
     - parameter date: The `NSDate` object that represents the date and time.
     - parameter datatype: The type of date to be represented.
     */
    public convenience init(date: NSDate, datatype : Datatype) {
        let tz = NSTimeZone(forSecondsFromGMT: 0)
        self.init(date:date, timeZone : tz, datatype : datatype)
    }
    
    /**
     Creates a new `GregorianDate` with the date and/or time of the specified `NSDate` object.
     Only those date components
     relevant for the specified datatype will be used. For instance, when the datatype is
     `xsd:date`, only the year, month, and day will be copied into the gregorian date, the hour, minute,
     and second will be set to 0. If the datatype is `xsd:gDay` only the day component will be copied and
     a recurring Gregorian date will be returned that will recur each month on the same day as the day
     component in the date.
     
     - parameter date: The `NSDate` object that represents the date and time.
     - parameter timeZone: The time zone of the date.
     - parameter datatype: The type of date to be represented.
     */
    public convenience init(date: NSDate, timeZone : NSTimeZone, datatype : Datatype) {
        self.init(date:date, timeZone : timeZone)
        if datatype == XSD.date || datatype == XSD.gYear || datatype == XSD.gYearMonth ||
            datatype == XSD.gMonthDay || datatype == XSD.gMonth || datatype == XSD.gDay {
            self.hour = 0
            self.minute = 0
            self.second = 0
        }
        if datatype == XSD.gYear || datatype == XSD.gYearMonth || datatype == XSD.gMonth  {
                self.day = 0
        }
        if datatype == XSD.gYear || datatype == XSD.gDay {
                self.month = 0
        }
        if datatype == XSD.gMonthDay || datatype == XSD.gMonth || datatype == XSD.gDay {
                self.year = 0
        }
    }
    
    /**
     Creates a new `GregorianDate` with the date and time of the specified `NSDate` object.
     
     - parameter date: The `NSDate` object that represents the date and time.
     - parameter timeZone: The time zone of the date.
     */
    public init(date: NSDate, timeZone : NSTimeZone?) {
        timezone = timeZone
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year, .Minute, .Second, .Nanosecond]
        if timezone != nil {
            GregorianDate.calendar.timeZone = timezone!
        } else {
            GregorianDate.calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        let components = GregorianDate.calendar.components(unitFlags, fromDate:date)
        year = components.year
        month = components.month
        day = components.day
        hour = components.hour
        minute = components.minute
        second = Double(components.second)
        let nanosec = components.nanosecond
        second! += Double(nanosec)*1e-9
    }
    
    /**
     Creates a new `GregorianDate` with the specified date and time components and for the specified time zone.
     All components can be optional, for instance to define a whole year, or to define a recurring time of day.
     
     - parameter year: The year of the date.
     - parameter month: The month component of the date.
     - parameter day: The day component of the date.
     - parameter hour: The hour component of the date.
     - parameter minute: The minute component of the date.
     - parameter second: The second component of the time.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public init(year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Double?, timezone: NSTimeZone?) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.timezone = timezone
    }
    
    /**
     Creates a new `GregorianDate` with the date and time parsed from the specified textual representation of
     a date and time as defined for the `xsd:dateTime` data type. The textual representation should be of the form
     `±[year]-[month]-[day]T[hour]:[minute]:[second][timezone]`, e.g. `2015-12-14T11:29:54.2323+02:00`, or
     `-1203-03-02T23:12:04Z`. If the string is not of this required format, the initialisation method will
     return `nil`.
     
     - parameter dateTime: The textual representation of a date in `xsd:dateTime` format.
     - returns: An optional instance of `GregorianDate` which represents the date and time, or `nil` if the
     string could not be parsed.
     */
    public init?(dateTime: String) {
        let parsed = parseDateString(dateTime, pattern: GregorianDate.dateTimePattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new `GregorianDate` with the date specified by its date components for year, month, and day (of the month)
     and for the specified time zone.
     The corresponding XSD datatype is `xsd:date`.
     
     - parameter year: The year of the date.
     - parameter month: The month component of the date.
     - parameter day: The day component of the date.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(year: Int, month: Int, day: Int, timezone: NSTimeZone?) {
        self.init(year:year, month:month, day: day, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    
    /**
     Creates a new `GregorianDate` with the date parsed from the specified textual representation of
     a date as defined for the `xsd:date` data type. The textual representation should be of the form
     `±[year]-[month]-[day][timezone]`, e.g. `2015-12-14+02:00`, or
     `-1203-03-02Z`. If the string is not of this required format, the initialisation method will
     return `nil`.
     
     - parameter date: The textual representation of a date in `xsd:date` format.
     - returns: An optional instance of `GregorianDate` which represents the date or `nil` if the
     string could not be parsed.
     */
    public init?(date: String) {
        let parsed = parseDateString(date, pattern: GregorianDate.datePattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new `GregorianDate` with the date specified by its date components for year and month,
     and for the specified time zone.
     The corresponding XSD datatype is `xsd:gYearMonth`.
     
     - parameter year: The year of the date.
     - parameter month: The month component of the date.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(year: Int, month: Int, timezone: NSTimeZone?) {
        self.init(year:year, month:month, day: nil, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    /**
     Creates a new `GregorianDate` with the year and month parsed from the specified textual representation of
     a date as defined for the `xsd:gYearMonth` data type. The textual representation should be of the form
     `±[year]-[month][timezone]`, e.g. `2015-12+02:00`, or
     `-1203-03Z`. If the string is not of this required format, the initialisation method will
     return `nil`.
     
     - parameter date: The textual representation of a month in `xsd:gYearMonth` format.
     - returns: An optional instance of `GregorianDate` which represents the date or `nil` if the
     string could not be parsed.
     */
    public init?(gYearMonth: String) {
        let parsed = parseDateString(gYearMonth, pattern: GregorianDate.gYearMonthPattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new `GregorianDate` with the date specified by its date components for year
     and for the specified time zone.
     The corresponding XSD datatype is `xsd:gYear`.
     
     - parameter year: The year of the date.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(year: Int, timezone: NSTimeZone?) {
        self.init(year:year, month:nil, day: nil, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    /**
     Creates a new `GregorianDate` with the year parsed from the specified textual representation of
     a date as defined for the `xsd:gYear` data type. The textual representation should be of the form
     `±[year][timezone]`, e.g. `2015+02:00`, or
     `-1203Z`. If the string is not of this required format, the initialisation method will
     return `nil`.
     
     - parameter date: The textual representation of a year in `xsd:gYear` format.
     - returns: An optional instance of `GregorianDate` which represents the date or `nil` if the
     string could not be parsed.
     */
    public init?(gYear: String) {
        let parsed = parseDateString(gYear, pattern: GregorianDate.gYearPattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new recurring `GregorianDate` with the specified time components and for the specified time zone.
     The corresponding XSD datatype is `xsd:time`.
     
     - parameter hour: The hour component of the date.
     - parameter minute: The minute component of the date.
     - parameter second: The second component of the time.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(hour: Int?, minute: Int?, second: Double?, timezone: NSTimeZone?) {
        self.init(year:nil, month:nil, day: nil, hour:hour, minute:minute, second:second, timezone:timezone)
    }
    
    /**
     Creates a new recurring `GregorianDate` with the time parsed from the specified textual representation of
     a time as defined for the `xsd:time` data type. The textual representation should be of the form
     `[hour]:[minute]:[second][timezone]`, e.g. `11:29:54.2323+02:00`, or
     `23:12:04Z`. If the string is not of this required format, the initialisation method will
     return `nil`.
     
     - parameter time: The textual representation of a recurring time in `xsd:time` format.
     - returns: An optional instance of `GregorianDate` which represents the time, or `nil` if the
     string could not be parsed.
     */
    public init?(time: String) {
        let parsed = parseTimeString(time, pattern: GregorianDate.timePattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new recurring `GregorianDate` with the specified month and day components 
     and for the specified time zone. It represents a date (month and day) that recurs every year.
     The corresponding XSD datatype is `xsd:gMonthDay`.
     
     - parameter month: The month component of the date.
     - parameter day: The day component of the date.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(month: Int?, day: Int?, timezone: NSTimeZone?) {
        self.init(year:nil, month:month, day: day, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    /**
     Creates a new recurring `GregorianDate` with the month and day parsed from the specified 
     textual representation of a recuring date as defined for the `xsd:gMonthDay` data type.
     It represents a date (month and day) that recurs every year.
     The textual representation should be of the form
     `--[month]-[day][timezone]`, e.g. `--11-03+02:00`, or `--03-23Z`. If the string is not 
     of this required format, the initialisation method will return `nil`.
     
     - parameter gMonthDay: The textual representation of a recurring date in `xsd:gMonthDay` format.
     - returns: An optional instance of `GregorianDate` which represents the date, or `nil` if the
     string could not be parsed.
     */
    public init?(gMonthDay: String) {
        let parsed = parsegMonthDayString(gMonthDay, pattern: GregorianDate.gMonthDayPattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new recurring `GregorianDate` with the specified month component
     and for the specified time zone. It represents a month that recurs every year.
     The corresponding XSD datatype is `xsd:gMonth`.
     
     - parameter month: The month component of the date.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(month: Int?, timezone: NSTimeZone?) {
        self.init(year:nil, month:month, day: nil, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    /**
     Creates a new recurring `GregorianDate` with the month parsed from the specified
     textual representation of a recuring date as defined for the `xsd:gMonth` data type.
     It represents a month that recurs every year.
     The textual representation should be of the form
     `--[month][timezone]`, e.g. `--11+02:00`, or `--03Z`. If the string is not
     of this required format, the initialisation method will return `nil`.
     
     - parameter gMonth: The textual representation of a recurring month in `xsd:gMonth` format.
     - returns: An optional instance of `GregorianDate` which represents the month, or `nil` if the
     string could not be parsed.
     */
    public init?(gMonth: String) {
        let parsed = parsegMonthString(gMonth, pattern: GregorianDate.gMonthPattern)
        if !parsed {
            return nil
        }
    }
    
    /**
     Creates a new recurring `GregorianDate` with the specified day component
     and for the specified time zone. It represents a day that recurs every month.
     The corresponding XSD datatype is `xsd:gDay`.
     
     - parameter day: The day component of the date.
     - parameter timezone: The time zone for the `GregorianDate`.
     */
    public convenience init(day: Int?, timezone: NSTimeZone?) {
        self.init(year:nil, month:nil, day: day, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    /**
     Creates a new recurring `GregorianDate` with the day parsed from the specified
     textual representation of recuring date as defined for the `xsd:gDay` data type.
     It represents a day that recurs every month.
     The textual representation should be of the form
     `---[day][timezone]`, e.g. `---03+02:00`, or `---23Z`. If the string is not
     of this required format, the initialisation method will return `nil`.
     
     - parameter gMonthDay: The textual representation of a recurring date in `xsd:gDay` format.
     - returns: An optional instance of `GregorianDate` which represents the date, or `nil` if the
     string could not be parsed.
     */
    public init?(gDay: String) {
        let parsed = parsegDayString(gDay, pattern: GregorianDate.gDayPattern)
        if !parsed {
            return nil
        }
    }
    
    
    // MARK: Calendar calculations
    
    /**
     Returns a new date which is equal to the recievers date added with the specified duration.
     
     - parameter duration: The duration to be added to the date.
     - returns: The new date with the duration added.
     */
    public func addDuration(duration : Duration) -> GregorianDate? {
        var sign = 1
        if !duration.isPositive {
            sign = -1
        }
        let components = NSDateComponents()
        components.year = sign*Int(duration.years)
        components.month = sign*Int(duration.months)
        components.day = sign*Int(duration.days)
        components.hour = sign*Int(duration.hours)
        components.minute = sign*Int(duration.minutes)
        components.second = sign*Int(duration.seconds)
        components.nanosecond = sign*Int((duration.seconds-Double(Int(duration.seconds)))*1e9)
        if timezone != nil {
            GregorianDate.calendar.timeZone = timezone!
        } else {
            GregorianDate.calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        let sdate = self.startDate
        if sdate == nil {
            return nil
        }
        let ndate = GregorianDate.calendar.dateByAddingComponents(components, toDate: sdate!, options: NSCalendarOptions(rawValue: 0))
        let ngd = GregorianDate(date: ndate!, timeZone: timezone)
        return ngd
    }
    
    /**
     Returns true when the gregorian date is at recurring or occuring at the specified date,
     i.e. when the start time is earlier, and the end time is later than the specified date.
     
     - parameter date: The date that is tested whether the gregorian date is reocurring or occuring at that moment.
     - returns: True when the gregorian date is recurring or occuring at the moment specified by the date.
     */
    public func isRecurringAt(date : NSDate) -> Bool {
        let sdate = previousStartTimeBefore(date)
        let dur = duration
        if sdate != nil && dur != nil {
            let calendar = NSCalendar.currentCalendar()
            if timezone != nil {
                calendar.timeZone = timezone!
            } else {
                calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            }
            let components = NSDateComponents()
            components.year = Int(dur!.years)
            components.month = Int(dur!.months)
            components.day = Int(dur!.days)
            components.hour = Int(dur!.hours)
            components.minute = Int(dur!.minutes)
            components.second = Int(dur!.seconds)
            components.nanosecond = Int((dur!.seconds-Double(Int(dur!.seconds)))*1e9)
            let edate = calendar.dateFromComponents(components)
            if edate != nil && sdate == date.earlierDate(sdate!) && edate == date.laterDate(edate!) {
                return true
            }
        }
        return false
    }
    
    /**
     Returns the non-recurring Gregorian date that is the next occurrence of this Gregorian date after the
     specified date. If this Gregorian date is not recurring, this instance of Gregorian date (`self`) will
     be returned. If this Gregorian date is recurring the datatype (`XSDDataType`) of the returned Gregorian date
     will depend on the datatype of the recieving instance:
     
     - For a recurring date `xsd:time`, a Gregorian date of type `xsd:dateTime` will be returned.
     - For a recurring date `xsd:gMonthDay`, a Gregorian date of type `xsd:date` will be returned.
     - For a recurring date `xsd:gMonth`, a Gregorian date of type `xsd:gYearMonth` will be returned.
     - For a recurring date `xsd:gDay`, a Gregorian date of type `xsd:date` will be returned.
     
     - parameter date: The date after which the next Gregorian Date should be found and returned.
     - returns: The non-recurring date of the next time the reciever occurs.
     */
    public func nextGregorianDateAfter(date: NSDate) -> GregorianDate? {
        let starttime = nextStartTimeAfter(date)
        if starttime != nil {
            return gregorianDateFrom(starttime!)
        }
        return nil
    }
    
    /**
     Returns the non-recurring Gregorian date that is the previous occurrence of this Gregorian date after the
     specified date. If the Gregorian date is occurring at the specified date, that occurrence
     will be returned.
     If this Gregorian date is not recurring, this instance of Gregorian date (`self`) will
     be returned. If this Gregorian date is recurring the datatype (`XSDDataType`) of the returned Gregorian date
     will depend on the datatype of the recieving instance:
     
     - For a recurring date `xsd:time`, a Gregorian date of type `xsd:dateTime` will be returned.
     - For a recurring date `xsd:gMonthDay`, a Gregorian date of type `xsd:date` will be returned.
     - For a recurring date `xsd:gMonth`, a Gregorian date of type `xsd:gYearMonth` will be returned.
     - For a recurring date `xsd:gDay`, a Gregorian date of type `xsd:date` will be returned.
     
     - parameter date: The date before which the previous Gregorian Date should be found and returned.
     - returns: The non-recurring date of the previous time the reciever occurs.
     */
    public func previousGregorianDateBefore(date: NSDate) -> GregorianDate? {
        let starttime = previousStartTimeBefore(date)
        if starttime != nil {
            return gregorianDateFrom(starttime!)
        }
        return nil
    }
    
    /**
     Returns the start time of the next occurrence of the gregorian date after the specified date.
     The start time is determined according to:
     
     - If the Gregorian date is not recurring, this will be the start time of the gregorian date if the start time
     is in the future of the specified date, or nil if it is in the past.
     - If the Gregorian date is a recurring date, the first start time that is later than the specified date will
     be returned.
     - If the recurring Gregorian date is occurring at the specified date, the start time of the next occurrence will
     be returned.
     
     - parameter date: The date after which the first start time is to be returned.
     - returns: The first start time of the gregorian date after the specified date.
     */
    public func nextStartTimeAfter(date : NSDate) -> NSDate? {
        if !isRecurring {
            let sd = startDate
            if sd != nil && sd == date.laterDate(sd!) {
                return sd
            }
            return nil
        }
        return nextStartTimeAfter(date, runningDate: date)
    }
    
    /**
     Returns the start time of the previous occurrence of the gregorian date before the specified date.
     The start time is determined according to:
     
     - If the Gregorian date is not recurring, this will be the start time of the gregorian date if the start time
     is in the past of the specified date, or nil if it is in the future.
     - If the Gregorian date is a recurring date, the last start time that is earlier than the specified date will
     be returned.
     - If the recurring Gregorian date is occurring at the specified date, the start time of the current occurrence will
     be returned.
     
     - parameter date: The date before which the last start time is to be returned.
     - returns: The last start time of the gregorian date before the specified date.
     */
    public func previousStartTimeBefore(date : NSDate) -> NSDate? {
        if !isRecurring {
            let sd = startDate
            if sd != nil && sd == date.earlierDate(sd!) {
                return sd
            }
            return nil
        }
        return previousStartTimeBefore(date, runningDate: date)
    }
    /**
     Returns the end time of the next occurrence of the gregorian date after the specified date.
     The end time is determined according to:
     
     - If the gregorian date is not recurring, this will be the end time of the gregorian date if the end time
     is in the future of the specified date, or nil if it is in the past.
     - If the gregorian date is a recurring date, the first end time that is later than the specified date will
     be returned.
     - If the recurring Gregorian date is occurring at the specified date, the end time of the next occurrence will
     be returned.
     
     - parameter date: The date after which the first end time is to be returned.
     - returns: The first end time of the gregorian date after the specified date.
     */
    public func nextEndTimeAfter(date : NSDate) -> NSDate? {
        var retDate = nextStartTimeAfter(date)
        let changedc = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        if timezone != nil {
            calendar.timeZone = timezone!
        } else {
            calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        if retDate != nil {
            if year == nil && month == nil && day == nil { // xsd:time
                changedc.second = 1
            } else if year == nil && month == nil { // xsd:gDay
                changedc.day = 1
            } else if year == nil && day == nil { // xsd:gMonth
                changedc.month = 1
            } else if year == nil { // xsd:gMonthDay
                changedc.day = 1
            }
            retDate = calendar.dateByAddingComponents(changedc, toDate: retDate!, options: NSCalendarOptions(rawValue: 0))
        }
        return retDate
    }
    
    /**
     Returns the end time of the previous occurrence of the gregorian date before the specified date.
     The end time is determined according to:
     
     - If the gregorian date is not recurring, this will be the end time of the gregorian date if the end time
     is in the past of the specified date, or nil if it is in the future.
     - If the gregorian date is a recurring date, the last end time that is earlier than the specified date will
     be returned.
     - If the recurring Gregorian date is occurring at the specified date, the end time of the current occurrence will
     be returned.
     
     - parameter date: The date before which the last end time is to be returned.
     - returns: The last end time of the gregorian date before the specified date.
     */
    public func previousEndTimeBefore(date : NSDate) -> NSDate? {
        var retDate = previousStartTimeBefore(date)
        let changedc = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        if timezone != nil {
            calendar.timeZone = timezone!
        } else {
            calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        if retDate != nil {
            if year == nil && month == nil && day == nil { // xsd:time
                changedc.second = 1
            } else if year == nil && month == nil { // xsd:gDay
                changedc.day = 1
            } else if year == nil && day == nil { // xsd:gMonth
                changedc.month = 1
            } else if year == nil { // xsd:gMonthDay
                changedc.day = 1
            }
            retDate = calendar.dateByAddingComponents(changedc, toDate: retDate!, options: NSCalendarOptions(rawValue: 0))
        }
        return retDate
    }
    
    
    // MARK: Date comparissons
    
    /**
     Returnst the earlier date of the reciever or the compared gregorian date. A date is earlier if one of the following
     is true. The first condition has precedence over the following conditions.
    
     - The start date is earlier
     - The start dates are equal but the end date is earlier.
    
     This function will return `nil` if:
     
     - The start dates of one the two Gregorian dates could not be determined, i.e. `startDate` returns `nil`.
     - The start dates are equal and the end date of one of the two Gregorian dates could not be determined, i.e. `endDate` returns `nil`.
     - Both start dates and end dates are equal, i.e. the Gregorian dates are equal.
    
     - parameter comparedDate: The date to be compared with the reciever.
     - returns: The earlier date or `nil` when the start and end dates are equal or the dates could not be compared.
     */
    public func earlierGregorianDate(comparedDate : GregorianDate) -> GregorianDate? {
        let startDate1 = self.startDate
        let startDate2 = comparedDate.startDate
        if startDate1 == nil || startDate2 == nil {
            return nil    // one of the two start dates is nil ==> cannot be compared
        }
        if startDate1 == startDate1!.earlierDate(startDate2!) {
            if startDate1!.isEqualToDate(startDate2!) {
                let endDate1 = self.endDate
                let endDate2 = comparedDate.endDate
                if endDate1 == nil || endDate2 == nil {
                    return nil // One of the two end dates is nil while the start dates are equal ==> cannot be compared
                }
                if endDate1 == endDate1!.earlierDate(endDate2!) {
                    if endDate1!.isEqualToDate(endDate2!) {
                        return nil // Both start dates and end dates are equal, the gregorian dates are equal ==> return nil
                    } else {
                        return self // Start dates are equal but the reciever has an earlier end date
                    }
                } else {
                    return comparedDate // The start dates are equal but the comparedDate has en earlier end date
                }
            } else {
                return self // The start date of the reciever is earlier.
            }
        } else {
            return comparedDate // The start date of the comparedDate is earlier.
        }
    }
    
    /**
     Returnst the later date of the reciever or the compared gregorian date. A date is later if one of the following
     is true. The first condition has precedence over the following conditions.
     
     - The start date is later
     - The start dates are equal but the end date is later.
     
     This function will return `nil` if:
     
     - The start dates of one the two Gregorian dates could not be determined, i.e. `startDate` returns `nil`.
     - The start dates are equal and the end date of one of the two Gregorian dates could not be determined, i.e. `endDate` returns `nil`.
     - Both start dates and end dates are equal, i.e. the Gregorian dates are equal.
     
     - parameter comparedDate: The date to be compared with the reciever.
     - returns: The later date or `nil` when the start and end dates are equal or the dates could not be compared.
     */
    public func laterGregorianDate(comparedDate : GregorianDate) -> GregorianDate? {
        let startDate1 = self.startDate
        let startDate2 = comparedDate.startDate
        if startDate1 == nil || startDate2 == nil {
            return nil    // one of the two start dates is nil ==> cannot be compared
        }
        if startDate1 == startDate1!.laterDate(startDate2!) {
            if startDate1!.isEqualToDate(startDate2!) {
                let endDate1 = self.endDate
                let endDate2 = comparedDate.endDate
                if endDate1 == nil || endDate2 == nil {
                    return nil // One of the two end dates is nil while the start dates are equal ==> cannot be compared
                }
                if endDate1 == endDate1!.laterDate(endDate2!) {
                    if endDate1!.isEqualToDate(endDate2!) {
                        return nil // Both start dates and end dates are equal, the gregorian dates are equal ==> return nil
                    } else {
                        return self // Start dates are equal but the reciever has a later end date
                    }
                } else {
                    return comparedDate // The start dates are equal but the comparedDate has a later end date
                }
            } else {
                return self // The start date of the reciever is later.
            }
        } else {
            return comparedDate // The start date of the comparedDate is later.
        }
    }
    
    /**
     Returns true when the reciever and compared dates are equals, i.e. have the same start and end dates.
     If one of the start dates cannot be determined or if the start dates are equal and one of the end dates cannot 
     be determined `nil` is returned.
     
     - parameter comparedDate: The date to be compared with the reciever.
     - returns: True when the Gregorian dates are equal, or `nil` if one of the start or end dates could not be determined.
     */
    public func isEqualToGregorianDate(comparedDate : GregorianDate) -> Bool? {
        let startDate1 = self.startDate
        let startDate2 = comparedDate.startDate
        if startDate1 == nil || startDate2 == nil {
            return nil    // one of the two start dates is nil ==> cannot be compared
        }
        if !startDate1!.isEqualToDate(startDate2!) {
            return false
        }
        let endDate1 = self.endDate
        let endDate2 = comparedDate.endDate
        if endDate1 == nil || endDate2 == nil {
            return nil // One of the two end dates is nil while the start dates are equal ==> cannot be compared
        }
        return endDate1!.isEqualToDate(endDate2!)
    }
    
    
    
    
    // MARK: Private methods
    
    
    
    /**
    Returns the non-recurring Gregorian date that starts at the
    specified date. If this Gregorian date is not recurring, this instance of Gregorian date (`self`) will
    be returned. If this Gregorian date is recurring the datatype (`XSDDataType`) of the returned Gregorian date
    will depend on the datatype of the recieving instance:
    
    - For a recurring date `xsd:time`, a Gregorian date of type `xsd:dateTime` will be returned.
    - For a recurring date `xsd:gMonthDay`, a Gregorian date of type `xsd:date` will be returned.
    - For a recurring date `xsd:gMonth`, a Gregorian date of type `xsd:gYearMonth` will be returned.
    - For a recurring date `xsd:gDay`, a Gregorian date of type `xsd:date` will be returned.
    
    - parameter starttime: The date at which the Gregorian date should start.
    - returns: The non-recurring date of the next time the reciever occurs.
    */
    public func gregorianDateFrom(starttime: NSDate) -> GregorianDate? {
        let datatype = self.XSDDataType
        if datatype != nil {
            if datatype! == XSD.dateTime || datatype! == XSD.date || datatype! == XSD.gYearMonth || datatype! == XSD.gYear {
                return self
            } else if datatype! == XSD.time {
                if timezone == nil {
                    return GregorianDate(date: starttime, datatype: XSD.dateTime)
                } else {
                    return GregorianDate(date: starttime, timeZone: self.timezone!, datatype: XSD.dateTime)
                }
            } else if datatype! == XSD.gMonthDay {
                if timezone == nil {
                    return GregorianDate(date: starttime, datatype: XSD.date)
                } else {
                    return GregorianDate(date: starttime, timeZone: self.timezone!, datatype: XSD.date)
                }
            } else if datatype! == XSD.gMonth {
                if timezone == nil {
                    return GregorianDate(date: starttime, datatype: XSD.gYearMonth)
                } else {
                    return GregorianDate(date: starttime, timeZone: self.timezone!, datatype: XSD.gYearMonth)
                }
            } else if datatype! == XSD.gDay {
                if timezone == nil {
                    return GregorianDate(date: starttime, datatype: XSD.date)
                } else {
                    return GregorianDate(date: starttime, timeZone: self.timezone!, datatype: XSD.date)
                }
            }
        }
        return nil
    }
    
    /**
     Returns the start time of the next occurrence of the gregorian date after the specified date.
     The running date is used to start creating the initial start date to be tested.
     The start time is determined according to:
     
     - If the Gregorian date is not recurring, this will be the start time of the gregorian date if the start time
     is in the future of the specified date, or nil if it is in the past.
     - If the Gregorian date is a recurring date, the first start time that is later than the specified date will
     be returned.
     - If the recurring Gregorian date is occurring at the specified date, the start time of the next occurrence will
     be returned.
     
     - parameter date: The date after which the first start time is to be returned.
     - parameter runningDate: The date used to determine the initial date.
     - returns: The first start time of the gregorian date after the specified date.
     */
    public func nextStartTimeAfter(date : NSDate, runningDate: NSDate) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        if timezone != nil {
            calendar.timeZone = timezone!
        } else {
            calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        let dc = NSDateComponents()
        let changedc = NSDateComponents()
        let unitFlags: NSCalendarUnit = [.Day, .Month, .Year]
        let curcomps = calendar.components(unitFlags, fromDate:runningDate)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.year = curcomps.year
        dc.month = curcomps.month
        dc.day = curcomps.day
        if year == nil && month == nil && day == nil { // xsd:time
            dc.hour = hour!
            dc.minute = minute!
            dc.second = Int(second!)
            let ns = Int((second!-Double(Int(second!)))*1e9)
            dc.nanosecond = ns
        } else {
            if month != nil {
                dc.month = month!
            }
            dc.day = 1 // for gDay and gMonthDay this has to be changed after checking range of days in the month
        }
        var testDate = calendar.dateFromComponents(dc)
        var retDate = testDate
        if year == nil && month == nil && day != nil && testDate != nil { // xsd:gDay
            changedc.month = 1
            var range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: testDate!)
            while testDate != nil && range.length < day! { // day not in range of month (e.g. 31 february)
                testDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
                range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: testDate!)
            }
            changedc.month = 0
            changedc.day = day! - 1
            retDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
        }else if year == nil && month != nil && day != nil && testDate != nil { // xsd:gMonthDay
            let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: testDate!)
            if range.length < day! { // day not in range of month (e.g. 31 february)
                return nil
            }
            changedc.month = 0
            changedc.day = day! - 1
            retDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
        }
        if testDate != nil && retDate != retDate!.laterDate(date) {
            changedc.month = 0
            changedc.day = 0
            if year == nil && month == nil && day == nil { // xsd:time
                changedc.day = 1
            } else if year == nil && month == nil { // xsd:gDay
                changedc.month = 1
            } else if year == nil { // xsd:gMonth or xsd:gMonthDay
                changedc.year = 1
            }
            retDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
            return nextStartTimeAfter(date, runningDate: retDate!)
        }
        return retDate
    }
    
    /**
     Returns the start time of the previous occurrence of the gregorian date before the specified date.
     The running date is used to start creating the initial start date to be tested.
     The start time is determined according to:
     
     - If the Gregorian date is not recurring, this will be the start time of the gregorian date if the start time
     is in the past of the specified date, or nil if it is in the future.
     - If the Gregorian date is a recurring date, the last start time that is earlier than the specified date will
     be returned.
     - If the recurring Gregorian date is occurring at the specified date, the start time of the current occurrence will
     be returned.
     
     - parameter date: The date before which the last start time is to be returned.
     - parameter runningDate: The date used to determine the initial date.
     - returns: The last start time of the gregorian date before the specified date.
     */
    private func previousStartTimeBefore(date : NSDate, runningDate : NSDate) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        if timezone != nil {
            calendar.timeZone = timezone!
        } else {
            calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        let dc = NSDateComponents()
        let changedc = NSDateComponents()
        let unitFlags: NSCalendarUnit = [.Day, .Month, .Year]
        let curcomps = calendar.components(unitFlags, fromDate:runningDate) // use running date
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.year = curcomps.year
        dc.month = curcomps.month
        dc.day = curcomps.day
        if year == nil && month == nil && day == nil { // xsd:time
            dc.hour = hour!
            dc.minute = minute!
            dc.second = Int(second!)
            let ns = Int((second!-Double(Int(second!)))*1e9)
            dc.nanosecond = ns
        } else {
            if month != nil {
                dc.month = month!
            }
            dc.day = 1 // for gDay and gMonthDay this has to be changed after checking range of days in the month
        }
        var testDate = calendar.dateFromComponents(dc)
        var retDate = testDate
        if year == nil && month == nil && day != nil && testDate != nil { // xsd:gDay
            changedc.month = -1
            var range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: testDate!)
            while testDate != nil && range.length < day! { // day not in range of month (e.g. 31 february)
                testDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
                range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: testDate!)
            }
            changedc.month = 0
            changedc.day = day! - 1
            retDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
        }else if year == nil && month != nil && day != nil && testDate != nil { // xsd:gMonthDay
            let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: testDate!)
            if range.length < day! { // day not in range of month (e.g. 31 february)
                return nil
            }
            changedc.month = 0
            changedc.day = day! - 1
            retDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
        }
        if testDate != nil && retDate != retDate!.earlierDate(date) {
            changedc.month = 0
            changedc.day = 0
            if year == nil && month == nil && day == nil { // xsd:time
                changedc.day = -1
            } else if year == nil && month == nil { // xsd:gDay
                changedc.day = -1
            } else if year == nil { // xsd:gMonth or xsd:gMonthDay
                changedc.year = -1
            }
            retDate = calendar.dateByAddingComponents(changedc, toDate: testDate!, options: NSCalendarOptions(rawValue: 0))
            return previousStartTimeBefore(date, runningDate: retDate!)
        }
        return retDate
    }

    
    private func parseDateString(stringValue: String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return false
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                if match.rangeAtIndex(match.numberOfRanges-3).location != NSNotFound {
                    var tzhrs = 0;
                    var tzmins = 0;
                    var sign = 1
                    if match.rangeAtIndex(match.numberOfRanges-2).location != NSNotFound {
                        let tzhrsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-2)) as String
                        if nsstring.characterAtIndex(match.rangeAtIndex(match.numberOfRanges-2).location) == 45 {
                            sign = -1
                        }
                        tzhrs = Int(tzhrsStr)!
                    }
                    if match.rangeAtIndex(match.numberOfRanges-1).location != NSNotFound {
                        let tzminsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-1)) as String
                        tzmins = Int(tzminsStr)!
                    }
                    if tzhrs < 0 || sign < 0 {
                        tzmins = -tzmins
                    }
                    timezone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                if match.rangeAtIndex(1).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    year = Int(str)!
                }
                if match.numberOfRanges >= 6 && match.rangeAtIndex(2).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                    month = Int(str)!
                }
                if match.numberOfRanges >= 7 && match.rangeAtIndex(3).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(3)) as String
                    day = Int(str)!
                }
                if match.numberOfRanges >= 8 && match.rangeAtIndex(4).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(4)) as String
                    hour = Int(str)!
                }
                if match.numberOfRanges >= 9 && match.rangeAtIndex(5).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(5)) as String
                    minute = Int(str)!
                }
                if match.numberOfRanges >= 10 && match.rangeAtIndex(6).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(6)) as String
                    second = Double(str)!
                }
                return true
            }
        } catch {
            
        }
        return false
    }
    
    private func parseTimeString(stringValue: String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return false
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                if match.rangeAtIndex(match.numberOfRanges-3).location != NSNotFound {
                    var tzhrs = 0;
                    var tzmins = 0;
                    var sign = 1
                    if match.rangeAtIndex(match.numberOfRanges-2).location != NSNotFound {
                        let tzhrsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-2)) as String
                        if nsstring.characterAtIndex(match.rangeAtIndex(match.numberOfRanges-2).location) == 45 {
                            sign = -1
                        }
                        tzhrs = Int(tzhrsStr)!
                    }
                    if match.rangeAtIndex(match.numberOfRanges-1).location != NSNotFound {
                        let tzminsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-1)) as String
                        tzmins = Int(tzminsStr)!
                    }
                    if tzhrs < 0 || sign < 0 {
                        tzmins = -tzmins
                    }
                    timezone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                if match.rangeAtIndex(1).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    hour = Int(str)!
                }
                if match.numberOfRanges >= 6 && match.rangeAtIndex(2).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                    minute = Int(str)!
                }
                if match.numberOfRanges >= 7 && match.rangeAtIndex(3).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(3)) as String
                    second = Double(str)!
                }
                return true
            }
        } catch {
            
        }
        return false
    }
    
    private func parsegMonthDayString(stringValue: String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return false
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                if match.rangeAtIndex(match.numberOfRanges-3).location != NSNotFound {
                    var tzhrs = 0;
                    var tzmins = 0;
                    var sign = 1
                    if match.rangeAtIndex(match.numberOfRanges-2).location != NSNotFound {
                        let tzhrsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-2)) as String
                        if nsstring.characterAtIndex(match.rangeAtIndex(match.numberOfRanges-2).location) == 45 {
                            sign = -1
                        }
                        tzhrs = Int(tzhrsStr)!
                    }
                    if match.rangeAtIndex(match.numberOfRanges-1).location != NSNotFound {
                        let tzminsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-1)) as String
                        tzmins = Int(tzminsStr)!
                    }
                    if tzhrs < 0 || sign < 0 {
                        tzmins = -tzmins
                    }
                    timezone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                if match.rangeAtIndex(1).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    month = Int(str)!
                }
                if match.numberOfRanges >= 5 && match.rangeAtIndex(2).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                    day = Int(str)!
                }
                return true
            }
        } catch {
            
        }
        return false
    }
    
    private func parsegMonthString(stringValue: String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return false
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                if match.rangeAtIndex(match.numberOfRanges-3).location != NSNotFound {
                    var tzhrs = 0;
                    var tzmins = 0;
                    var sign = 1
                    if match.rangeAtIndex(match.numberOfRanges-2).location != NSNotFound {
                        let tzhrsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-2)) as String
                        if nsstring.characterAtIndex(match.rangeAtIndex(match.numberOfRanges-2).location) == 45 {
                            sign = -1
                        }
                        tzhrs = Int(tzhrsStr)!
                    }
                    if match.rangeAtIndex(match.numberOfRanges-1).location != NSNotFound {
                        let tzminsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-1)) as String
                        tzmins = Int(tzminsStr)!
                    }
                    if tzhrs < 0 || sign < 0 {
                        tzmins = -tzmins
                    }
                    timezone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                if match.rangeAtIndex(1).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    month = Int(str)!
                }
                return true
            }
        } catch {
            
        }
        return false
    }
    
    private func parsegDayString(stringValue: String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return false
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                if match.rangeAtIndex(match.numberOfRanges-3).location != NSNotFound {
                    var tzhrs = 0;
                    var tzmins = 0;
                    var sign = 1
                    if match.rangeAtIndex(match.numberOfRanges-2).location != NSNotFound {
                        let tzhrsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-2)) as String
                        if nsstring.characterAtIndex(match.rangeAtIndex(match.numberOfRanges-2).location) == 45 {
                            sign = -1
                        }
                        tzhrs = Int(tzhrsStr)!
                    }
                    if match.rangeAtIndex(match.numberOfRanges-1).location != NSNotFound {
                        let tzminsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-1)) as String
                        tzmins = Int(tzminsStr)!
                    }
                    if tzhrs < 0 || sign < 0 {
                        tzmins = -tzmins
                    }
                    timezone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                if match.rangeAtIndex(1).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    day = Int(str)!
                }
                return true
            }
        } catch {
            
        }
        return false
   
    }
}

// MARK: Operators for GregorianDates

/**
 This operator returns `true` when the GregorianDate values are equal to each other.
 
 - parameter left: The left side GregorianDate in the comparison.
 - parameter right: The right side GregorianDate in the comparison.
 - returns: True when the GregorianDates are equal, false otherwise.
 */
public func == (left: GregorianDate, right: GregorianDate) -> Bool {
    return left.startDate == right.startDate && left.endDate == right.endDate
}

/**
 This operator returns `true` when the GregorianDate values are not equal to each other.
 
 - parameter left: The left side GregorianDate in the comparison.
 - parameter right: The right side GregorianDate in the comparison.
 - returns: True when the GregorianDates are not equal, false otherwise.
 */
public func != (left: GregorianDate, right: GregorianDate) -> Bool {
    return left.startDate != right.startDate || left.endDate != right.endDate
}

/**
 Returns true when the left side Gregorian date is earlier than the right side date.
 The Gregorian Date is earlier when either:
 
 - The start date is earlier
 - The start dates are equal but the end date is earlier.
 
 If the dates cannot be compared, this operator will return `false`.
 
 - parameter left: The left side GregorianDate in the comparison.
 - parameter right: The right side GregorianDate in the comparison.
 - returns: True when the left side date is earlier than the right side date.
 */
public func < (left: GregorianDate, right: GregorianDate) -> Bool {
    let earlier = left.earlierGregorianDate(right)
    if earlier == nil {
        return false
    }
    if earlier! == left {
        return true
    }
    return false
}

/**
 Returns true when the left side Gregorian date is earlier or equal to the right side date.
 The Gregorian Date is earlier or equal when either:
 
 - The start date is earlier
 - The start dates are equal but the end date is earlier.
 - The start and end dates are equal.
 
 If the dates cannot be compared, this operator will return `false`.
 
 - parameter left: The left side GregorianDate in the comparison.
 - parameter right: The right side GregorianDate in the comparison.
 - returns: True when the left side date is earlier or equal to the right side date.
 */
public func <= (left: GregorianDate, right: GregorianDate) -> Bool {
    if left == right {
        return true
    }
    let earlier = left.earlierGregorianDate(right)
    if earlier == nil {
        return false
    }
    if earlier! == left {
        return true
    }
    return false
}

/**
 Returns true when the left side Gregorian date is later than the right side date.
 The Gregorian Date is later when either:
 
 - The start date is later
 - The start dates are equal but the end date is later.
 
 If the dates cannot be compared, this operator will return `false`.
 
 - parameter left: The left side GregorianDate in the comparison.
 - parameter right: The right side GregorianDate in the comparison.
 - returns: True when the left side date is later than the right side date.
 */
public func > (left: GregorianDate, right: GregorianDate) -> Bool {
    let later = left.laterGregorianDate(right)
    if later == nil {
        return false
    }
    if later! == left {
        return true
    }
    return false
}

/**
 Returns true when the left side Gregorian date is later or equal to the right side date.
 The Gregorian Date is later or equal when either:
 
 - The start date is later
 - The start dates are equal but the end date is later.
 - The start and end dates are equal.
 
 If the dates cannot be compared, this operator will return `false`.
 
 - parameter left: The left side GregorianDate in the comparison.
 - parameter right: The right side GregorianDate in the comparison.
 - returns: True when the left side date is later or equal to the right side date.
 */
public func >= (left: GregorianDate, right: GregorianDate) -> Bool {
    if left == right {
        return true
    }
    let later = left.laterGregorianDate(right)
    if later == nil {
        return false
    }
    if later! == left {
        return true
    }
    return false
}