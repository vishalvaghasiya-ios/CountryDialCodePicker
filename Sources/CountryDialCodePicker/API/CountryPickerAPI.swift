import Foundation
import SwiftUI

public protocol CountryPickerDelegate: AnyObject {
    func countryPicker(didSelect selection: CountrySelection)
    func countryPickerDidCancel()
}

public struct CountryPickerConfig: Sendable {
    public var displayMode: DisplayMode
    public var showSearch: Bool
    public var showIndexBar: Bool
    public var title: String

    public init(
        displayMode: DisplayMode = .countryFlagAndCode,
        showSearch: Bool = true,
        showIndexBar: Bool = true,
        title: String = "Select Country"
    ) {
        self.displayMode = displayMode
        self.showSearch = showSearch
        self.showIndexBar = showIndexBar
        self.title = title
    }
}

/// Closure-based entry point for SwiftUI or UIKit wrappers
public struct CountryPicker {
    @MainActor public static func view(
        config: CountryPickerConfig = .init(),
        onSelect: @escaping (CountrySelection) -> Void,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        CountryPickerView(config: config, onSelect: onSelect, onCancel: onCancel, selectedCountry: nil)
    }
}
