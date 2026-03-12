import SwiftUI

// MARK: - Theme

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = SheepCalendarTheme.default
}

// MARK: - Scope

private struct ScopeKey: EnvironmentKey {
    static let defaultValue: SheepScope = .month
}

// MARK: - Scroll Direction

private struct ScrollDirectionKey: EnvironmentKey {
    static let defaultValue: ScrollDirection = .horizontal
}

// MARK: - First Weekday

private struct FirstWeekdayKey: EnvironmentKey {
    static let defaultValue: Weekday = .sunday
}

// MARK: - Date Range

private struct MinDateKey: EnvironmentKey {
    static let defaultValue: Date? = nil
}

private struct MaxDateKey: EnvironmentKey {
    static let defaultValue: Date? = nil
}

// MARK: - Placeholder Mode

private struct PlaceholderModeKey: EnvironmentKey {
    static let defaultValue: PlaceholderMode = .none
}

// MARK: - Events Provider

private struct EventsProviderKey: EnvironmentKey {
    static let defaultValue: ((Date) -> [SheepEvent])? = nil
}

// MARK: - Custom Day Cell

private struct DayCellBuilderKey: EnvironmentKey {
    static let defaultValue: ((Date, DayState) -> AnyView)? = nil
}

// MARK: - Custom Header

private struct HeaderBuilderKey: EnvironmentKey {
    static let defaultValue: ((Date, @escaping () -> Void, @escaping () -> Void) -> AnyView)? = nil
}

// MARK: - Callbacks

private struct DateSelectCallbackKey: EnvironmentKey {
    static let defaultValue: ((Date) -> Void)? = nil
}

private struct PageChangeCallbackKey: EnvironmentKey {
    static let defaultValue: ((Date) -> Void)? = nil
}

// MARK: - EnvironmentValues Extension

extension EnvironmentValues {
    var sheepTheme: SheepCalendarTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }

    var sheepScope: SheepScope {
        get { self[ScopeKey.self] }
        set { self[ScopeKey.self] = newValue }
    }

    var sheepScrollDirection: ScrollDirection {
        get { self[ScrollDirectionKey.self] }
        set { self[ScrollDirectionKey.self] = newValue }
    }

    var sheepFirstWeekday: Weekday {
        get { self[FirstWeekdayKey.self] }
        set { self[FirstWeekdayKey.self] = newValue }
    }

    var sheepMinDate: Date? {
        get { self[MinDateKey.self] }
        set { self[MinDateKey.self] = newValue }
    }

    var sheepMaxDate: Date? {
        get { self[MaxDateKey.self] }
        set { self[MaxDateKey.self] = newValue }
    }

    var sheepPlaceholderMode: PlaceholderMode {
        get { self[PlaceholderModeKey.self] }
        set { self[PlaceholderModeKey.self] = newValue }
    }

    var sheepEventsProvider: ((Date) -> [SheepEvent])? {
        get { self[EventsProviderKey.self] }
        set { self[EventsProviderKey.self] = newValue }
    }

    var sheepDayCellBuilder: ((Date, DayState) -> AnyView)? {
        get { self[DayCellBuilderKey.self] }
        set { self[DayCellBuilderKey.self] = newValue }
    }

    var sheepHeaderBuilder: ((Date, @escaping () -> Void, @escaping () -> Void) -> AnyView)? {
        get { self[HeaderBuilderKey.self] }
        set { self[HeaderBuilderKey.self] = newValue }
    }

    var sheepDateSelectCallback: ((Date) -> Void)? {
        get { self[DateSelectCallbackKey.self] }
        set { self[DateSelectCallbackKey.self] = newValue }
    }

    var sheepPageChangeCallback: ((Date) -> Void)? {
        get { self[PageChangeCallbackKey.self] }
        set { self[PageChangeCallbackKey.self] = newValue }
    }
}
