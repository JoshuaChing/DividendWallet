//
//  PortfolioManager.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

class PortfolioManager: ObservableObject {
    private var portfolioPositions: [PortfolioPositionDividendModel] = [] {
        didSet {
            NotificationCenterManager.postUpdatePositionsDividends(positions: self.portfolioPositions)
            fetchDividendHistory()
        }
    }
    private let dividendManager: DividendManagerProtocol = DividendManager()
    private var dividendHistoryCache: DividendHistoryModel = [:]
    private var cancellables = Set<AnyCancellable>()
    private var positionsSubscription: AnyCancellable?

    init() {
        subscribeToPositionsPublisher()
    }

    deinit {
        positionsSubscription?.cancel()
    }

    private func subscribeToPositionsPublisher() {
        if positionsSubscription == nil {
            positionsSubscription = NotificationCenterManager.getUpdatePositionsPublisher()
                .map { $0.object as? [PortfolioPositionModel] }
                .sink(receiveValue: { [weak self] positions in
                    guard let strongSelf = self, let unwrappedPositions = positions else {
                        return
                    }
                    strongSelf.fetchPortfolio(positions: unwrappedPositions)
                })
        }
    }

    // MARK: fetch dividend history

    private func fetchDividendHistory() {
        let dispatchGroup = DispatchGroup()
        var currentDividendHistory:PositionsDividendHistoryModel = [:]

        for position in portfolioPositions {
            dispatchGroup.enter()

            // fetch dividend history if not in cache
            if ((dividendHistoryCache[position.symbol]) == nil) {
                let fetchedEvents = position.isMutualFundOrETF() ?
                    WSApiClient.shared.getDividendEventsForFund(symbol: position.symbol) :
                    WSApiClient.shared.getDividendEventsForIndividualEquity(symbol: position.symbol)
                dividendHistoryCache[position.symbol] = fetchedEvents
            }

            // build current dividend history
            if let events = dividendHistoryCache[position.symbol] {
                currentDividendHistory[position.symbol] = PositionDividendHistoryModel(events: events, shareCount: position.shareCount)
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .global(qos: .background)) {
            // post positions dividend history
            NotificationCenterManager.postUpdatePositionsDividendHistory(dividendHistory: currentDividendHistory)
        }
    }

    private func isRecentDividend(eventMonth: Int, eventYear: Int, currentMonth: Int, currentYear: Int) -> Bool {
        if currentMonth == 12 {
            return (eventYear == currentYear && eventMonth == currentMonth) || (eventYear == currentYear+1 && eventMonth == 1)
        } else {
            return eventYear == currentYear && (eventMonth == currentMonth || eventMonth == currentMonth+1)
        }
    }

    // MARK: fetch portfolio business logic

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
