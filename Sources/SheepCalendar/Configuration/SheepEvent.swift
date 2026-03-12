import SwiftUI

/// A single event dot displayed under a day cell.
public struct SheepEvent: Identifiable, Equatable {
    public let id: UUID
    public let color: Color
    public let label: String?

    public init(color: Color = .blue, label: String? = nil) {
        self.id = UUID()
        self.color = color
        self.label = label
    }
}
