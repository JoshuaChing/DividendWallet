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
    let estimatedAnnualDividendIncome: Double
}

class PortfolioObserved: ObservableObject {
    @Published var annualDividend = 0.0
    @Published var portfolioPositions: [PortfolioListRowViewModel] = [] {
        didSet { updateAnnualDividend() }
    }
    var cancellables = Set<AnyCancellable>()

    private func updateAnnualDividend() {
        var sum = 0.0
        for position in portfolioPositions {
            sum += position.estimatedAnnualDividendIncome
        }
        annualDividend = sum
    }

    func fetchPortfolio(positions: [PortfolioPosition]) {
        let symbols = positions.map { $0.symbol }

        // fetch initial data for all symbols in position
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
                    self.processYFQuoteResults(positions: positions, quotes: quotes)
                }
            })
            .store(in: &cancellables)
    }

    private func processYFQuoteResults(positions: [PortfolioPosition], quotes: [YFQuoteResult]) {
        var symbolsProcessed = [PortfolioListRowViewModel]()
        var symbolsToFetch = [YFQuoteResult]()

        for quote in quotes {
            if quote.isMissingDividendInformation() {
                // identify the symbols that require additional fetching
                symbolsToFetch.append(quote)
            } else if let position = positions.first(where: { $0.symbol == quote.symbol}) {
                let trailingAnnualDividendRate = quote.trailingAnnualDividendRate ?? 0.0
                let trailingAnnualDividendYield = quote.trailingAnnualDividendYield ?? 0.0
                let newPosition = PortfolioListRowViewModel(symbol: position.symbol,
                                                            shareCount: position.shareCount,
                                                            quoteType: quote.quoteType,
                                                            trailingAnnualDividendRate: trailingAnnualDividendRate,
                                                            trailingAnnualDividendYield: trailingAnnualDividendYield,
                                                            estimatedAnnualDividendIncome: trailingAnnualDividendRate * position.shareCount)
                symbolsProcessed.append(newPosition)
            }
        }

        DispatchQueue.main.async {
            self.portfolioPositions = symbolsProcessed
        }

        // next individually fetch dividend information for remaining positions
        for quote in symbolsToFetch {
            self.fetchChart(symbol: quote.symbol)
        }
    }

    private func fetchChart(symbol: String) {
        YFApiClient.shared.fetchChart(symbol: symbol)
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
                    var sum = 0.0;
                    for dividend in dividends {
                        let date = Date(timeIntervalSince1970: Double(dividend.value.date))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        print("date: \(dateFormatter.string(from: date)) -> \(dividend.value.amount)")
                        sum += dividend.value.amount
                    }
                    print("sum: \(sum)")
                }
            }).store(in: &cancellables)
    }
}
