import SwiftUI

/// Default header showing the month/year title with back/forward chevrons.
struct HeaderView: View {
    @Environment(\.sheepTheme) private var theme
    let displayedMonth: Date
    let onBack: () -> Void
    let onForward: () -> Void

    private var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.semibold))
                    .foregroundColor(theme.selectionColor)
            }
            .accessibilityLabel("Previous month")

            Spacer()

            Text(title)
                .font(theme.headerFont)
                .foregroundColor(theme.headerTextColor)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            Button(action: onForward) {
                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundColor(theme.selectionColor)
            }
            .accessibilityLabel("Next month")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
