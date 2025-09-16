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

    var body: some View {
        NavigationView {
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
                .if(config.showSearch) { view in
                    view
                        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by name or code")
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onChange(of: query) { _ in Task { await refresh() } }
                }
        }
        .navigationViewStyle(.stack)
        .task { await refresh() }
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

                if config.showIndexBar, !indexLetters.isEmpty {
                    IndexBar(letters: indexLetters) { letter in
                        withAnimation {
                            proxy.scrollTo(letter, anchor: .top)
                        }
                    }
                    .padding(.trailing, 6)
                }
            }
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
