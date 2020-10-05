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

    @IBOutlet var placeHolderLabel: NSTextField!
    @IBOutlet var webView: MLNWebView!
    // FIXME: bug - white flash
    @IBOutlet var customView: NSView!

    var htmlTemplate: String!

    enum DisplayMode {
        case noQuery
        case noResult(query: String)
        case result(_: Definition)
    }

    override func awakeFromNib() {
        guard
            let htmlFile = Bundle.main.path(forResource: "DefinitionDetail", ofType: "html"),
            let htmlTemplate = try? String(contentsOfFile: htmlFile, encoding: .utf8)
        else {
            preconditionFailure("Definition detail HTML template file is missing or corrupt")
        }

        self.htmlTemplate = htmlTemplate

        // FIXME: bug - white flash
        customView.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
        loadHTML(arguments: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.customView.removeFromSuperview()
        }

    }

    func update(with state: ViewController.State) {
        switch state {
        case .noQuery:
            placeHolderLabel.isHidden = false
            webView.isHidden = true
            placeHolderLabel.placeholderString = "Look up a word by typing in search field above."
        case .noResults(let query):
            placeHolderLabel.isHidden = false
            webView.isHidden = true
            placeHolderLabel.placeholderString = "No definitions found for ”\(query)”."
        case .definitionSelectionChanged(let definition):
            placeHolderLabel.isHidden = true
            webView.isHidden = false
            let partOfSpeech = definition.partOfSpeech ?? ""
            let translations = (definition.translations.count > 1 ?
                                definition.translations.map({"<li>\($0)</li>"}) : definition.translations).joined()
            let inflections = definition.inflections.map({ inflection in
                let listItem = "\(inflection.contents) | <span class=\"inf-kind\">\(inflection.kind)</span>"
                return definition.inflections.count > 1 ? "<li>\(listItem)</li>" : listItem
            }).joined()

            let synonyms = definition.synonyms.joined(separator: ", ")
            let samples = definition.samples.map({ "<li>\($0)</li>" }).joined()

            let headers = makeHeaders(for: definition.inputLanguage)
            let synonymsTitle = synonyms.isEmpty ? "" : headers.synonyms
            let inflectionsTitle = inflections.isEmpty ? "" : headers.inflections
            let samplesTitle = samples.isEmpty ? "" : headers.samples

            loadHTML(arguments: [
                definition.inputWord, partOfSpeech, translations, inflectionsTitle, inflections,
                synonymsTitle, synonyms, samplesTitle, samples
            ])
        default:
            break
        }
    }

    private func loadHTML(arguments: [String]?) {
        let modifiedHTML: String
        if let arguments = arguments {
            modifiedHTML = String(format: htmlTemplate, arguments: arguments)
        } else {
            modifiedHTML = htmlTemplate.replacingOccurrences(of: "%@", with: "")
        }
        webView.loadHTMLString(modifiedHTML, baseURL: nil)
    }
}

// MARK: - bilingual titles
extension DetailViewController {
    private struct Headers {
        let synonyms: String
        let inflections: String
        let samples: String
    }

    private func makeHeaders(for language: InputLanguage) -> Headers {
        switch language {
        case .eng:
            return Headers(synonyms: "מילים נרדפות", inflections: "נגזרים", samples: "דוגמאות")
        case .heb:
            return Headers(synonyms: "Synonyms", inflections: "Inflecions", samples: "Samples")
        }
    }
}
