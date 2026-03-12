import Foundation

/// First day of the week.
///
/// Raw values match `Calendar.firstWeekday` (1 = Sunday … 7 = Saturday).
public enum Weekday: Int, CaseIterable, Hashable, Sendable {
    case sunday    = 1
    case monday    = 2
    case tuesday   = 3
    case wednesday = 4
    case thursday  = 5
    case friday    = 6
    case saturday  = 7
}
