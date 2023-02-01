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
    @Published var portfolioListEventsRowViewModels: [PortfolioListEventsRowViewModel] = [PortfolioListEventsRowViewModel]()
    @Published var portfolioListRowViewModels: [PortfolioListRowViewModel] = [PortfolioListRowViewModel]()
    private var portfolioPositions: [PortfolioPositionDividendModel] = [] {
        didSet {
            updateAnnualDividend()
            updatePortfolioListRowViewModels()
            updateRecentDividends()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let portfolioStorageManager: PortfolioStorageProtocol = FileStorageManager()
    private let dividendManager: DividendManagerProtocol = DividendManager()

    private func updateAnnualDividend() {
        var sum = 0.0
        for position in portfolioPositions {
            sum += position.estimatedAnnualDividendIncome
        }
        DispatchQueue.main.async {
            self.annualDividend = sum
        }
    }

    private func updatePortfolioListRowViewModels() {
        DispatchQueue.main.async {
            let convertedModels = self.portfolioPositions.map { $0.toPortfolioListRowViewModel() }
            self.portfolioListRowViewModels = convertedModels.sorted{ $0.estimatedAnnualDividendIncome > $1.estimatedAnnualDividendIncome }
        }
    }

    private func updateRecentDividends() {
        var recentEvents = [PortfolioListEventsRowViewModel]()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        let currentDate = Date()
        guard let timeAgo = Calendar.current.date(byAdding: .month, value: Constants.recentDividendsMonthsAgoThreshold, to: currentDate),
              let timeLater = Calendar.current.date(byAdding: .month, value: Constants.recentDividendsMonthsLaterThreshold, to: currentDate) else {
            return
        }

        for position in portfolioPositions {
            DispatchQueue.global(qos: .background).async {
                // fetch dividend data
                let events = position.isMutualFundOrETF() ?
                    WSApiClient.shared.getDividendEventsForFund(symbol: position.symbol) :
                    WSApiClient.shared.getDividendEventsForIndividualEquity(symbol: position.symbol) // TODO: cache fetched results

                // check event date if within range
                for event in events {
                    if event.date >= timeAgo && event.date <= timeLater {
                        let event = PortfolioListEventsRowViewModel(symbol: position.symbol,
                                                                    shareCount: position.shareCount,
                                                                    quoteType: position.quoteType,
                                                                    lastDividendValue: event.amount,
                                                                    lastDividendDate: event.date.timeIntervalSince1970,
                                                                    lastDividendDateString: dateFormatter.string(from: event.date),
                                                                    estimatedIncome: position.shareCount * event.amount)
                        recentEvents.append(event)
                        // update events
                        DispatchQueue.main.async {
                            self.portfolioListEventsRowViewModels = recentEvents.sorted{ $0.lastDividendDate > $1.lastDividendDate }
                        }
                    }
                }
            }
        }
    }

    func fetchPortfolio(positions: [PortfolioPositionModel]) {
        dividendManager.fetchPortfolioDividendData(positions: positions)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("PortfolioManager.fetchPortfolio: \(error.localizedDescription)")
                default:
                    // do nothing
                    break
                }
            }, receiveValue: { [weak self] models in
                if let self = self {
                    self.portfolioPositions = models
                }
            }).store(in: &cancellables)
    }
}
