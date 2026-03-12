import XCTest
@testable import SheepCalendar

@MainActor
final class SelectionTests: XCTestCase {

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        DateComponents(calendar: calendar, year: year, month: month, day: day).date!
    }

    // MARK: - Single selection

    func testSingleSelection() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .single(nil),
            calendar: calendar
        )

        engine.selectDate(date(2026, 3, 15))
        XCTAssertEqual(engine.selection.singleDate, date(2026, 3, 15))
    }

    func testSingleSelectionReplace() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .single(date(2026, 3, 10)),
            calendar: calendar
        )

        engine.selectDate(date(2026, 3, 20))
        XCTAssertEqual(engine.selection.singleDate, date(2026, 3, 20))
    }

    // MARK: - Multi selection

    func testMultiSelection_Toggle() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .multi(Set()),
            calendar: calendar
        )

        engine.selectDate(date(2026, 3, 5))
        XCTAssertEqual(engine.selection.multiDates?.count, 1)

        engine.selectDate(date(2026, 3, 10))
        XCTAssertEqual(engine.selection.multiDates?.count, 2)

        // Toggle off
        engine.selectDate(date(2026, 3, 5))
        XCTAssertEqual(engine.selection.multiDates?.count, 1)
    }

    // MARK: - Range selection

    func testRangeSelection_StartAndExtend() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .range(nil),
            calendar: calendar
        )

        engine.selectDate(date(2026, 3, 5))
        // After first tap, range is start...start
        XCTAssertNotNil(engine.selection.dateRange)

        engine.extendRange(to: date(2026, 3, 10))
        let range = engine.selection.dateRange
        XCTAssertNotNil(range)
        XCTAssertEqual(range?.lowerBound, date(2026, 3, 5))
        XCTAssertEqual(range?.upperBound, date(2026, 3, 10))
    }

    func testRangeSelection_ReverseOrder() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .range(nil),
            calendar: calendar
        )

        engine.selectDate(date(2026, 3, 15))
        engine.extendRange(to: date(2026, 3, 5))

        let range = engine.selection.dateRange
        XCTAssertEqual(range?.lowerBound, date(2026, 3, 5))
        XCTAssertEqual(range?.upperBound, date(2026, 3, 15))
    }

    // MARK: - Min/Max bounds

    func testSelectionRespectsMinDate() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .single(nil),
            calendar: calendar
        )
        engine.minimumDate = date(2026, 3, 10)

        engine.selectDate(date(2026, 3, 5))
        XCTAssertNil(engine.selection.singleDate)

        engine.selectDate(date(2026, 3, 15))
        XCTAssertEqual(engine.selection.singleDate, date(2026, 3, 15))
    }

    func testSelectionRespectsMaxDate() {
        let engine = CalendarEngine(
            displayedMonth: date(2026, 3, 1),
            selection: .single(nil),
            calendar: calendar
        )
        engine.maximumDate = date(2026, 3, 20)

        engine.selectDate(date(2026, 3, 25))
        XCTAssertNil(engine.selection.singleDate)

        engine.selectDate(date(2026, 3, 15))
        XCTAssertEqual(engine.selection.singleDate, date(2026, 3, 15))
    }
}
