/// Represents the result of a database fetch operation.
struct DatabaseResponse {
    let exactMatches: [Definition]
    let partialMatches: [Definition]
    let query: String
    let sanitizedQuery: String
    let count: Int
    let allMatches: [Definition]

    init(matches: [Definition], query: String, sanitizedQuery: String) {
        allMatches = matches
        self.query = query
        self.sanitizedQuery = sanitizedQuery
        count = matches.count
        exactMatches = matches.filter { $0.translatedWordSanitized == sanitizedQuery }
        partialMatches = matches.filter { $0.translatedWordSanitized != sanitizedQuery }
    }
}
