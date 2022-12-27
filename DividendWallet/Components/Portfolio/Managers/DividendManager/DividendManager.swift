//
//  DividendManager.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import Foundation
import Combine

enum DividendManagerError: Error {
    // errors for fetchPortfolioDividendData
    case selfNilForFetchPortfolioDividendData

    // errors for fetchDividendData
    case selfNilForFetchDividendData

    // errors for fetchEquityTypeDividendData
    case selfNilForFetchEquityTypeDividendData
    case missingDataForFetchEquityTypeDividendData

    // errors for fetchNonEquityTypeDividendData
    case selfNilForFetchNonEquityTypeDividendData
    case missingDataForFetchNonEquityTypeDividendData
}

class DividendManager: DividendManagerProtocol {
    private var cancellables = Set<AnyCancellable>()

    func fetchPortfolioDividendData(positions: [PortfolioPositionModel]) -> Future<[PortfolioPositionDividendModel], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(DividendManagerError.selfNilForFetchPortfolioDividendData))
                return
            }
            self.fetchDividendData(positions: positions)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("DividendManager.fetchPortfolioDividendData.receiveCompletion: \(error.localizedDescription)")
                    default:
                        // do nothing
                        break
                    }
                } receiveValue: { futures in
                    let publishers = futures.map {
                        $0
                            .map { Result<PortfolioPositionDividendModel, Error>.success($0) }
                            .catch { Just<Result<PortfolioPositionDividendModel, Error>>(.failure($0)) }
                            .eraseToAnyPublisher()
                    }
                    Publishers.MergeMany(publishers)
                        .collect()
                        .sink { completion in
                            switch completion {
                            case .failure(let error):
                                print("DividendManager.fetchPortfolioDividendData.receiveCompletion: \(error.localizedDescription)")
                            default:
                                // do nothing
                                break
                            }
                        } receiveValue: { outputs in
                            var models = [PortfolioPositionDividendModel]()
                            for output in outputs {
                                switch output {
                                case .success(let model):
                                    models.append(model)
                                case .failure(let error):
                                    print("DividendManager.fetchPortfolioDividendData.receiveValue: \(error.localizedDescription)")
                                }
                            }
                            promise(.success(models))
                            return
                        }
                        .store(in: &self.cancellables)
                }
                .store(in: &self.cancellables)
        }
    }

    private func fetchDividendData(positions: [PortfolioPositionModel]) -> Future<[Future<PortfolioPositionDividendModel, Error>], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(DividendManagerError.selfNilForFetchDividendData))
                return
            }

            // early return if there are no positions
            if positions.isEmpty {
                promise(.success([Future<PortfolioPositionDividendModel, Error>]()))
                return
            }

            // get list of symbols
            let symbols = positions.map { $0.symbol }

            YFApiClient.shared.fetchQuotes(symbols: symbols)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("DividendManager.fetchDividendData.receiveCompletion: \(error.localizedDescription)")
                        promise(.failure(error))
                        return
                    default:
                        break
                    }
                }, receiveValue: { quotes in
                    var futures = [Future<PortfolioPositionDividendModel, Error>]()
                    for quote in quotes {
                        if let position = positions.first(where: { $0.symbol == quote.symbol}) {
                            if quote.isMissingDividendInformation() {
                                futures.append(self.fetchNonEquityTypeDividendData(symbol: position.symbol, shareCount: position.shareCount, quoteType: quote.quoteType))
                            } else {
                                futures.append(self.fetchEquityTypeDividendData(symbol: position.symbol, shareCount: position.shareCount, quoteType: quote.quoteType))
                            }
                        }
                    }
                    promise(.success(futures))
                    return
                })
                .store(in: &self.cancellables)
        }
    }

    private func fetchEquityTypeDividendData(symbol: String, shareCount: Double, quoteType: String) -> Future<PortfolioPositionDividendModel, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(DividendManagerError.selfNilForFetchEquityTypeDividendData))
                return
            }

            YFApiClient.shared.fetchQuoteSummary(symbol: symbol)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("DividendManager.fetchEquityTypeDividendData.receiveCompletion: \(error.localizedDescription)")
                        promise(.failure(error))
                        return
                    default:
                        break
                    }
                }, receiveValue: { quoteSummaries in
                    guard quoteSummaries.count > 0 else {
                        promise(.failure(DividendManagerError.missingDataForFetchEquityTypeDividendData))
                        return
                    }

                    let quoteSummary = quoteSummaries[0]
                    let model = PortfolioPositionDividendModel(symbol: symbol,
                                                               shareCount: shareCount,
                                                               quoteType: quoteType,
                                                               estimatedAnnualDividendIncome: (quoteSummary.summaryDetail.dividendRate.raw ?? 0.0) * shareCount,
                                                               trailingAnnualDividendRate: quoteSummary.summaryDetail.trailingAnnualDividendRate.raw,
                                                               trailingAnnualDividendYield: quoteSummary.summaryDetail.trailingAnnualDividendYield.raw,
                                                               lastDividendValue: quoteSummary.defaultKeyStatistics.lastDividendValue.raw,
                                                               lastDividendDate: quoteSummary.defaultKeyStatistics.lastDividendDate.raw)
                    promise(.success(model))
                    return
                })
                .store(in: &self.cancellables)
        }
    }

    private func fetchNonEquityTypeDividendData(symbol: String, shareCount: Double, quoteType: String) -> Future<PortfolioPositionDividendModel, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(DividendManagerError.selfNilForFetchNonEquityTypeDividendData))
                return
            }

            YFApiClient.shared.fetchChart(symbol: symbol)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("DividendManager.fetchNonEquityTypeDividendData.receiveCompletion: \(error.localizedDescription)")
                        promise(.failure(error))
                        return
                    default:
                        break
                    }
                }, receiveValue: { chartResults in
                    guard chartResults.count > 0 else {
                        promise(.failure(DividendManagerError.missingDataForFetchNonEquityTypeDividendData))
                        return
                    }

                    let chartResult = chartResults[0]
                    var dividendSum = 0.0
                    if let dividends = chartResult.events?.dividends {
                        for dividend in dividends {
                            dividendSum += dividend.value.amount
                        }
                    }
                    let model = PortfolioPositionDividendModel(symbol: symbol,
                                                               shareCount: shareCount,
                                                               quoteType: quoteType,
                                                               estimatedAnnualDividendIncome: dividendSum * shareCount,
                                                               trailingAnnualDividendRate: dividendSum,
                                                               trailingAnnualDividendYield: 0.0, // TODO: calculate TTM dividend yield,
                                                               lastDividendValue: 0.0, // TODO: calculate
                                                               lastDividendDate: 0.0) // TODO: calculate
                    promise(.success(model))
                    return
                })
                .store(in: &self.cancellables)
        }
    }
}
