import XCTest
@testable import SheepCalendar

final class MonthGridTests: XCTestCase {

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        DateComponents(calendar: calendar, year: year, month: month, day: day).date!
    }

    // MARK: - Basic generation

    func testMarchApril2026_SundayFirst_NoPlaceholders() {
        // March 2026: starts on Sunday (weekday 1), 31 days
        let slots = MonthGrid.generate(
            for: date(2026, 3, 1),
            firstWeekday: 1,
            placeholderMode: .none,
            calendar: calendar
        )

        // March 1, 2026 is a Sunday → offset 0
        // 31 days → 31 cells, rounded up to 35 (5 rows)
        let inMonthSlots = slots.filter { $0.belongsToDisplayedMonth }
        XCTAssertEqual(inMonthSlots.count, 31)
        XCTAssertEqual(inMonthSlots.first?.dayNumber, 1)
        XCTAssertEqual(inMonthSlots.last?.dayNumber, 31)

        // Total should be multiple of 7
        XCTAssertEqual(slots.count % 7, 0)
    }

    func testFebruary2026_MondayFirst() {
        // Feb 2026: 28 days, Feb 1 is a Sunday (weekday 1)
        // With Monday first, offset = (1 - 2 + 7) % 7 = 6
        let slots = MonthGrid.generate(
            for: date(2026, 2, 1),
            firstWeekday: 2,
            placeholderMode: .none,
            calendar: calendar
        )

        let inMonthSlots = slots.filter { $0.belongsToDisplayedMonth }
        XCTAssertEqual(inMonthSlots.count, 28)

        // Leading placeholders = 6 (Mon-Sat before Sunday Feb 1)
        let leadingPlaceholders = slots.prefix(while: { !$0.belongsToDisplayedMonth })
        XCTAssertEqual(leadingPlaceholders.count, 6)

        XCTAssertEqual(slots.count % 7, 0)
    }

    // MARK: - Placeholder modes

    func testFillSixRows() {
        let slots = MonthGrid.generate(
            for: date(2026, 3, 1),
            firstWeekday: 1,
            placeholderMode: .fillSixRows,
            calendar: calendar
        )
        XCTAssertEqual(slots.count, 42) // Always 6 rows
    }

    func testFillHeadTail_PlaceholderDates() {
        // Feb 2026 with Monday first → 6 leading placeholders from January
        let slots = MonthGrid.generate(
            for: date(2026, 2, 1),
            firstWeekday: 2,
            placeholderMode: .fillHeadTail,
            calendar: calendar
        )

        let leading = slots.prefix(while: { !$0.belongsToDisplayedMonth })
        XCTAssertEqual(leading.count, 6)

        // First placeholder should be Jan 26 (Monday)
        let firstSlot = slots[0]
        let comps = calendar.dateComponents([.month, .day], from: firstSlot.date)
        XCTAssertEqual(comps.month, 1)
        XCTAssertEqual(comps.day, 26)
    }

    // MARK: - Row count

    func testRowCount() {
        let slots = MonthGrid.generate(
            for: date(2026, 3, 1),
            firstWeekday: 1,
            placeholderMode: .fillSixRows,
            calendar: calendar
        )
        XCTAssertEqual(MonthGrid.rowCount(for: slots), 6)
    }

    // MARK: - Edge case: month starting on first weekday

    func testMonthStartingOnFirstWeekday() {
        // Find a month that starts on Sunday with Sunday-first → 0 offset
        // March 2026 starts on Sunday
        let slots = MonthGrid.generate(
            for: date(2026, 3, 1),
            firstWeekday: 1,
            placeholderMode: .none,
            calendar: calendar
        )

        // No leading placeholders needed
        XCTAssertTrue(slots.first?.belongsToDisplayedMonth ?? false)
        XCTAssertEqual(slots.first?.dayNumber, 1)
    }
}
