//
//  YFApiClient.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation

enum YFError: Error {
    case invalidUrl
    case invalidData
    case failedToFetchData
}

class YFApiClient {
    static let shared = YFApiClient()

    func getQuotes(completion: @escaping (Result<[YFQuoteResult], Error>) -> Void) {
        let urlString = "https://query2.finance.yahoo.com/v7/finance/quote?symbols=AAPL,TD,TSLA,JEPI,SCHD,VTSAX"
        guard let url = URL(string: urlString) else {
            completion(.failure(YFError.invalidUrl))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(YFError.invalidData))
                return
            }

            do {
                let responseModel = try JSONDecoder().decode(YFQuoteResponseModel.self, from: data)
                completion(.success(responseModel.quoteResponse.result))
            } catch let error {
                print("asdasadasd")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
