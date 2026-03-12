import SwiftUI

/// Animated container that toggles between month and week scope.
///
/// Wraps the calendar content and animates the height transition
/// when scope changes between `.month` and `.week`.
struct ScopeToggleView: View {
    @Binding var scope: SheepScope
    @Binding var displayedMonth: Date
    @Binding var selection: SheepSelection
    let calendar: Calendar

    @Environment(\.sheepTheme) private var theme

    var body: some View {
        VStack(spacing: 0) {
            switch scope {
            case .month:
                MonthPageView(
                    displayedMonth: displayedMonth,
                    selection: $selection,
                    calendar: calendar
                )
                .transition(.opacity)
            case .week:
                WeekRowView(
                    displayedMonth: $displayedMonth,
                    selection: $selection,
                    calendar: calendar
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: scope)
    }
}
