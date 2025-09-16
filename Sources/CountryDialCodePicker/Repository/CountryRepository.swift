
import Foundation

public actor CountryRepository {
    public static let shared = CountryRepository()

    private var countries: [Country] = []

    public init() {}

    public func load() async throws {
        if !countries.isEmpty { return }
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "countries", withExtension: "json") else {
            throw NSError(domain: "CountryDialCodePicker", code: 404, userInfo: [NSLocalizedDescriptionKey: "countries.json not found"])
        }
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode([Country].self, from: data)
        countries = decoded.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    public func allCountries() async throws -> [Country] {
        try await load()
        return countries
    }

    public func search(query: String) async throws -> [Country] {
        try await load()
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty { return countries }
        return countries.filter {
            $0.name.range(of: q, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
            $0.dialCode.contains(q) ||
            $0.id.range(of: q, options: .caseInsensitive) != nil
        }
    }

    public func country(forDialCode input: String) async throws -> Country? {
        try await load()
        let normalized = input.hasPrefix("+") ? input : "+" + input
        return countries
            .sorted { $0.dialCode.count > $1.dialCode.count }
            .first { normalized.hasPrefix($0.dialCode) }
    }

    public func country(forISOCode iso: String) async throws -> Country? {
        try await load()
        return countries.first { $0.id.caseInsensitiveCompare(iso) == .orderedSame }
    }

    public nonisolated func sectioned(countries: [Country]) -> [(key: String, items: [Country])] {
        let grouped = Dictionary(grouping: countries, by: { $0.sectionKey })
        return grouped.keys.sorted().map { key in
            (key, grouped[key]!.sorted { $0.name < $1.name })
        }
    }

    public var indexLetters: [String] {
        (try? countries.map { $0.sectionKey }.uniqued().sorted()) ?? []
    }
}

private extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var seen: Set<Element> = []
        return filter { seen.insert($0).inserted }
    }
}

