//
//  YFApiClient.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

enum YFError: Error {
    case invalidUrl
    case invalidData
    case failedToFetchData
}

class YFApiClient {
    static let shared = YFApiClient()

    func fetchQuotes() -> Future<[YFQuoteResult], Error> {
        return Future { promise in
            let urlString = "https://query2.finance.yahoo.com/v7/finance/quote?symbols=AAPL,TD,TSLA,JEPI,SCHD,VTSAX,VTIAX"
            guard let url = URL(string: urlString) else {
                promise(.failure(YFError.invalidUrl))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let data = data else {
                    promise(.failure(YFError.invalidData))
                    return
                }

                do {
                    let responseModel = try JSONDecoder().decode(YFQuoteResponseModel.self, from: data)
                    promise(.success(responseModel.quoteResponse.result))
                } catch let error {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
    }
}
