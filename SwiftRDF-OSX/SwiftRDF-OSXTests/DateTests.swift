//
//  NSDateTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 08/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class DateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateTime() {
        var string = "2012-03-12T12:23:54Z"
        var gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        var gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "2012-03-12T12:23:54+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "2012-03-12T12:23:54-08:30"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "2012-03-12T12:23:54-10:30"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate!.dateTime)
        string = "-1203-03-12T12:23:54+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate!.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "-1203-03-12T12:23:54.983244+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate!.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "-1203-03-12T12:23:54.983244"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate!.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.dateTime)
    }
    
    func testDate() {
        var string = "2012-03-12Z"
        var gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        var gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "2012-03-12+02:00"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "2012-03-12-08:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "2012-03-12-10:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "-1203-03-12+02:00"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate!.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "-1203-03-12"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate!.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.date)
    }
    
    func testgYearMonth() {
        var string = "2012-03Z"
        var gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        var gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "2012-03+02:00"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "2012-03-08:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "2012-03-10:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "-1203-03+02:00"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
    }
    
    func testgYear() {
        var string = "2012Z"
        var gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        var gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "2012+02:00"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "2012-08:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "2012-10:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "-1203+02:00"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
    }
    
    func testDateTimeDateValue() {
        var string = "2015-12-13T19:39:32.233+02:00"
        var gdate = GregorianDate(dateTime: string)
        var sdate = gdate!.startDate
        XCTAssertTrue(1450028372.233 == sdate!.timeIntervalSince1970)
        var edate = gdate!.endDate
        XCTAssertTrue(1450028373.233 == edate!.timeIntervalSince1970)
        string = "2015-12-13+02:00"
        gdate = GregorianDate(date: string)
        sdate = gdate!.startDate
        XCTAssertTrue(1449957600.0 == sdate!.timeIntervalSince1970)
        edate = gdate!.endDate
        XCTAssertTrue(1449957600.0+24*3600 == edate!.timeIntervalSince1970)
    }
    
    func testTime() {
        var string = "12:23:54Z"
        var gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54+02:00"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54-08:30"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54-10:30"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate!.time)
        string = "12:23:54+02:00"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate!.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate!.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54.983244"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate!.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.time)
    }
    
    func testgMonthDay() {
        var string = "--12-15Z"
        var gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "--05-22+00:30"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "--01-12-04:00"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "--01-12"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "-02-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "--00-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "--13-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "--2-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
    }
    
    func testgMonth() {
        var string = "--12Z"
        var gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--05+00:30"
        gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--01-04:00"
        gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--01"
        gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--05-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "-02Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "---02Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "--00-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "--13-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "--2-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
    }
    
    func testgDay() {
        var string = "---12Z"
        var gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "---05+00:30"
        gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "---01-04:00"
        gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "---01"
        gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "--02Z"
        gdate = GregorianDate(gDay: string)
        XCTAssertNil(gdate)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(gDay: string)
        XCTAssertNil(gdate)
    }
    
    func testStartAndEndDate() {
        var string = "2012-03-02T13:45:23-01:30"
        var gdate = GregorianDate(dateTime: string)
        print("start date: \(gdate?.startDate)")
        print("end date: \(gdate?.endDate)")
        XCTAssertEqual("2012-03-02 15:15:23 +0000", "\(gdate!.startDate!)")
        XCTAssertEqual("2012-03-02 15:15:24 +0000", "\(gdate!.endDate!)")
        
        string = "2012-03-02-01:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual("2012-03-02 01:30:00 +0000", "\(gdate!.startDate!)")
        XCTAssertEqual("2012-03-03 01:30:00 +0000", "\(gdate!.endDate!)")
        
        string = "2012-03-01:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual("2012-03-01 01:30:00 +0000", "\(gdate!.startDate!)")
        XCTAssertEqual("2012-04-01 01:30:00 +0000", "\(gdate!.endDate!)")
        
        string = "2012-01:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual("2012-01-01 01:30:00 +0000", "\(gdate!.startDate!)")
        XCTAssertEqual("2013-01-01 01:30:00 +0000", "\(gdate!.endDate!)")
    }
    
    func testStartAndEndTimeRecurring() {
        var string = "13:45:23-01:30"
        var gdate = GregorianDate(time: string)
        let date = NSDate(timeIntervalSince1970: 1451038514.37942)
        var sdate = gdate!.nextStartTimeAfter(date)
        var edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2015-12-25 15:15:23 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-25 15:15:24 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-24 15:15:23 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-24 15:15:24 +0000", "\(edate!)")
        
        string = "00:30:56+02:30"
        gdate = GregorianDate(time: string)
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2015-12-25 22:00:56 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-25 22:00:57 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-24 22:00:56 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-24 22:00:57 +0000", "\(edate!)")
    }
    
    func testStartAndEndgDayRecurring() {
        var string = "---05-00:30"
        var gdate = GregorianDate(gDay: string)
        var date = NSDate(timeIntervalSince1970: 1451038514.37942)
        var sdate = gdate!.nextStartTimeAfter(date)
        var edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-01-05 00:30:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-06 00:30:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-05 00:30:00 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-06 00:30:00 +0000", "\(edate!)")
        
        string = "---30Z"
        gdate = GregorianDate(gDay: string)
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2015-12-30 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-31 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-11-30 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-01 00:00:00 +0000", "\(edate!)")
        
        string = "---30Z"
        gdate = GregorianDate(gDay: string)
        date = NSDate(timeIntervalSince1970: 1451038514.37942+4320000)
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-03-30 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-03-31 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-30 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-31 00:00:00 +0000", "\(edate!)")
        
        string = "---01Z"
        gdate = GregorianDate(gDay: string)
        date = NSDate(timeIntervalSince1970: 1451038514.37942)
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-02 00:00:00 +0000", "\(edate!)")
        
        string = "---01Z"
        gdate = GregorianDate(gDay: string)
        date = NSDate(timeIntervalSince1970: 1451038514.37942+4320000)
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-03-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-03-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-02 00:00:00 +0000", "\(edate!)")
    }
    
    func testStartAndEndgDayRecurring2() {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        var comps = NSDateComponents()
        comps.year = 2016
        comps.month = 1
        comps.day = 1
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        var string = "---01Z"
        var gdate = GregorianDate(gDay: string)
        var date = calendar.dateFromComponents(comps)!
        var sdate = gdate!.nextStartTimeAfter(date)
        var edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-02 00:00:00 +0000", "\(edate!)")
        
        string = "---31Z"
        gdate = GregorianDate(gDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-01-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(edate!)")
        
        comps = NSDateComponents()
        comps.year = 2016
        comps.month = 1
        comps.day = 31
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        string = "---01Z"
        gdate = GregorianDate(gDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-02 00:00:00 +0000", "\(edate!)")
        
        string = "---31Z"
        gdate = GregorianDate(gDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-03-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-04-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(edate!)")
        
        string = "---30Z"
        gdate = GregorianDate(gDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-03-30 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-03-31 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-30 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-31 00:00:00 +0000", "\(edate!)")
        
        comps = NSDateComponents()
        comps.year = 2016
        comps.month = 2
        comps.day = 15
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        string = "---01Z"
        gdate = GregorianDate(gDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-03-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-03-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-02 00:00:00 +0000", "\(edate!)")
        
        string = "---31Z"
        gdate = GregorianDate(gDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-03-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-04-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(edate!)")
    }
    
    func testStartAndEndgMonthRecurring() {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        var comps = NSDateComponents()
        comps.year = 2016
        comps.month = 1
        comps.day = 1
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        var string = "--01Z"
        var gdate = GregorianDate(gMonth: string)
        var date = calendar.dateFromComponents(comps)!
        var sdate = gdate!.nextStartTimeAfter(date)
        var edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-02-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(edate!)")
        
        string = "--12Z"
        gdate = GregorianDate(gMonth: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-12-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(edate!)")
        
        comps = NSDateComponents()
        comps.year = 2016
        comps.month = 12
        comps.day = 31
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        string = "--01Z"
        gdate = GregorianDate(gMonth: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-02-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-02-01 00:00:00 +0000", "\(edate!)")
        
        string = "--12Z"
        gdate = GregorianDate(gMonth: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2017-12-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2018-01-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-12-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(edate!)")
    }
    
    func testStartAndEndgMonthDayRecurring() {
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        var comps = NSDateComponents()
        comps.year = 2016
        comps.month = 1
        comps.day = 1
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        var string = "--01-01Z"
        var gdate = GregorianDate(gMonthDay: string)
        var date = calendar.dateFromComponents(comps)!
        var sdate = gdate!.nextStartTimeAfter(date)
        var edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-01-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-02 00:00:00 +0000", "\(edate!)")
        
        string = "--12-05Z"
        gdate = GregorianDate(gMonthDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2016-12-05 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-12-06 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2015-12-05 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2015-12-06 00:00:00 +0000", "\(edate!)")
        
        comps = NSDateComponents()
        comps.year = 2016
        comps.month = 12
        comps.day = 31
        comps.hour = 0
        comps.minute = 0
        comps.second = 1
        string = "--01-01Z"
        gdate = GregorianDate(gMonthDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-01-02 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-01-01 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2016-01-02 00:00:00 +0000", "\(edate!)")
        
        string = "--12-31Z"
        gdate = GregorianDate(gMonthDay: string)
        date = calendar.dateFromComponents(comps)!
        sdate = gdate!.nextStartTimeAfter(date)
        edate = gdate!.nextEndTimeAfter(date)
        XCTAssertEqual("2017-12-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2018-01-01 00:00:00 +0000", "\(edate!)")
        sdate = gdate!.previousStartTimeBefore(date)
        edate = gdate!.previousEndTimeBefore(date)
        XCTAssertEqual("2016-12-31 00:00:00 +0000", "\(sdate!)")
        XCTAssertEqual("2017-01-01 00:00:00 +0000", "\(edate!)")
    }
    
    func testComparisons() {
        let date1 = GregorianDate(dateTime: "2015-12-29T13:40:20+01:00")!
        var date2 = GregorianDate(dateTime: "2015-12-29T13:40:22+01:00")!
        XCTAssertTrue(date1 < date2)
        XCTAssertTrue(date1 <= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 > date2)
        XCTAssertFalse(date1 >= date2)
        XCTAssertFalse(date1 == date2)
        
        date2 = GregorianDate(dateTime: "2015-12-29T13:40:20+01:00")!
        XCTAssertFalse(date1 < date2)
        XCTAssertTrue(date1 <= date2)
        XCTAssertFalse(date1 != date2)
        XCTAssertFalse(date1 > date2)
        XCTAssertTrue(date1 >= date2)
        XCTAssertTrue(date1 == date2)
        
        date2 = GregorianDate(date: "2015-12-29+01:00")!
        XCTAssertFalse(date1 < date2)
        XCTAssertFalse(date1 <= date2)
        XCTAssertTrue(date1 > date2)
        XCTAssertTrue(date1 >= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 == date2)
        
        date2 = GregorianDate(gYearMonth: "2015-12+01:00")!
        XCTAssertFalse(date1 < date2)
        XCTAssertFalse(date1 <= date2)
        XCTAssertTrue(date1 > date2)
        XCTAssertTrue(date1 >= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 == date2)
        
        date2 = GregorianDate(gYear: "2015+01:00")!
        XCTAssertFalse(date1 < date2)
        XCTAssertFalse(date1 <= date2)
        XCTAssertTrue(date1 > date2)
        XCTAssertTrue(date1 >= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 == date2)
        
        date2 = GregorianDate(date: "2015-12-30+01:00")!
        XCTAssertTrue(date1 < date2)
        XCTAssertTrue(date1 <= date2)
        XCTAssertFalse(date1 > date2)
        XCTAssertFalse(date1 >= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 == date2)
        
        date2 = GregorianDate(gYearMonth: "2016-05+01:00")!
        XCTAssertTrue(date1 < date2)
        XCTAssertTrue(date1 <= date2)
        XCTAssertFalse(date1 > date2)
        XCTAssertFalse(date1 >= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 == date2)
        
        date2 = GregorianDate(gYear: "2016+01:00")!
        XCTAssertTrue(date1 < date2)
        XCTAssertTrue(date1 <= date2)
        XCTAssertFalse(date1 > date2)
        XCTAssertFalse(date1 >= date2)
        XCTAssertTrue(date1 != date2)
        XCTAssertFalse(date1 == date2)
    }
}


