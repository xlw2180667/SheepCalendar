import SwiftUI

/// Vertical scrolling container with LazyVStack for on-demand month generation.
struct VerticalScrollContainerView: View {
    @Binding var displayedMonth: Date
    @Binding var selection: SheepSelection
    let calendar: Calendar

    @State private var visibleMonths: [Date] = []

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(monthRange, id: \.self) { month in
                    VStack(spacing: 4) {
                        Text(monthTitle(month))
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        MonthPageView(
                            displayedMonth: month,
                            selection: $selection,
                            calendar: calendar
                        )
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    private var monthRange: [Date] {
        // Show 3 months before and after current
        (-3...3).map { offset in
            DateUtilities.monthByAdding(offset, to: displayedMonth, calendar: calendar)
        }
    }

    private func monthTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
