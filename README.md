# CountryDialCodePicker

## 📚 Table of Contents

- [✨ Features](#-features)  
- [🛠 Requirements](#-requirements)  
- [📦 Installation](#-installation)  
- [🚀 How to Use](#-how-to-use)  
- [⚠️ Notes](#-notes)  
- [📝 Version 1.0.0](#-version-100)  
- [👤 Author](#-author)  

## ✨ Features

`CountryDialCodePicker` is a simple and customizable SwiftUI component that allows users to select a country along with its dial code. It provides a searchable list of countries, an index bar for quick navigation, and supports various customization options to fit your app’s design and requirements.

**Note:** You can also add a **header icon** in `CountryDialCodePickerView` to enhance the UI. Here's a SwiftUI example showing how to add a leading icon next to the title in the header:

```swift
CountryDialCodePickerView(title: {
    HStack {
        Image(systemName: "globe")
            .foregroundColor(.blue)
        Text("Select Country")
            .font(.headline)
    }
}) { country in
    // handle selection
}
```

## 🛠 Requirements

- iOS 14.0 or later  
- Swift 5.3 or later  
- Xcode 12 or later  
- SwiftUI  

## 📦 Installation

You can add `CountryDialCodePicker` to your project using Swift Package Manager (SPM):

1. In Xcode, go to **File > Add Packages...**  
2. Enter the repository URL of `CountryDialCodePicker`: `https://github.com/vishalvaghasiya-ios/CountryDialCodePicker.git`  
3. Choose the version or branch you want to use.  
4. Add the package to your project.  

Once added, you can import the package in your Swift files:

```swift
import CountryDialCodePicker
```

## 🚀 How to Use

### Basic Usage Example

Here’s a simple example to present the country dial code picker and handle the selected country:

```swift
import SwiftUI
import CountryDialCodePicker

struct ContentView: View {
    @State private var selectedCountry: CountryDialCode? = nil
    @State private var isPickerPresented = false

    var body: some View {
        VStack {
            if let country = selectedCountry {
                Text("Selected: \(country.name) (\(country.dialCode))")
            } else {
                Text("No country selected")
            }

            Button("Select Country") {
                isPickerPresented = true
            }
            .sheet(isPresented: $isPickerPresented) {
                CountryDialCodePickerView { country in
                    selectedCountry = country
                    isPickerPresented = false
                }
            }
        }
        .padding()
    }
}
```

### UIKit Usage Example

You can use `CountryDialCodePicker` in UIKit by presenting it as a modal view controller. Below are beginner-friendly examples for both delegate-based and closure-based selection handling.

#### Delegate-Based Example

First, make your view controller conform to the `CountryDialCodePickerDelegate` protocol:

```swift
import UIKit
import CountryDialCodePicker

class MyViewController: UIViewController, CountryDialCodePickerDelegate {
    var selectedCountry: CountryDialCode?

    @IBAction func showPicker(_ sender: Any) {
        let pickerVC = CountryDialCodePickerViewController()
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .formSheet // or .pageSheet, .fullScreen, etc.
        present(pickerVC, animated: true, completion: nil)
    }

    // MARK: - CountryDialCodePickerDelegate
    func countryDialCodePicker(_ picker: CountryDialCodePickerViewController, didSelect country: CountryDialCode) {
        selectedCountry = country
        dismiss(animated: true, completion: nil)
        // Update your UI here with selectedCountry
    }
}
```

#### Closure-Based Example

Alternatively, you can use a closure for selection:

```swift
import UIKit
import CountryDialCodePicker

class MyViewController: UIViewController {
    var selectedCountry: CountryDialCode?

    @IBAction func showPicker(_ sender: Any) {
        let pickerVC = CountryDialCodePickerViewController { [weak self] country in
            self?.selectedCountry = country
            self?.dismiss(animated: true, completion: nil)
            // Update your UI here with selectedCountry
        }
        pickerVC.modalPresentationStyle = .formSheet
        present(pickerVC, animated: true, completion: nil)
    }
}
```

**Note:** Make sure to import `CountryDialCodePicker` and present the picker modally from your view controller. You can customize the presentation style as needed.

### Customizations

`CountryDialCodePicker` offers several ways to customize its appearance and behavior:

#### Title

You can set a custom title for the picker:

```swift
CountryDialCodePickerView(title: "Choose your country") { country in
    // handle selection
}
```

#### Index Bar

The index bar allows quick navigation through the country list. You can enable or disable it:

```swift
CountryDialCodePickerView(showIndexBar: false) { country in
    // handle selection
}
```

#### Search Bar

The search bar is enabled by default, allowing users to filter countries by name or dial code. You can disable it if needed:

```swift
CountryDialCodePickerView(showSearchBar: false) { country in
    // handle selection
}
```

#### Appearance

You can customize colors, fonts, and other UI elements by modifying the view or extending it according to your needs.

## ⚠️ Notes

### Keyboard Handling Notes

When the search bar is active, the keyboard appears automatically. The picker view is designed to handle keyboard appearance gracefully, adjusting the list height to prevent it from being obscured.

If you embed the picker in a custom view, ensure you handle keyboard dismissal appropriately, for example by adding a tap gesture to dismiss the keyboard when tapping outside the search field.

### Selection Handling

The picker returns the selected country via a closure. The `CountryDialCode` model contains relevant information such as:

- `name`: The country name (e.g., "United States")  
- `dialCode`: The dial code (e.g., "+1")  
- `code`: The ISO country code (e.g., "US")  

Use this information to update your UI or perform actions based on the user's selection.

## 📝 Version 1.0.0

Feel free to explore and customize `CountryDialCodePicker` to best fit your app’s needs. Contributions and feedback are welcome!

## 👤 Author

Vishal Vaghasiya  
GitHub: [vishalvaghasiya-ios](https://github.com/vishalvaghasiya-ios)
