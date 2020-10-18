//
//  DetailViewController.swift
//  Milonchik
//
//  Created by Roey Biran on 14/07/2020.
//  Copyright © 2020 Roey Biran. All rights reserved.
//

import Cocoa
import WebKit

final class DetailViewController: NSViewController, StateResponding {

    @IBOutlet var detailView: DetailView!

    override func viewDidLoad() {
        //FIXME: white flash
        detailView.isHidden = true
    }

    func update(with state: ViewController.State) {
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

    private func loadHTML(with content: HTMLContent) {
        guard
            let htmlFile = Bundle.main.path(forResource: "DefinitionDetail", ofType: "html"),
            let htmlTemplate = try? String(contentsOfFile: htmlFile, encoding: .utf8)
        else {
            preconditionFailure("Definition detail HTML template file is missing or corrupt")
        }

        let htmlBody: String!
        switch content {
        case .placeholder(let message):
            htmlBody = "<p class=\"placeholder\">\(message)</p>"
        case .definition(let value):
            let partOfSpeech = value.partOfSpeech ?? ""
            let translations = value.translations.map({"<li>\($0)</li>"}).joined()
            let inflections = value.inflections.map({"<li>\($0.contents) | <span>\($0.kind)</span></li>"}).joined()
            let samples = value.samples.map({ "<li>\($0)</li>" }).joined()
            let synonyms = value.synonyms.map({ "<li>\($0)</li>" }).joined()
            let headers = makeHeaders(for: value.inputLanguage)
            let synonymsTitle = synonyms.isEmpty ? "" : headers.synonyms
            let inflectionsTitle = inflections.isEmpty ? "" : headers.inflections
            let samplesTitle = samples.isEmpty ? "" : headers.samples
            htmlBody = """
            <!-- word + part of speech -->
            <h1 dir="auto">\(value.inputWord)<span> \(partOfSpeech)</span></h1>
            <!-- translations -->
            <ul dir="auto">\(translations)</ul>
            <!-- inflections -->
            <h2 dir="auto">\(inflectionsTitle)</h2>
            <ul dir="auto">\(inflections)</ul>
            <!-- synonyms -->
            <h2 dir="auto">\(synonymsTitle)</h2>
            <p dir="auto">\(synonyms)</p>
            <!-- samples -->
            <h2 dir="auto">\(samplesTitle)</h2>
            <ul dir="auto">\(samples)</ul>
            """
        }
        detailView.loadHTMLString(htmlTemplate.replacingOccurrences(of: "$BODY", with: htmlBody), baseURL: nil)

        //FIXME: white flash
        if detailView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.detailView.isHidden = false
            }
        }
    }
}

// MARK: - bilingual titles
private extension DetailViewController {
    struct Headers {
        let synonyms: String
        let inflections: String
        let samples: String
    }

    func makeHeaders(for language: InputLanguage) -> Headers {
        switch language {
        case .eng:
            return Headers(synonyms: "מילים נרדפות", inflections: "נגזרים", samples: "דוגמאות")
        case .heb:
            return Headers(synonyms: "Synonyms", inflections: "Inflecions", samples: "Samples")
        }
    }
}

private extension DetailViewController {
    enum HTMLContent {
        case placeholder(String)
        case definition(Definition)
    }
}
