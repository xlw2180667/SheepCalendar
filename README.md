# SheepCalendar

A full-featured, pure SwiftUI calendar library.

**iOS 16+ / macOS 13+**

## Features

- **Month & Week scope** with animated toggle
- **Single, multi, and range** date selection
- **Horizontal paging** (iOS) and **vertical scrolling**
- **Customizable theme** — colors, fonts, sizing, selection shape
- **Custom day cells** and **custom headers** via `@ViewBuilder` closures
- **Event dots** with color and accessibility labels
- **Configurable first weekday** (Sunday, Monday, etc.)
- **Placeholder modes** — none, fill head/tail, fixed 6 rows
- **Min/max date** constraints
- **VoiceOver** accessible
- **Zero dependencies** — pure Swift Package

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/xlw2180667/SheepCalendar.git", from: "0.1.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the repository URL.

## Quick Start

```swift
import SheepCalendar

struct ContentView: View {
    @State private var month = Date()
    @State private var selection: SheepSelection = .single(nil)

    var body: some View {
        SheepCalendarView(displayedMonth: $month, selection: $selection)
    }
}
```

That's it — 3 lines for a working calendar.

## Full-Featured Example

```swift
SheepCalendarView(displayedMonth: $month, selection: $selection)
    .sheepCalendarScope(.month)
    .sheepCalendarScrollDirection(.horizontal)
    .sheepCalendarFirstWeekday(.monday)
    .sheepCalendarDateRange(min: startDate, max: endDate)
    .sheepCalendarPlaceholder(.fillSixRows)
    .sheepCalendarTheme(SheepCalendarTheme(
        selectionColor: .blue,
        todayColor: .orange,
        dayFont: .system(size: 15, weight: .medium)
    ))
    .sheepCalendarEvents { date in
        myEvents[date] ?? []
    }
    .sheepCalendarDayCell { date, state in
        CustomDayView(state: state)
    }
    .sheepCalendarHeader { date, back, forward in
        CustomHeader(date: date, onBack: back, onForward: forward)
    }
    .onSheepDateSelect { date in
        print("Selected: \(date)")
    }
    .onSheepPageChange { month in
        loadEvents(for: month)
    }
```

## Selection Modes

```swift
// Single selection
@State var selection: SheepSelection = .single(nil)

// Multi selection — tap toggles
@State var selection: SheepSelection = .multi(Set())

// Range selection — first tap = start, second tap = end
@State var selection: SheepSelection = .range(nil)
```

## Theme Customization

```swift
let theme = SheepCalendarTheme(
    selectionColor: .blue,
    todayColor: .orange,
    defaultTextColor: .primary,
    placeholderTextColor: .gray.opacity(0.5),
    weekendTextColor: .red,
    rangeMiddleColor: .blue.opacity(0.15),
    dayFont: .system(size: 15, weight: .medium),
    weekdayFont: .system(size: 13, weight: .medium),
    headerFont: .system(size: 17, weight: .semibold),
    dayCellHeight: 44,
    eventDotSize: 6,
    rowSpacing: 4,
    selectionShape: .circle  // .circle / .roundedRect(cornerRadius:) / .capsule
)
```

## API Reference

| Modifier | Description |
|---|---|
| `.sheepCalendarScope(_:)` | `.month` or `.week` |
| `.sheepCalendarScrollDirection(_:)` | `.horizontal` or `.vertical` |
| `.sheepCalendarFirstWeekday(_:)` | `.sunday` through `.saturday` |
| `.sheepCalendarDateRange(min:max:)` | Constrain selectable dates |
| `.sheepCalendarPlaceholder(_:)` | `.none` / `.fillHeadTail` / `.fillSixRows` |
| `.sheepCalendarTheme(_:)` | Apply a custom `SheepCalendarTheme` |
| `.sheepCalendarEvents(_:)` | Provide `[SheepEvent]` per date |
| `.sheepCalendarDayCell(_:)` | Custom day cell view builder |
| `.sheepCalendarHeader(_:)` | Custom header view builder |
| `.onSheepDateSelect(_:)` | Date tap callback |
| `.onSheepPageChange(_:)` | Month/week navigation callback |

## License

MIT
