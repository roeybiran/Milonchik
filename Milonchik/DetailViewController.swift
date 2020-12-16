//
//  DetailViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 14/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa
import WebKit

final class DetailViewController: NSViewController {

    private enum HTMLContent {
        case placeholder(String)
        case definition(Definition)
    }

    private struct Headers {
        let synonyms: String
        let inflections: String
        let samples: String
    }

    lazy var htmlTemplate: String = {
        guard
            let htmlFile = Bundle.main.path(forResource: "DefinitionDetail", ofType: "html"),
            let htmlTemplate = try? String(contentsOfFile: htmlFile, encoding: .utf8)
        else {
            preconditionFailure("Definition detail HTML template file is missing or corrupt")
        }
        return htmlTemplate
    }()

    lazy var detailView: DetailView = {
        let detailView = DetailView()
        detailView.isHidden = true
        return detailView
    }()

    override func loadView() {
        view = detailView
    }

    private func loadHTML(with content: HTMLContent) {
        let htmlBody: String!
        switch content {
        case .placeholder(let message):
            htmlBody = "<p class=\"placeholder\">\(message)</p>"
        case .definition(let value):
            let partOfSpeech = value.partOfSpeech ?? ""
            let translations = value.translations.map({"<li>\($0)</li>"})
            let inflections = value.inflections.map({"<li>\($0.value)<span> | \($0.kind)</span></li>"})
            let samples = value.samples.map({ "<li>\($0)</li>" })
            let synonyms = value.synonyms.joined(separator: ", ")
            let headers = makeHeaders(for: value.translatedLanguage)
            let synonymsTitle = synonyms.isEmpty ? "" : headers.synonyms
            let inflectionsTitle = inflections.isEmpty ? "" : headers.inflections
            let samplesTitle = samples.isEmpty ? "" : headers.samples
            // 1) word + part of speech, 2) translations, 3) inflections, 4) synonyms, 5) samples
            htmlBody = """
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
        detailView.loadHTMLString(htmlTemplate.replacingOccurrences(of: "$BODY", with: htmlBody), baseURL: nil)

        //FIXME: white flash
        if detailView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.detailView.animator().isHidden = false
            }
        }
    }

    private func makeHeaders(for language: TranslatedLanguage) -> Headers {
        switch language {
        case .eng:
            return Headers(synonyms: "מילים נרדפות", inflections: "נגזרים", samples: "דוגמאות")
        case .heb:
            return Headers(synonyms: "Synonyms", inflections: "Inflecions", samples: "Samples")
        }
    }
}

extension DetailViewController: StateResponding {
    func update(with state: State) {
        switch state {
        case .noQuery:
            loadHTML(with: .placeholder("Look up a word by typing in the search field above."))
        case .noResults(let query):
            loadHTML(with: .placeholder("No definitions found for ”\(query)”."))
        case .definitionSelectionChanged(let definition):
            loadHTML(with: .definition(definition))
        default:
            break
        }
    }
}
