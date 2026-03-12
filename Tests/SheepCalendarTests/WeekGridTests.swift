import XCTest
@testable import SheepCalendar

final class WeekGridTests: XCTestCase {

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        DateComponents(calendar: calendar, year: year, month: month, day: day).date!
    }

    func testWeekGeneration_SundayFirst() {
        // March 12, 2026 is a Thursday
        let dates = WeekGrid.generate(
            for: date(2026, 3, 12),
            firstWeekday: 1,
            calendar: calendar
        )

        XCTAssertEqual(dates.count, 7)

        // Week should start on Sunday March 8
        let firstComps = calendar.dateComponents([.month, .day], from: dates[0])
        XCTAssertEqual(firstComps.month, 3)
        XCTAssertEqual(firstComps.day, 8)

        // And end on Saturday March 14
        let lastComps = calendar.dateComponents([.month, .day], from: dates[6])
        XCTAssertEqual(lastComps.month, 3)
        XCTAssertEqual(lastComps.day, 14)
    }

    func testWeekGeneration_MondayFirst() {
        // March 12, 2026 is a Thursday
        let dates = WeekGrid.generate(
            for: date(2026, 3, 12),
            firstWeekday: 2,
            calendar: calendar
        )

        XCTAssertEqual(dates.count, 7)

        // Week should start on Monday March 9
        let firstComps = calendar.dateComponents([.month, .day], from: dates[0])
        XCTAssertEqual(firstComps.month, 3)
        XCTAssertEqual(firstComps.day, 9)

        // And end on Sunday March 15
        let lastComps = calendar.dateComponents([.month, .day], from: dates[6])
        XCTAssertEqual(lastComps.month, 3)
        XCTAssertEqual(lastComps.day, 15)
    }

    func testWeekCrossingMonthBoundary() {
        // March 30, 2026 — week should cross into April
        let dates = WeekGrid.generate(
            for: date(2026, 3, 30),
            firstWeekday: 1,
            calendar: calendar
        )

        // Sunday March 29 → Saturday April 4
        let firstComps = calendar.dateComponents([.month, .day], from: dates[0])
        XCTAssertEqual(firstComps.month, 3)
        XCTAssertEqual(firstComps.day, 29)

        let lastComps = calendar.dateComponents([.month, .day], from: dates[6])
        XCTAssertEqual(lastComps.month, 4)
        XCTAssertEqual(lastComps.day, 4)
    }

    func testWeekOnFirstDay() {
        // If the date IS the first day of the week
        // Sunday March 8, with Sunday first
        let dates = WeekGrid.generate(
            for: date(2026, 3, 8),
            firstWeekday: 1,
            calendar: calendar
        )

        let firstComps = calendar.dateComponents([.month, .day], from: dates[0])
        XCTAssertEqual(firstComps.day, 8)
    }
}
