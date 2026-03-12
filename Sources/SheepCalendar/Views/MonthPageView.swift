import SwiftUI

/// LazyVGrid layout for one month of day cells.
struct MonthPageView: View {
    @Environment(\.sheepTheme) private var theme
    @Environment(\.sheepFirstWeekday) private var firstWeekday
    @Environment(\.sheepPlaceholderMode) private var placeholderMode
    @Environment(\.sheepEventsProvider) private var eventsProvider
    @Environment(\.sheepMinDate) private var minDate
    @Environment(\.sheepMaxDate) private var maxDate
    @Environment(\.sheepDayCellBuilder) private var customDayCell
    @Environment(\.sheepDateSelectCallback) private var dateSelectCallback

    let displayedMonth: Date
    @Binding var selection: SheepSelection
    let calendar: Calendar

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        let engine = makeEngine()
        let slots = engine.monthSlots()

        LazyVGrid(columns: columns, spacing: theme.rowSpacing) {
            ForEach(slots) { slot in
                let state = engine.dayState(for: slot)
                dayCellContent(slot: slot, state: state, engine: engine)
            }
        }
        .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func dayCellContent(slot: DaySlot, state: DayState, engine: CalendarEngine) -> some View {
        if !slot.belongsToDisplayedMonth && placeholderMode == .none {
            // Empty cell for grid alignment
            Color.clear
                .frame(height: theme.dayCellHeight)
        } else if let builder = customDayCell {
            builder(slot.date, state)
                .onTapGesture {
                    handleTap(date: slot.date, engine: engine)
                }
        } else {
            DayCellView(state: state) {
                handleTap(date: slot.date, engine: engine)
            }
        }
    }

    private func handleTap(date: Date, engine: CalendarEngine) {
        let normalized = calendar.startOfDay(for: date)

        // Check bounds
        if let min = minDate, normalized < calendar.startOfDay(for: min) { return }
        if let max = maxDate, normalized > calendar.startOfDay(for: max) { return }

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

    private func makeEngine() -> CalendarEngine {
        let engine = CalendarEngine(
            displayedMonth: displayedMonth,
            selection: selection,
            calendar: calendar
        )
        engine.firstWeekday = firstWeekday.rawValue
        engine.placeholderMode = placeholderMode
        engine.minimumDate = minDate
        engine.maximumDate = maxDate
        engine.eventsProvider = eventsProvider
        return engine
    }
}
