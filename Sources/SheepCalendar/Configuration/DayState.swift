import Foundation

/// Complete state for a single day cell, passed to custom cell builders.
public struct DayState: Equatable {
    public let date: Date
    public let dayNumber: Int
    public let isToday: Bool
    public let isSelected: Bool
    public let isRangeStart: Bool
    public let isRangeEnd: Bool
    public let isRangeMiddle: Bool
    public let isPlaceholder: Bool
    public let isDisabled: Bool
    public let isWeekend: Bool
    public let belongsToDisplayedMonth: Bool
    public let events: [SheepEvent]

    public init(
        date: Date,
        dayNumber: Int,
        isToday: Bool = false,
        isSelected: Bool = false,
        isRangeStart: Bool = false,
        isRangeEnd: Bool = false,
        isRangeMiddle: Bool = false,
        isPlaceholder: Bool = false,
        isDisabled: Bool = false,
        isWeekend: Bool = false,
        belongsToDisplayedMonth: Bool = true,
        events: [SheepEvent] = []
    ) {
        self.date = date
        self.dayNumber = dayNumber
        self.isToday = isToday
        self.isSelected = isSelected
        self.isRangeStart = isRangeStart
        self.isRangeEnd = isRangeEnd
        self.isRangeMiddle = isRangeMiddle
        self.isPlaceholder = isPlaceholder
        self.isDisabled = isDisabled
        self.isWeekend = isWeekend
        self.belongsToDisplayedMonth = belongsToDisplayedMonth
        self.events = events
    }
}
