import Foundation

public enum DisplayMode: Sendable {
    /// Only country name
    case country
    /// Country + flag
    case countryWithFlag
    /// Country + flag + dial code
    case countryFlagAndCode
}
