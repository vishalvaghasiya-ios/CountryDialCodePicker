import SwiftUI

struct CountryPickerView: View {
    @State private var query: String = ""
    @State private var items: [Country] = []
    @State private var sections: [(key: String, items: [Country])] = []
    @Environment(\.dismiss) private var dismiss

    let config: CountryPickerConfig
    let onSelect: (CountrySelection) -> Void
    let onCancel: (() -> Void)?

    @State private var indexLetters: [String] = []
    @State private var keyboardHeight: CGFloat = 0

    private var bottomSafeAreaInset: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let keyWindow = windowScene?.windows.first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        NavigationView {
            Group {
                if config.showSearch {
                    content
                        .navigationTitle(config.title)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    onCancel?()
                                    dismiss()
                                }
                            }
                        }
                        .searchable(
                            text: $query,
                            prompt: "Search by name or code"
                        )
                        .textInputAutocapitalization(TextInputAutocapitalization.never)
                        .autocorrectionDisabled()
                        .onChange(of: query) { _ in Task { await refresh() } }
                } else {
                    content
                        .navigationTitle(config.title)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    onCancel?()
                                    dismiss()
                                }
                            }
                        }
                }
            }
        }
        .navigationViewStyle(.stack)
        .task { await refresh() }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { note in
            guard let info = note.userInfo,
                  let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
            keyboardHeight = frame.height
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
    }

    @ViewBuilder
    private var content: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                List {
                    ForEach(sections.indices, id: \.self) { index in
                        let section = sections[index]
                        Section(header: Text(section.key).id(section.key)) {
                            ForEach(section.items) { country in
                                Button {
                                    onSelect(.init(country: country))
                                    dismiss()
                                } label: {
                                    row(for: country)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .padding(.bottom, max(0, keyboardHeight - bottomSafeAreaInset))

                if config.showIndexBar, !indexLetters.isEmpty {
                    IndexBar(letters: indexLetters) { letter in
                        withAnimation {
                            proxy.scrollTo(letter, anchor: .top)
                        }
                    }
                    .padding(.trailing, 6)
                    .padding(.bottom, max(0, keyboardHeight - bottomSafeAreaInset))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: keyboardHeight)
        }
    }

    @ViewBuilder
    private func row(for country: Country) -> some View {
        HStack(spacing: 12) {
            switch config.displayMode {
            case .country:
                Text(country.name)

            case .countryWithFlag:
                if let image = country.flagImage {
                    image
                        .resizable()
                        .frame(width: 24, height: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                } else {
                    Text(Flags.flagEmoji(forISOCode: country.id))
                }
                Text(country.name)

            case .countryFlagAndCode:
                if let image = country.flagImage {
                    image
                        .resizable()
                        .frame(width: 24, height: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                } else {
                    Text(Flags.flagEmoji(forISOCode: country.id))
                }
                Text(country.name)
                Spacer()
                Text(country.dialCode)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .contentShape(Rectangle())
    }

    private func refresh() async {
        let repo = CountryRepository.shared
        do {
            let list: [Country]
            if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                list = try await repo.allCountries()
            } else {
                list = try await repo.search(query: query)
            }
            let sectionsList = repo.sectioned(countries: list)
            await MainActor.run {
                items = list
                sections = sectionsList
                indexLetters = sectionsList.map(\.key)
            }
        } catch {
            await MainActor.run {
                items = []
                sections = []
                indexLetters = []
            }
        }
    }
}
