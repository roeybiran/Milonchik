import Cocoa
import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class MorfixFetcher {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var session: URLSessionProtocol = URLSession.shared

    func fetch(query: String, onCompletion handler: @escaping (Result<[MorfixDefinition], Error>) -> Void) {
        // https://github.com/outofink/morfix-lite/
        // https://stackoverflow.com/questions/31937686/how-to-make-http-post-request-with-json-body-in-swift
        // https://stackoverflow.com/questions/41997641/how-to-make-nsurlsession-post-request-in-swift

        var components = URLComponents()
        components.scheme = "http"
        components.host = "services.morfix.com"
        components.path = "/translationhebrew/TranslationService/GetTranslation/"

        guard
            let body = try? encoder.encode(["Query": query]),
            let url = components.url
        else {
            assertionFailure("Failed prepare Morfix URL request")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, _, error in
            switch (data, error) {
            case let (data?, _):
                do {
                    let definitions = try self.decoder.decode(MorfixResult.self, from: data)
                    handler(.success(definitions.words))
                } catch {
                    handler(.failure(error))
                }
            case let (_, error?):
                handler(.failure(error))
            default:
                handler(.failure(GenericError.error(message: "Unknown error")))
            }
        }
        task.resume()
    }
}

struct MorfixResult: Decodable {
    let words: [MorfixDefinition]

    enum CodingKeys: String, CodingKey {
        case words = "Words"
    }
}

struct MorfixInflection: Decodable {
    let kind: String
    let value: String
    enum CodingKeys: String, CodingKey {
        case kind = "Title"
        case value = "Text"
    }
}

struct MorfixDefinition: Decodable {
    let id: Int
    let translation: String
    let partOfSpeech: String
    let inflections: [MorfixInflection]
    let samples: [String]
    let synonyms: [String]
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case translation = "OutputLanguageMeaningsString"
        case partOfSpeech = "PartOfSpeech"
        case inflections = "Inflections"
        case samples = "SampleSentences"
        case synonyms = "SynonymsList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = Int(try values.decode(String.self, forKey: .id)) ?? 0
        translation = try values.decode(String.self, forKey: .translation)
        partOfSpeech = try values.decode(String.self, forKey: .partOfSpeech)
        inflections = try values.decode([MorfixInflection].self, forKey: .inflections)
        samples = try values.decode([String].self, forKey: .samples)
        synonyms = try values.decode([String].self, forKey: .synonyms)
    }
}

struct MorfixTranslation: Codable {
    let displayText: String
    let translation: String
    enum CodingKeys: String, CodingKey {
        case displayText = "DisplayText"
        case translation = "Translation"
    }
}
