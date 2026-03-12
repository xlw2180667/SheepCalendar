import Foundation

/// Controls how placeholder (out-of-month) days are displayed.
public enum PlaceholderMode: Hashable, Sendable {
    /// Show no placeholders — empty cells before/after the month.
    case none
    /// Fill the head and tail with neighboring month days.
    case fillHeadTail
    /// Always render exactly 6 rows (42 cells) for consistent height.
    case fillSixRows
}
