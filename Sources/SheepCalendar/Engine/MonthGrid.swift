import Foundation

/// A slot in the month grid — either a real day or a placeholder from a neighboring month.
public struct DaySlot: Identifiable, Equatable {
    public let id: String
    public let date: Date
    public let dayNumber: Int
    public let belongsToDisplayedMonth: Bool

    public init(date: Date, dayNumber: Int, belongsToDisplayedMonth: Bool) {
        // Unique ID: "2026-03-15" or "placeholder-2026-02-28"
        let prefix = belongsToDisplayedMonth ? "" : "placeholder-"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.id = prefix + formatter.string(from: date)
        self.date = date
        self.dayNumber = dayNumber
        self.belongsToDisplayedMonth = belongsToDisplayedMonth
    }
}

/// Pure date-math struct that computes the grid of `DaySlot`s for one month.
///
/// No SwiftUI dependency — fully unit-testable.
public struct MonthGrid {

    /// Generate the grid for the month containing `date`.
    ///
    /// - Parameters:
    ///   - date: Any date within the target month.
    ///   - firstWeekday: 1 = Sunday … 7 = Saturday.
    ///   - placeholderMode: How to handle leading/trailing cells.
    ///   - calendar: The calendar to use for date math.
    /// - Returns: An array of `DaySlot` arranged in rows of 7.
    public static func generate(
        for date: Date,
        firstWeekday: Int = 1,
        placeholderMode: PlaceholderMode = .none,
        calendar: Calendar = .current
    ) -> [DaySlot] {
        var cal = calendar
        cal.firstWeekday = firstWeekday

        let firstOfMonth = DateUtilities.firstOfMonth(date, calendar: cal)
        let daysCount = DateUtilities.daysInMonth(date, calendar: cal)
        let firstWeekdayOfMonth = DateUtilities.weekdayComponent(firstOfMonth, calendar: cal)
        let leadingOffset = DateUtilities.weekdayOffset(
            weekday: firstWeekdayOfMonth,
            firstWeekday: firstWeekday
        )

        var slots: [DaySlot] = []

        // Leading placeholders
        switch placeholderMode {
        case .none:
            // Empty DaySlots for alignment — we still need them for grid positioning
            // but we mark them as not belonging to the month.
            // Actually for .none, we use nil-like slots. We'll use a sentinel approach:
            // Insert blank slots that the view layer will render as empty.
            for i in 0..<leadingOffset {
                let prevDate = cal.date(byAdding: .day, value: -(leadingOffset - i), to: firstOfMonth)!
                let day = cal.component(.day, from: prevDate)
                slots.append(DaySlot(date: prevDate, dayNumber: day, belongsToDisplayedMonth: false))
            }
        case .fillHeadTail, .fillSixRows:
            for i in 0..<leadingOffset {
                let prevDate = cal.date(byAdding: .day, value: -(leadingOffset - i), to: firstOfMonth)!
                let day = cal.component(.day, from: prevDate)
                slots.append(DaySlot(date: prevDate, dayNumber: day, belongsToDisplayedMonth: false))
            }
        }

        // Days of the month
        for dayIndex in 0..<daysCount {
            let d = cal.date(byAdding: .day, value: dayIndex, to: firstOfMonth)!
            slots.append(DaySlot(date: d, dayNumber: dayIndex + 1, belongsToDisplayedMonth: true))
        }

        // Trailing placeholders
        let totalSoFar = slots.count
        let targetCount: Int
        switch placeholderMode {
        case .none:
            // Pad to complete the last row
            let remainder = totalSoFar % 7
            targetCount = remainder == 0 ? totalSoFar : totalSoFar + (7 - remainder)
        case .fillHeadTail:
            let remainder = totalSoFar % 7
            targetCount = remainder == 0 ? totalSoFar : totalSoFar + (7 - remainder)
        case .fillSixRows:
            targetCount = 42 // 6 rows × 7 columns
        }

        if slots.count < targetCount {
            let lastDayOfMonth = cal.date(byAdding: .day, value: daysCount - 1, to: firstOfMonth)!
            for i in 1...(targetCount - slots.count) {
                let nextDate = cal.date(byAdding: .day, value: i, to: lastDayOfMonth)!
                let day = cal.component(.day, from: nextDate)
                slots.append(DaySlot(date: nextDate, dayNumber: day, belongsToDisplayedMonth: false))
            }
        }

        return slots
    }

    /// Number of rows in a grid for the given slot count.
    public static func rowCount(for slots: [DaySlot]) -> Int {
        (slots.count + 6) / 7
    }
}
