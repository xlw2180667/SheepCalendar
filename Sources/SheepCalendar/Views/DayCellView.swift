import SwiftUI

/// Default day cell rendering: number, selection circle, today highlight, event dots.
struct DayCellView: View {
    @Environment(\.sheepTheme) private var theme
    let state: DayState
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                ZStack {
                    // Range middle fill
                    if state.isRangeMiddle {
                        Rectangle()
                            .fill(theme.rangeMiddleColor)
                            .frame(height: 32)
                    }

                    // Selection background
                    if state.isSelected || state.isRangeStart || state.isRangeEnd {
                        selectionBackground(filled: true)
                    } else if state.isToday {
                        selectionBackground(filled: false)
                    }

                    Text("\(state.dayNumber)")
                        .font(theme.dayFont)
                        .foregroundColor(textColor)
                }
                .frame(height: 32)

                // Event dots
                if !state.events.isEmpty {
                    HStack(spacing: 2) {
                        ForEach(state.events.prefix(3)) { event in
                            Circle()
                                .fill(event.color)
                                .frame(width: theme.eventDotSize, height: theme.eventDotSize)
                        }
                    }
                } else {
                    Spacer()
                        .frame(height: theme.eventDotSize)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .frame(height: theme.dayCellHeight)
        .opacity(state.isDisabled ? 0.3 : 1.0)
        .disabled(state.isDisabled)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(state.isSelected ? .isSelected : [])
        .accessibilityHint(state.isDisabled ? "Disabled" : "Double tap to select")
    }

    private var textColor: Color {
        if state.isSelected || state.isRangeStart || state.isRangeEnd {
            return .white
        }
        if state.isPlaceholder || !state.belongsToDisplayedMonth {
            return theme.placeholderTextColor
        }
        if state.isToday {
            return theme.todayColor
        }
        if state.isWeekend {
            return theme.weekendTextColor
        }
        return theme.defaultTextColor
    }

    private var accessibilityLabel: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        var label = formatter.string(from: state.date)
        if state.isToday { label += ", today" }
        if state.isSelected { label += ", selected" }
        if state.isRangeStart { label += ", range start" }
        if state.isRangeEnd { label += ", range end" }
        if state.isRangeMiddle { label += ", in range" }
        if !state.events.isEmpty {
            let eventLabels = state.events.compactMap(\.label)
            if eventLabels.isEmpty {
                label += ", \(state.events.count) event\(state.events.count == 1 ? "" : "s")"
            } else {
                label += ", " + eventLabels.joined(separator: ", ")
            }
        }
        return label
    }

    @ViewBuilder
    private func selectionBackground(filled: Bool) -> some View {
        switch theme.selectionShape {
        case .circle:
            if filled {
                Circle().fill(theme.selectionColor).frame(width: 32, height: 32)
            } else {
                Circle().stroke(theme.todayColor, lineWidth: 1.5).frame(width: 32, height: 32)
            }
        case .roundedRect(let radius):
            if filled {
                RoundedRectangle(cornerRadius: radius).fill(theme.selectionColor).frame(width: 32, height: 32)
            } else {
                RoundedRectangle(cornerRadius: radius).stroke(theme.todayColor, lineWidth: 1.5).frame(width: 32, height: 32)
            }
        case .capsule:
            if filled {
                Capsule().fill(theme.selectionColor).frame(width: 32, height: 32)
            } else {
                Capsule().stroke(theme.todayColor, lineWidth: 1.5).frame(width: 32, height: 32)
            }
        }
    }
}
