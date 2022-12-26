//
//  PortfolioManager.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

class PortfolioManager: ObservableObject {
    @Published var annualDividend = 0.0
    @Published var portfolioPositions: [PortfolioListRowViewModel] = [] {
        didSet { updateAnnualDividend() }
    }
    private var cancellables = Set<AnyCancellable>()
    private let portfolioStorageManager: PortfolioStorageProtocol = FileStorageManager()

    private func updateAnnualDividend() {
        var sum = 0.0
        for position in portfolioPositions {
            sum += position.estimatedAnnualDividendIncome
        }
        annualDividend = sum
    }

    func fetchPortfolio(positions: [PortfolioPositionModel]) {
        // early return if there are no positions
        if positions.isEmpty {
            portfolioPositions = [PortfolioListRowViewModel]()
            return
        }

        let symbols = positions.map { $0.symbol }

        // fetch initial data for all symbols in position
        YFApiClient.shared.fetchQuotes(symbols: symbols)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("PortfolioManager.fetchPortfolio: \(error.localizedDescription)")
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

    private func processYFQuoteResults(positions: [PortfolioPositionModel], quotes: [YFQuoteResponseResult]) {
        var symbolsProcessed = [PortfolioListRowViewModel]()
        var symbolsToFetch = [YFQuoteResponseResult]()

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

        // fetch remaining symbols
        fetchIndividualSymbols(positions: positions, symbolsProcessed: symbolsProcessed, symbolsToFetch: symbolsToFetch)
    }

    private func fetchIndividualSymbols(positions: [PortfolioPositionModel], symbolsProcessed: [PortfolioListRowViewModel], symbolsToFetch: [YFQuoteResponseResult]) {
        var symbolsProcessed = symbolsProcessed // copy symbols processed for mutable copy
        let symbolsToFetchFutures: [Future<[YFChartResult], Error>] = symbolsToFetch.map { YFApiClient.shared.fetchChart(symbol: $0.symbol) }
        let publishers = symbolsToFetchFutures.map {
            $0
                .map { Result<YFChartResult, Error>.success($0[0]) }
                .catch { Just<Result<YFChartResult, Error>>(.failure($0)) }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("PortfolioManager.fetchIndividualSymbols.receiveCompletion: \(error.localizedDescription)")
                case .finished:
                    DispatchQueue.main.async {
                        if let self = self {
                            // sort positions from highest income to lowest
                            self.portfolioPositions = symbolsProcessed.sorted{ $0.estimatedAnnualDividendIncome > $1.estimatedAnnualDividendIncome }
                        }
                    }
                }
            }, receiveValue: { outputs in
                for output in outputs {
                    switch output {
                    case .success(let chartResult):
                        self.processYFChartResult(chartResult: chartResult, positions: positions, symbolsProcessed: &symbolsProcessed)
                    case .failure(let error):
                        print("PortfolioManager.fetchIndividualSymbols.receiveValue: \(error.localizedDescription)")
                    }
                }
            }).store(in: &cancellables)
    }

    private func processYFChartResult(chartResult: YFChartResult, positions: [PortfolioPositionModel], symbolsProcessed: inout [PortfolioListRowViewModel]) {
        var dividendSum = 0.0
        if let dividends = chartResult.events?.dividends {
            for dividend in dividends {
                dividendSum += dividend.value.amount
            }
        }
        if let position = positions.first(where: { $0.symbol == chartResult.meta.symbol}) {
            let newPosition = PortfolioListRowViewModel(symbol: position.symbol,
                                                        shareCount: position.shareCount,
                                                        quoteType: chartResult.meta.instrumentType,
                                                        trailingAnnualDividendRate: dividendSum,
                                                        trailingAnnualDividendYield: 0.0, // TODO: calculate TTM dividend yield
                                                        estimatedAnnualDividendIncome: dividendSum * position.shareCount)
            symbolsProcessed.append(newPosition)
        }
    }
}
