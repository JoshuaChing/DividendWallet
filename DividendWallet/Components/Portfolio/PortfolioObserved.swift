//
//  PortfolioObserved.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

// TODO: move to separate file, consider protocol
struct PortfolioPosition {
    let symbol: String
    let shareCount: Double
}

// TODO: move to separate file, consider protocol
struct PortfolioListRowViewModel {
    let symbol: String
    let shareCount: Double
    let quoteType: String
    let trailingAnnualDividendRate: Double // dividend dollar amount
    let trailingAnnualDividendYield: Double // dividend percentage yield
}

class PortfolioObserved: ObservableObject {
    @Published var stocks: [YFQuoteResult] = []
    var cancellables = Set<AnyCancellable>()
    let positions = [
        PortfolioPosition(symbol: "AAPL", shareCount: 11.1),
        PortfolioPosition(symbol: "TD", shareCount: 12),
        PortfolioPosition(symbol: "SCHD", shareCount: 13.3),
        PortfolioPosition(symbol: "JEPI", shareCount: 14),
        PortfolioPosition(symbol: "VTSAX", shareCount: 15.5),
        PortfolioPosition(symbol: "VTIAX", shareCount: 16),
        PortfolioPosition(symbol: "BRK-B", shareCount: 17.7)
    ]

    func fetchPortfolio(positions: [PortfolioPosition]) {
        let symbols = positions.map { $0.symbol }
        fetchQuotes(symbols: symbols)
    }

    private func fetchQuotes(symbols: [String]) {
        YFApiClient.shared.fetchQuotes(symbols: symbols)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    // do nothing
                    break
                }
            }, receiveValue: { [weak self] quotes in
                if let self = self {
                    DispatchQueue.main.async {
                        self.stocks = quotes
                    }
                }
            })
            .store(in: &cancellables)
    }

    func fetchChart() {
        YFApiClient.shared.fetchChart()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    // do nothing
                    break
                }
            }, receiveValue: { chart in
                if !chart.isEmpty, let dividends = chart[0].events?.dividends {
                    print("\(chart[0].meta.symbol), \(dividends.count) dividends in last twelve months")
                    for dividend in dividends {
                        let date = Date(timeIntervalSince1970: Double(dividend.value.date))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        print("date: \(dateFormatter.string(from: date)) -> \(dividend.value.amount)")
                    }
                }
            }).store(in: &cancellables)
    }
}
