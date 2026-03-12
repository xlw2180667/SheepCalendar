import SwiftUI

/// Single week row view for week scope display.
struct WeekRowView: View {
    @Binding var displayedMonth: Date
    @Binding var selection: SheepSelection
    let calendar: Calendar

    @Environment(\.sheepTheme) private var theme
    @Environment(\.sheepFirstWeekday) private var firstWeekday
    @Environment(\.sheepEventsProvider) private var eventsProvider
    @Environment(\.sheepMinDate) private var minDate
    @Environment(\.sheepMaxDate) private var maxDate
    @Environment(\.sheepDayCellBuilder) private var customDayCell
    @Environment(\.sheepDateSelectCallback) private var dateSelectCallback

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        let dates = WeekGrid.generate(
            for: displayedMonth,
            firstWeekday: firstWeekday.rawValue,
            calendar: calendar
        )

        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(dates.enumerated()), id: \.offset) { _, date in
                let state = makeDayState(for: date)
                if let builder = customDayCell {
                    builder(date, state)
                        .onTapGesture { handleTap(date) }
                } else {
                    DayCellView(state: state) {
                        handleTap(date)
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }

    private func makeDayState(for date: Date) -> DayState {
        let normalized = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: normalized)
        let dayNum = calendar.component(.day, from: normalized)
        let events = eventsProvider?(normalized) ?? []

        let isSelected: Bool
        let isRangeStart: Bool
        let isRangeEnd: Bool
        let isRangeMiddle: Bool

        switch selection {
        case .single(let sel):
            isSelected = sel.map { DateUtilities.isSameDay($0, normalized, calendar: calendar) } ?? false
            isRangeStart = false; isRangeEnd = false; isRangeMiddle = false
        case .multi(let set):
            isSelected = set.contains(where: { DateUtilities.isSameDay($0, normalized, calendar: calendar) })
            isRangeStart = false; isRangeEnd = false; isRangeMiddle = false
        case .range(let r):
            if let range = r {
                isRangeStart = DateUtilities.isSameDay(normalized, range.lowerBound, calendar: calendar)
                isRangeEnd = DateUtilities.isSameDay(normalized, range.upperBound, calendar: calendar)
                isRangeMiddle = normalized > range.lowerBound && normalized < range.upperBound
                isSelected = isRangeStart || isRangeEnd
            } else {
                isSelected = false; isRangeStart = false; isRangeEnd = false; isRangeMiddle = false
            }
        }

        let isDisabled: Bool
        if let min = minDate, normalized < calendar.startOfDay(for: min) {
            isDisabled = true
        } else if let max = maxDate, normalized > calendar.startOfDay(for: max) {
            isDisabled = true
        } else {
            isDisabled = false
        }

        let inMonth = DateUtilities.isSameMonth(normalized, displayedMonth, calendar: calendar)

        return DayState(
            date: normalized,
            dayNumber: dayNum,
            isToday: calendar.isDateInToday(normalized),
            isSelected: isSelected,
            isRangeStart: isRangeStart,
            isRangeEnd: isRangeEnd,
            isRangeMiddle: isRangeMiddle,
            isPlaceholder: !inMonth,
            isDisabled: isDisabled,
            isWeekend: DateUtilities.isWeekend(weekday: weekday),
            belongsToDisplayedMonth: inMonth,
            events: events
        )
    }

    private func handleTap(_ date: Date) {
        let normalized = calendar.startOfDay(for: date)
        if let min = minDate, normalized < calendar.startOfDay(for: min) { return }
        if let max = maxDate, normalized > calendar.startOfDay(for: max) { return }

        switch selection {
        case .single:
            selection = .single(normalized)
        case .multi(var set):
            if set.contains(normalized) { set.remove(normalized) } else { set.insert(normalized) }
            selection = .multi(set)
        case .range(let existing):
            if let range = existing {
                if DateUtilities.isSameDay(normalized, range.lowerBound, calendar: calendar) {
                    selection = .range(nil)
                } else if normalized < range.lowerBound {
                    selection = .range(normalized...range.upperBound)
                } else {
                    selection = .range(range.lowerBound...normalized)
                }
            } else {
                selection = .range(normalized...normalized)
            }
        }

        dateSelectCallback?(normalized)
    }
}
