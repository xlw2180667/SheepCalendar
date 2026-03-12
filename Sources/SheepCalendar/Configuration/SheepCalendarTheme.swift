import SwiftUI

/// Selection shape style for day cells.
public enum SelectionShape: Hashable, Sendable {
    case circle
    case roundedRect(cornerRadius: CGFloat = 8)
    case capsule
}

/// All visual tokens for the calendar appearance.
///
/// Create a custom theme and pass it via `.sheepCalendarTheme(...)`.
public struct SheepCalendarTheme: Equatable {
    // MARK: - Colors
    public var selectionColor: Color
    public var todayColor: Color
    public var defaultTextColor: Color
    public var placeholderTextColor: Color
    public var weekendTextColor: Color
    public var rangeMiddleColor: Color
    public var headerTextColor: Color
    public var weekdayLabelColor: Color

    // MARK: - Fonts
    public var dayFont: Font
    public var weekdayFont: Font
    public var headerFont: Font

    // MARK: - Sizing
    public var dayCellHeight: CGFloat
    public var eventDotSize: CGFloat
    public var rowSpacing: CGFloat

    // MARK: - Shape
    public var selectionShape: SelectionShape

    public init(
        selectionColor: Color = .blue,
        todayColor: Color = .orange,
        defaultTextColor: Color = .primary,
        placeholderTextColor: Color = Color.gray.opacity(0.5),
        weekendTextColor: Color = .primary,
        rangeMiddleColor: Color = Color.blue.opacity(0.15),
        headerTextColor: Color = .primary,
        weekdayLabelColor: Color = .secondary,
        dayFont: Font = .system(size: 15, weight: .medium),
        weekdayFont: Font = .system(size: 13, weight: .medium),
        headerFont: Font = .system(size: 17, weight: .semibold),
        dayCellHeight: CGFloat = 44,
        eventDotSize: CGFloat = 6,
        rowSpacing: CGFloat = 4,
        selectionShape: SelectionShape = .circle
    ) {
        self.selectionColor = selectionColor
        self.todayColor = todayColor
        self.defaultTextColor = defaultTextColor
        self.placeholderTextColor = placeholderTextColor
        self.weekendTextColor = weekendTextColor
        self.rangeMiddleColor = rangeMiddleColor
        self.headerTextColor = headerTextColor
        self.weekdayLabelColor = weekdayLabelColor
        self.dayFont = dayFont
        self.weekdayFont = weekdayFont
        self.headerFont = headerFont
        self.dayCellHeight = dayCellHeight
        self.eventDotSize = eventDotSize
        self.rowSpacing = rowSpacing
        self.selectionShape = selectionShape
    }

    /// The built-in default theme.
    public static let `default` = SheepCalendarTheme()
}
