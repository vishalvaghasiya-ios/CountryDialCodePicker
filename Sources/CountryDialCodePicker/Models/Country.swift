import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
import UIKit
import SwiftUICore

public struct Country: Identifiable, Hashable, Codable, Sendable {
    public let id: String        // ISO code (also used as the flag image name)
    public let name: String
    public let dialCode: String

    public init(id: String, name: String, dialCode: String) {
        self.id = id
        self.name = name
        self.dialCode = dialCode
    }

#if canImport(SwiftUI)
    public var flagImage: Image? {
        FlagImage.image(forISOCode: id)
    }
#endif

    public var flagUIImage: UIImage? {
        FlagImage.uiImage(forISOCode: id)
    }

    public var sectionKey: String {
        String(name.uppercased().prefix(1))
    }
}

public struct CountrySelection: Equatable, Sendable {
    public let country: Country
    public var name: String { country.name }
    public var isoCode: String { country.id }
    public var dialCode: String { country.dialCode }

#if canImport(SwiftUI)
    public var flag: Image? { country.flagImage }
#else
    public var flag: UIImage? { country.flagUIImage }
#endif

    public init(country: Country) { self.country = country }
}
