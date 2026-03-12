import Foundation

/// Date math utilities for the calendar engine.
enum DateUtilities {

    /// Returns `date` with time components stripped (midnight, start of day).
    static func startOfDay(_ date: Date, calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: date)
    }

    /// Returns the first day of the month containing `date`.
    static func firstOfMonth(_ date: Date, calendar: Calendar = .current) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps)!
    }

    /// Returns the number of days in the month containing `date`.
    static func daysInMonth(_ date: Date, calendar: Calendar = .current) -> Int {
        calendar.range(of: .day, in: .month, for: date)!.count
    }

    /// Returns the weekday of `date` (1 = Sunday … 7 = Saturday by default).
    static func weekdayComponent(_ date: Date, calendar: Calendar = .current) -> Int {
        calendar.component(.weekday, from: date)
    }

    /// Offset of a weekday relative to the calendar's `firstWeekday`.
    ///
    /// For example, if firstWeekday = 2 (Monday) and weekday = 1 (Sunday),
    /// the offset is 6 (Sunday appears at the end).
    static func weekdayOffset(weekday: Int, firstWeekday: Int) -> Int {
        (weekday - firstWeekday + 7) % 7
    }

    /// Returns the month offset by `delta` months from `date`.
    static func monthByAdding(_ delta: Int, to date: Date, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .month, value: delta, to: date)!
    }

    /// Returns the week offset by `delta` weeks from `date`.
    static func weekByAdding(_ delta: Int, to date: Date, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .weekOfYear, value: delta, to: date)!
    }

    /// Whether two dates fall on the same calendar day.
    static func isSameDay(_ a: Date, _ b: Date, calendar: Calendar = .current) -> Bool {
        calendar.isDate(a, inSameDayAs: b)
    }

    /// Whether two dates fall in the same month and year.
    static func isSameMonth(_ a: Date, _ b: Date, calendar: Calendar = .current) -> Bool {
        let ca = calendar.dateComponents([.year, .month], from: a)
        let cb = calendar.dateComponents([.year, .month], from: b)
        return ca.year == cb.year && ca.month == cb.month
    }

    /// Ordered weekday symbols starting from `firstWeekday`.
    ///
    /// Uses `veryShortWeekdaySymbols` by default (e.g., S M T W T F S).
    static func orderedWeekdaySymbols(
        firstWeekday: Int,
        calendar: Calendar = .current,
        style: WeekdaySymbolStyle = .veryShort
    ) -> [String] {
        let symbols: [String]
        switch style {
        case .veryShort: symbols = calendar.veryShortWeekdaySymbols
        case .short: symbols = calendar.shortWeekdaySymbols
        case .full: symbols = calendar.weekdaySymbols
        }
        // Rotate so that firstWeekday is at index 0
        let shift = firstWeekday - 1
        return Array(symbols[shift...]) + Array(symbols[..<shift])
    }

    /// Whether a weekday (1-7) falls on Saturday (7) or Sunday (1).
    static func isWeekend(weekday: Int) -> Bool {
        weekday == 1 || weekday == 7
    }

    enum WeekdaySymbolStyle {
        case veryShort, short, full
    }
}
