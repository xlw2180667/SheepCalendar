import Foundation

/// Selection state for the calendar.
///
/// Use as a `@Binding` — the host app owns the source of truth.
/// - `.single(nil)` means nothing is selected yet.
/// - `.multi(Set<Date>)` for multi-select; tap toggles membership.
/// - `.range(nil)` means no range started; first tap sets start, second sets end.
public enum SheepSelection: Equatable {
    case single(Date?)
    case multi(Set<Date>)
    case range(ClosedRange<Date>?)

    // MARK: - Convenience

    /// The currently selected single date, if in single mode.
    public var singleDate: Date? {
        if case .single(let d) = self { return d }
        return nil
    }

    /// The set of selected dates, if in multi mode.
    public var multiDates: Set<Date>? {
        if case .multi(let s) = self { return s }
        return nil
    }

    /// The selected range, if in range mode.
    public var dateRange: ClosedRange<Date>? {
        if case .range(let r) = self { return r }
        return nil
    }
}
