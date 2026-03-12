import SwiftUI
import Combine

/// Observable engine that manages the calendar state: displayed month/week,
/// page generation, and selection logic.
@MainActor
public final class CalendarEngine: ObservableObject {

    // MARK: - Published State

    @Published public var displayedMonth: Date
    @Published public var selection: SheepSelection
    @Published public var scope: SheepScope

    // MARK: - Configuration (set via environment, mirrored here for engine use)

    public var firstWeekday: Int = 1
    public var placeholderMode: PlaceholderMode = .none
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var eventsProvider: ((Date) -> [SheepEvent])?

    private let calendar: Calendar

    // MARK: - Init

    public init(
        displayedMonth: Date = Date(),
        selection: SheepSelection = .single(nil),
        scope: SheepScope = .month,
        calendar: Calendar = .current
    ) {
        self.displayedMonth = calendar.startOfDay(for: displayedMonth)
        self.selection = selection
        self.scope = scope
        self.calendar = calendar
    }

    // MARK: - Navigation

    public func goToNextMonth() {
        displayedMonth = DateUtilities.monthByAdding(1, to: displayedMonth, calendar: calendar)
    }

    public func goToPreviousMonth() {
        displayedMonth = DateUtilities.monthByAdding(-1, to: displayedMonth, calendar: calendar)
    }

    public func goToNextWeek() {
        displayedMonth = DateUtilities.weekByAdding(1, to: displayedMonth, calendar: calendar)
    }

    public func goToPreviousWeek() {
        displayedMonth = DateUtilities.weekByAdding(-1, to: displayedMonth, calendar: calendar)
    }

    public func goToToday() {
        displayedMonth = calendar.startOfDay(for: Date())
    }

    // MARK: - Grid Generation

    public func monthSlots() -> [DaySlot] {
        MonthGrid.generate(
            for: displayedMonth,
            firstWeekday: firstWeekday,
            placeholderMode: placeholderMode,
            calendar: calendar
        )
    }

    public func weekDates() -> [Date] {
        WeekGrid.generate(
            for: displayedMonth,
            firstWeekday: firstWeekday,
            calendar: calendar
        )
    }

    // MARK: - Selection

    public func selectDate(_ date: Date) {
        let normalized = calendar.startOfDay(for: date)

        // Check bounds
        if let min = minimumDate, normalized < calendar.startOfDay(for: min) { return }
        if let max = maximumDate, normalized > calendar.startOfDay(for: max) { return }

        switch selection {
        case .single:
            selection = .single(normalized)
        case .multi(var set):
            if set.contains(normalized) {
                set.remove(normalized)
            } else {
                set.insert(normalized)
            }
            selection = .multi(set)
        case .range(let existing):
            if let range = existing {
                // If tapping the same start, clear
                if DateUtilities.isSameDay(normalized, range.lowerBound, calendar: calendar) {
                    selection = .range(nil)
                } else {
                    // Start a new range
                    selection = .range(nil)
                    // Then set new start
                    selection = .range(normalized...normalized)
                }
            } else {
                // No range yet — this is the start
                selection = .range(normalized...normalized)
            }
        }
    }

    /// Handle second tap for range selection — extends to create actual range.
    public func extendRange(to date: Date) {
        let normalized = calendar.startOfDay(for: date)
        guard case .range(let existing) = selection, let range = existing else { return }

        let start = range.lowerBound
        if normalized < start {
            selection = .range(normalized...start)
        } else {
            selection = .range(start...normalized)
        }
    }

    // MARK: - State Building

    public func dayState(for slot: DaySlot) -> DayState {
        let date = calendar.startOfDay(for: slot.date)
        let weekday = calendar.component(.weekday, from: date)
        let events = eventsProvider?(date) ?? []

        let isSelected: Bool
        let isRangeStart: Bool
        let isRangeEnd: Bool
        let isRangeMiddle: Bool

        switch selection {
        case .single(let selected):
            isSelected = selected.map { DateUtilities.isSameDay($0, date, calendar: calendar) } ?? false
            isRangeStart = false
            isRangeEnd = false
            isRangeMiddle = false
        case .multi(let set):
            isSelected = set.contains(where: { DateUtilities.isSameDay($0, date, calendar: calendar) })
            isRangeStart = false
            isRangeEnd = false
            isRangeMiddle = false
        case .range(let range):
            if let r = range {
                isRangeStart = DateUtilities.isSameDay(date, r.lowerBound, calendar: calendar)
                isRangeEnd = DateUtilities.isSameDay(date, r.upperBound, calendar: calendar)
                isRangeMiddle = date > r.lowerBound && date < r.upperBound
                    && !isRangeStart && !isRangeEnd
                isSelected = isRangeStart || isRangeEnd
            } else {
                isSelected = false
                isRangeStart = false
                isRangeEnd = false
                isRangeMiddle = false
            }
        }

        let isDisabled: Bool
        if let min = minimumDate, date < calendar.startOfDay(for: min) {
            isDisabled = true
        } else if let max = maximumDate, date > calendar.startOfDay(for: max) {
            isDisabled = true
        } else {
            isDisabled = false
        }

        return DayState(
            date: date,
            dayNumber: slot.dayNumber,
            isToday: calendar.isDateInToday(date),
            isSelected: isSelected,
            isRangeStart: isRangeStart,
            isRangeEnd: isRangeEnd,
            isRangeMiddle: isRangeMiddle,
            isPlaceholder: !slot.belongsToDisplayedMonth,
            isDisabled: isDisabled,
            isWeekend: DateUtilities.isWeekend(weekday: weekday),
            belongsToDisplayedMonth: slot.belongsToDisplayedMonth,
            events: events
        )
    }
}
