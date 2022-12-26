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

    func fetchQuotes(symbols: [String]) -> Future<[YFQuoteResponseResult], Error> {
        return Future { promise in
            let symbolsJoined = symbols.joined(separator: ",")
            let urlString = "https://query2.finance.yahoo.com/v7/finance/quote?symbols=\(symbolsJoined)"
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

    func fetchChart(symbol: String) -> Future<[YFChartResult], Error> {
        return Future { promise in
            let urlString = "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)"
            guard let url = URL(string: urlString) else {
                promise(.failure(YFError.invalidUrl))
                return
            }

            let endTime = Int(Date().timeIntervalSince1970)
            let secondsInYear = 60*60*24*365
            let startTime = endTime - secondsInYear

            var items = [URLQueryItem]()
            items.append(URLQueryItem(name: "period1", value: String(startTime)))
            items.append(URLQueryItem(name: "period2", value: String(endTime)))
            items.append(URLQueryItem(name: "interval", value: "1d"))
            items.append(URLQueryItem(name: "events", value: "div"))
            let urlWithQueryItems = url.appending(queryItems: items)

            let task = URLSession.shared.dataTask(with: urlWithQueryItems) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let data = data else {
                    promise(.failure(YFError.invalidData))
                    return
                }

                do {
                    let responseModel = try JSONDecoder().decode(YFChartModel.self, from: data)
                    promise(.success(responseModel.chart.result))
                } catch let error {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
    }

    func fetchQuoteSummary(symbol: String) -> Future<[YFQuoteSummaryResult], Error> {
        return Future { promise in
            let urlString = "https://query2.finance.yahoo.com/v10/finance/quoteSummary/\(symbol)?modules=summaryDetail,defaultKeyStatistics,quoteType"
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
                    let responseModel = try JSONDecoder().decode(YFQuoteSummaryModel.self, from: data)
                    promise(.success(responseModel.quoteSummary.result))
                } catch let error {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
    }
}
