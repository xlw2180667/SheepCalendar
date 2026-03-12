import SwiftUI

/// A full-featured SwiftUI calendar view.
///
/// Minimal usage:
/// ```swift
/// @State private var month = Date()
/// @State private var selection: SheepSelection = .single(nil)
///
/// SheepCalendarView(displayedMonth: $month, selection: $selection)
/// ```
///
/// Configure with environment modifiers:
/// ```swift
/// SheepCalendarView(displayedMonth: $month, selection: $selection)
///     .sheepCalendarTheme(SheepCalendarTheme(selectionColor: .blue))
///     .sheepCalendarFirstWeekday(.monday)
///     .sheepCalendarScope(.month)
/// ```
public struct SheepCalendarView: View {
    @Binding var displayedMonth: Date
    @Binding var selection: SheepSelection

    @Environment(\.sheepScope) private var scope
    @Environment(\.sheepScrollDirection) private var scrollDirection
    @Environment(\.sheepHeaderBuilder) private var customHeader
    @Environment(\.sheepPageChangeCallback) private var pageChangeCallback

    private let calendar = Calendar.current

    public init(displayedMonth: Binding<Date>, selection: Binding<SheepSelection>) {
        self._displayedMonth = displayedMonth
        self._selection = selection
    }

    public var body: some View {
        VStack(spacing: 8) {
            headerContent

            WeekdayBarView()

            switch scope {
            case .month:
                monthContent
            case .week:
                weekContent
            }
        }
        .onChange(of: displayedMonth) { newMonth in
            pageChangeCallback?(newMonth)
        }
    }

    @ViewBuilder
    private var headerContent: some View {
        if let builder = customHeader {
            builder(displayedMonth, goBack, goForward)
        } else {
            HeaderView(
                displayedMonth: displayedMonth,
                onBack: goBack,
                onForward: goForward
            )
        }
    }

    @ViewBuilder
    private var monthContent: some View {
        if scrollDirection == .horizontal {
            PagingContainerView(
                displayedMonth: $displayedMonth,
                selection: $selection,
                calendar: calendar
            )
        } else {
            VerticalScrollContainerView(
                displayedMonth: $displayedMonth,
                selection: $selection,
                calendar: calendar
            )
        }
    }

    @ViewBuilder
    private var weekContent: some View {
        WeekRowView(
            displayedMonth: $displayedMonth,
            selection: $selection,
            calendar: calendar
        )
    }

    private func goBack() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch scope {
            case .month:
                displayedMonth = DateUtilities.monthByAdding(-1, to: displayedMonth, calendar: calendar)
            case .week:
                displayedMonth = DateUtilities.weekByAdding(-1, to: displayedMonth, calendar: calendar)
            }
        }
    }

    private func goForward() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch scope {
            case .month:
                displayedMonth = DateUtilities.monthByAdding(1, to: displayedMonth, calendar: calendar)
            case .week:
                displayedMonth = DateUtilities.weekByAdding(1, to: displayedMonth, calendar: calendar)
            }
        }
    }
}
