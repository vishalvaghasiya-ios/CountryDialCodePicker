import SwiftUI

enum FlagImage {
    /// Returns Image from bundled assets or nil if not found
    static func image(forISOCode iso: String) -> Image? {
        let name = iso.uppercased()
        if let uiImage = UIImage(named: name, in: .module, with: nil) {
            return Image(uiImage: uiImage)
        }
        return nil
    }

    /// Returns UIImage for UIKit usage
    static func uiImage(forISOCode iso: String) -> UIImage? {
        let name = iso.uppercased()
        return UIImage(named: name, in: .module, with: nil)
    }
}
