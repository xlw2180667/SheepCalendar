import Foundation

/// Pure date-math struct that computes the 7 dates for one week row.
public struct WeekGrid {

    /// Generate the 7 dates for the week containing `date`.
    ///
    /// - Parameters:
    ///   - date: Any date within the target week.
    ///   - firstWeekday: 1 = Sunday … 7 = Saturday.
    ///   - calendar: The calendar to use for date math.
    /// - Returns: Array of 7 `Date`s starting from the week's first day.
    public static func generate(
        for date: Date,
        firstWeekday: Int = 1,
        calendar: Calendar = .current
    ) -> [Date] {
        var cal = calendar
        cal.firstWeekday = firstWeekday

        let weekday = cal.component(.weekday, from: date)
        let offset = DateUtilities.weekdayOffset(weekday: weekday, firstWeekday: firstWeekday)
        let startOfWeek = cal.date(byAdding: .day, value: -offset, to: cal.startOfDay(for: date))!

        return (0..<7).map { i in
            cal.date(byAdding: .day, value: i, to: startOfWeek)!
        }
    }
}
