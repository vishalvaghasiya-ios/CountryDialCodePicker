import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
import UIKit

enum Flags {
    static func flagEmoji(forISOCode isoCode: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in isoCode.uppercased().unicodeScalars {
            guard let scalar = UnicodeScalar(base + v.value) else { continue }
            s.unicodeScalars.append(scalar)
        }
        return s
    }

#if canImport(SwiftUI)
    static func image(forISOCode isoCode: String) -> Image? {
        let name = isoCode.uppercased()
        if let uiImage = UIImage(named: name, in: .module, with: nil) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
#endif

    static func uiImage(forISOCode isoCode: String) -> UIImage? {
        let name = isoCode.uppercased()
        return UIImage(named: name, in: .module, with: nil)
    }
}
