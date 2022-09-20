//
//  GibberishLoader.swift
//  Gibberish
//
//  Created by Gero Herkenrath on 20.02.21.
//

import Foundation

enum GibberishLoadingResponse {
    case clientError
    case networkError(Error)
    case badResponse
    case parsingError(Error)
    case goodResponse(GibberishJsonModel)
}

protocol GibberishLoading {
    func download(onCompletion: @escaping (GibberishLoadingResponse) -> Void)
}

struct GibberishLoader: GibberishLoading {

    private static let delayKey = "responseDelay"
    private static let minWordKey = "minWordCount"
    private static let maxWordKey = "maxWordCount"

    var urlString = "https://codingfromhell.net/swiftDemo/listElement"

    func download(onCompletion: @escaping (GibberishLoadingResponse) -> Void) {
        guard let url = constructUrl() else {
            onCompletion(.clientError)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { onCompletion(.networkError(error)) }
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                DispatchQueue.main.async { onCompletion(.badResponse) }
                return
            }
            do {
                let jsonModel = try JSONDecoder().decode(GibberishJsonModel.self, from: data)
                DispatchQueue.main.async { onCompletion(.goodResponse(jsonModel)) }
            } catch {
                DispatchQueue.main.async { onCompletion(.parsingError(error)) }
            }
        }
        task.resume()
    }

    private func constructUrl() -> URL? {
        var urlComps = URLComponents(string: urlString)
        let delay = Int.random(in: 250...3000)
        let minCount = Int.random(in: 10...50)
        let maxCount = Int.random(in: minCount...(minCount + 20))
        urlComps?.queryItems = [URLQueryItem(name: Self.delayKey, value: "\(delay)"),
                                URLQueryItem(name: Self.minWordKey, value: "\(minCount)"),
                                URLQueryItem(name: Self.maxWordKey, value: "\(maxCount)")]
        return urlComps?.url
    }
}
