//

struct HTMLFormatter {

    enum Kind {
        case noQuery
        case noResults(for: String)
        case definition(_: Definition)
    }

    private struct Subtitles {
        let synonyms: String
        let inflections: String
        let samples: String
    }

    let baseTemplate: String

    init(baseTemplate: String) {
        self.baseTemplate = baseTemplate
    }

    func markup(for kind: Kind) -> Markup {
        let body: String
        switch kind {
        case .noQuery:
            body = Constants.noQueryPlaceholder.placeholderWrapped()
        case .noResults(let query):
            body = "No definitions found for ”\(query)”.".placeholderWrapped()
        case .definition(let value):
            let partOfSpeech = value.partOfSpeech ?? ""
            let translations = value.translations.map({"<li>\($0)</li>"})
            let inflections = value.inflections.map({"<li>\($0.value)<span> | \($0.kind)</span></li>"})
            let samples = value.samples.map({ "<li>\($0)</li>" })
            let synonyms = value.synonyms.joined(separator: ", ")
            let headers = makeSubtitles(for: value.translatedLanguage)
            let synonymsTitle = synonyms.isEmpty ? "" : headers.synonyms
            let inflectionsTitle = inflections.isEmpty ? "" : headers.inflections
            let samplesTitle = samples.isEmpty ? "" : headers.samples
            body =
                """
                <h1 dir="auto">\(value.translatedWord)<span> \(partOfSpeech)</span></h1>
                <ul dir="auto" \(translations.count == 1 ? "class=\"singular\"" : "")>\(translations.joined())</ul>
                <h2 dir="auto" \(inflections.isEmpty ? "class=\"hidden\"" : "")>\(inflectionsTitle)</h2>
                <ul dir="auto" \(inflections.count == 1 ? "class=\"singular\"" : "")>\(inflections.joined())</ul>
                <h2 dir="auto" \(synonyms.isEmpty ? "class=\"hidden\"" : "")>\(synonymsTitle)</h2>
                <p dir="auto">\(synonyms)</p>
                <h2 dir="auto" \(samples.isEmpty ? "class=\"hidden\"" : "")>\(samplesTitle)</h2>
                <ul dir="auto" \(samples.count == 1 ? "class=\"singular\"" : "")>\(samples.joined())</ul>
                """
        }
        return baseTemplate.replacingOccurrences(of: "$BODY", with: body)
    }

    private func makeSubtitles(for language: TranslatedLanguage) -> Subtitles {
        switch language {
        case .eng:
            return Subtitles(synonyms: "מילים נרדפות", inflections: "נגזרים", samples: "דוגמאות")
        case .heb:
            return Subtitles(synonyms: "Synonyms", inflections: "Inflecions", samples: "Samples")
        }
    }
}

private extension String {
    func placeholderWrapped() -> Self {
        "<p class=\"placeholder\">\(self)</p>"
    }
}
