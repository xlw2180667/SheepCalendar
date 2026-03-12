import SwiftUI

/// Horizontal paging container using a 3-page TabView window.
///
/// Pages [prev, current, next] recenter after swipe completes.
struct PagingContainerView: View {
    @Binding var displayedMonth: Date
    @Binding var selection: SheepSelection
    let calendar: Calendar

    @State private var currentPage: Int = 1

    private var months: [Date] {
        [
            DateUtilities.monthByAdding(-1, to: displayedMonth, calendar: calendar),
            displayedMonth,
            DateUtilities.monthByAdding(1, to: displayedMonth, calendar: calendar)
        ]
    }

    var body: some View {
        #if os(iOS)
        TabView(selection: $currentPage) {
            ForEach(Array(months.enumerated()), id: \.offset) { index, month in
                MonthPageView(
                    displayedMonth: month,
                    selection: $selection,
                    calendar: calendar
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(minHeight: 260)
        .onChange(of: currentPage) { newPage in
            guard newPage != 1 else { return }
            let delta = newPage - 1
            displayedMonth = DateUtilities.monthByAdding(delta, to: displayedMonth, calendar: calendar)
            currentPage = 1
        }
        #else
        // macOS fallback: simple month page without paging gesture
        MonthPageView(
            displayedMonth: displayedMonth,
            selection: $selection,
            calendar: calendar
        )
        #endif
    }
}
