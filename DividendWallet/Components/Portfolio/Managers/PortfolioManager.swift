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
            updateRecentEvents()
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

    private func updateRecentEvents() {
        var recentEvents = [PortfolioListEventsRowViewModel]()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        let currentDate = Date()

        // set formatter to GMT timezone (for Yahoo Finance format)
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.timezoneGMT)

        for position in portfolioPositions {
            if let lastDividendValue = position.lastDividendValue, lastDividendValue > 0, let lastDividendDate = position.lastDividendDate {
                let lastDividendDateEpoch: TimeInterval = lastDividendDate
                let lastDividendDateEpochDate = Date(timeIntervalSince1970: lastDividendDateEpoch)

                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: lastDividendDateEpochDate, to: currentDate)
                if let daysAgo = components.day, daysAgo <= Constants.recentEventsDaysAgoThreshold {
                    let event = PortfolioListEventsRowViewModel(symbol: position.symbol,
                                                                shareCount: position.shareCount,
                                                                quoteType: position.quoteType,
                                                                lastDividendValue: lastDividendValue,
                                                                lastDividendDate: lastDividendDate,
                                                                lastDividendDateString: dateFormatter.string(from: lastDividendDateEpochDate),
                                                                estimatedIncome: position.shareCount * lastDividendValue)
                    recentEvents.append(event)
                }
            }
        }
        DispatchQueue.main.async {
            self.portfolioListEventsRowViewModels = recentEvents.sorted{ $0.lastDividendDate > $1.lastDividendDate }
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
