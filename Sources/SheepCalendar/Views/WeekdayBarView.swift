import SwiftUI

/// Displays the weekday labels row (e.g., S M T W T F S).
struct WeekdayBarView: View {
    @Environment(\.sheepTheme) private var theme
    @Environment(\.sheepFirstWeekday) private var firstWeekday

    var body: some View {
        let symbols = DateUtilities.orderedWeekdaySymbols(firstWeekday: firstWeekday.rawValue)
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(theme.weekdayFont)
                    .foregroundColor(theme.weekdayLabelColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 4)
    }
}
