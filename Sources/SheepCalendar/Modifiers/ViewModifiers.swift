import SwiftUI

// MARK: - Public View Modifiers

extension View {

    /// Set the calendar display scope.
    public func sheepCalendarScope(_ scope: SheepScope) -> some View {
        environment(\.sheepScope, scope)
    }

    /// Set the scroll/swipe direction for month navigation.
    public func sheepCalendarScrollDirection(_ direction: ScrollDirection) -> some View {
        environment(\.sheepScrollDirection, direction)
    }

    /// Set which day of the week appears first.
    public func sheepCalendarFirstWeekday(_ weekday: Weekday) -> some View {
        environment(\.sheepFirstWeekday, weekday)
    }

    /// Constrain selectable dates to a range.
    public func sheepCalendarDateRange(min: Date? = nil, max: Date? = nil) -> some View {
        environment(\.sheepMinDate, min)
            .environment(\.sheepMaxDate, max)
    }

    /// Set the placeholder mode for out-of-month days.
    public func sheepCalendarPlaceholder(_ mode: PlaceholderMode) -> some View {
        environment(\.sheepPlaceholderMode, mode)
    }

    /// Apply a custom visual theme.
    public func sheepCalendarTheme(_ theme: SheepCalendarTheme) -> some View {
        environment(\.sheepTheme, theme)
    }

    /// Provide events for dates. The closure is called per-date during rendering.
    public func sheepCalendarEvents(_ provider: @escaping (Date) -> [SheepEvent]) -> some View {
        environment(\.sheepEventsProvider, provider)
    }

    /// Replace the default day cell with a custom view.
    public func sheepCalendarDayCell<Content: View>(
        @ViewBuilder _ builder: @escaping (Date, DayState) -> Content
    ) -> some View {
        environment(\.sheepDayCellBuilder, { date, state in AnyView(builder(date, state)) })
    }

    /// Replace the default header with a custom view.
    ///
    /// The closure receives the displayed date, a "go back" action, and a "go forward" action.
    public func sheepCalendarHeader<Content: View>(
        @ViewBuilder _ builder: @escaping (Date, @escaping () -> Void, @escaping () -> Void) -> Content
    ) -> some View {
        environment(\.sheepHeaderBuilder, { date, back, forward in AnyView(builder(date, back, forward)) })
    }

    /// Called when a date is tapped.
    public func onSheepDateSelect(_ action: @escaping (Date) -> Void) -> some View {
        environment(\.sheepDateSelectCallback, action)
    }

    /// Called when the displayed month/week changes.
    public func onSheepPageChange(_ action: @escaping (Date) -> Void) -> some View {
        environment(\.sheepPageChangeCallback, action)
    }
}
