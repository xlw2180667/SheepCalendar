import XCTest
@testable import SheepCalendar

final class DateUtilitiesTests: XCTestCase {

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        DateComponents(calendar: calendar, year: year, month: month, day: day).date!
    }

    // MARK: - startOfDay

    func testStartOfDay() {
        let noon = calendar.date(bySettingHour: 12, minute: 30, second: 0, of: date(2026, 3, 15))!
        let start = DateUtilities.startOfDay(noon, calendar: calendar)
        let comps = calendar.dateComponents([.hour, .minute, .second], from: start)
        XCTAssertEqual(comps.hour, 0)
        XCTAssertEqual(comps.minute, 0)
        XCTAssertEqual(comps.second, 0)
    }

    // MARK: - firstOfMonth

    func testFirstOfMonth() {
        let mid = date(2026, 7, 18)
        let first = DateUtilities.firstOfMonth(mid, calendar: calendar)
        let comps = calendar.dateComponents([.year, .month, .day], from: first)
        XCTAssertEqual(comps.year, 2026)
        XCTAssertEqual(comps.month, 7)
        XCTAssertEqual(comps.day, 1)
    }

    // MARK: - daysInMonth

    func testDaysInMonth_February_NonLeap() {
        let feb = date(2026, 2, 1) // 2026 is not a leap year
        XCTAssertEqual(DateUtilities.daysInMonth(feb, calendar: calendar), 28)
    }

    func testDaysInMonth_February_Leap() {
        let feb = date(2028, 2, 1) // 2028 is a leap year
        XCTAssertEqual(DateUtilities.daysInMonth(feb, calendar: calendar), 29)
    }

    func testDaysInMonth_March() {
        let mar = date(2026, 3, 1)
        XCTAssertEqual(DateUtilities.daysInMonth(mar, calendar: calendar), 31)
    }

    // MARK: - weekdayOffset

    func testWeekdayOffset_SundayFirst() {
        // Sunday = 1 with firstWeekday = 1 → offset 0
        XCTAssertEqual(DateUtilities.weekdayOffset(weekday: 1, firstWeekday: 1), 0)
        // Monday = 2 with firstWeekday = 1 → offset 1
        XCTAssertEqual(DateUtilities.weekdayOffset(weekday: 2, firstWeekday: 1), 1)
        // Saturday = 7 with firstWeekday = 1 → offset 6
        XCTAssertEqual(DateUtilities.weekdayOffset(weekday: 7, firstWeekday: 1), 6)
    }

    func testWeekdayOffset_MondayFirst() {
        // Monday = 2 with firstWeekday = 2 → offset 0
        XCTAssertEqual(DateUtilities.weekdayOffset(weekday: 2, firstWeekday: 2), 0)
        // Sunday = 1 with firstWeekday = 2 → offset 6
        XCTAssertEqual(DateUtilities.weekdayOffset(weekday: 1, firstWeekday: 2), 6)
        // Tuesday = 3 with firstWeekday = 2 → offset 1
        XCTAssertEqual(DateUtilities.weekdayOffset(weekday: 3, firstWeekday: 2), 1)
    }

    // MARK: - isSameDay

    func testIsSameDay() {
        let a = date(2026, 3, 12)
        let b = calendar.date(bySettingHour: 15, minute: 30, second: 0, of: date(2026, 3, 12))!
        XCTAssertTrue(DateUtilities.isSameDay(a, b, calendar: calendar))

        let c = date(2026, 3, 13)
        XCTAssertFalse(DateUtilities.isSameDay(a, c, calendar: calendar))
    }

    // MARK: - isSameMonth

    func testIsSameMonth() {
        XCTAssertTrue(DateUtilities.isSameMonth(date(2026, 3, 1), date(2026, 3, 31), calendar: calendar))
        XCTAssertFalse(DateUtilities.isSameMonth(date(2026, 3, 31), date(2026, 4, 1), calendar: calendar))
    }

    // MARK: - monthByAdding

    func testMonthByAdding() {
        let mar = date(2026, 3, 1)
        let apr = DateUtilities.monthByAdding(1, to: mar, calendar: calendar)
        let comps = calendar.dateComponents([.year, .month], from: apr)
        XCTAssertEqual(comps.month, 4)
        XCTAssertEqual(comps.year, 2026)

        let feb = DateUtilities.monthByAdding(-1, to: mar, calendar: calendar)
        let comps2 = calendar.dateComponents([.year, .month], from: feb)
        XCTAssertEqual(comps2.month, 2)
    }

    // MARK: - orderedWeekdaySymbols

    func testOrderedWeekdaySymbols_SundayFirst() {
        var cal = calendar
        cal.locale = Locale(identifier: "en_US")
        let symbols = DateUtilities.orderedWeekdaySymbols(firstWeekday: 1, calendar: cal)
        XCTAssertEqual(symbols.first, "S") // Sunday
    }

    func testOrderedWeekdaySymbols_MondayFirst() {
        var cal = calendar
        cal.locale = Locale(identifier: "en_US")
        let symbols = DateUtilities.orderedWeekdaySymbols(firstWeekday: 2, calendar: cal)
        XCTAssertEqual(symbols.first, "M") // Monday
        XCTAssertEqual(symbols.last, "S") // Sunday
    }

    // MARK: - isWeekend

    func testIsWeekend() {
        XCTAssertTrue(DateUtilities.isWeekend(weekday: 1))  // Sunday
        XCTAssertTrue(DateUtilities.isWeekend(weekday: 7))  // Saturday
        XCTAssertFalse(DateUtilities.isWeekend(weekday: 2)) // Monday
        XCTAssertFalse(DateUtilities.isWeekend(weekday: 4)) // Wednesday
    }
}
