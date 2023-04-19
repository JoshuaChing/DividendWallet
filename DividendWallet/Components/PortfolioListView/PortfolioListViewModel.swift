//
//  PortfolioListViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 4/7/23.
//

import Foundation
import Combine

class PortfolioListViewModel: ObservableObject {
    @Published var portfolioListEventsRowViewModels: [PortfolioListEventsRowViewModel] = []
    @Published var portfolioListRowViewModels: [PortfolioListRowViewModel] = []
    private var positionsDividendsSubscription: AnyCancellable?
    private var positionsDividendHistorySubscription: AnyCancellable?

    init() {
        subscribeToPositionsDividendsPublisher()
        subscribeToDividendHistoryPublisher()
    }

    deinit {
        positionsDividendsSubscription?.cancel()
        positionsDividendHistorySubscription?.cancel()
    }

    // set up subscription to portfolio update
    private func subscribeToPositionsDividendsPublisher() {
        positionsDividendsSubscription = NotificationCenterManager
            .getUpdatePositionsDividendsPublisher()
            .map { $0.object as? [PortfolioPositionDividendModel] }
            .sink(receiveValue: { [weak self] positions in
                guard let strongSelf = self, let unwrappedPositions = positions else {
                    return
                }
                strongSelf.updateListRowsModels(positions: unwrappedPositions)
            })
    }

    // update portfolio list row view
    private func updateListRowsModels(positions: [PortfolioPositionDividendModel]) {
        let convertedModels = positions.map { $0.toPortfolioListRowViewModel() }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.portfolioListRowViewModels = convertedModels.sorted{ $0.estimatedAnnualDividendIncome > $1.estimatedAnnualDividendIncome }
        }
    }

    // set up subscription for dividend history update
    private func subscribeToDividendHistoryPublisher() {
        positionsDividendHistorySubscription = NotificationCenterManager
            .getUpdatePositionsDividendHistoryPublisher()
            .map { $0.object as? PositionsDividendHistoryModel }
            .sink(receiveValue: { [weak self] dividendHistory in
                guard let strongSelf = self, let unwrappedDividendHistory = dividendHistory else {
                    return
                }
                strongSelf.updateDividendHistoryEvents(dividendHistory: unwrappedDividendHistory)
            })
    }

    // update dividend history events
    private func updateDividendHistoryEvents(dividendHistory: PositionsDividendHistoryModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentYear = Calendar.current.component(.year, from: currentDate)
        var recentEvents: [PortfolioListEventsRowViewModel] = []

        let dispatchGroup = DispatchGroup()
        for (symbol, position) in dividendHistory {
            dispatchGroup.enter()

            for event in position.events {
                let eventMonth = Calendar.current.component(.month, from: event.date)
                let eventYear = Calendar.current.component(.year, from: event.date)
                if isRecentDividend(eventMonth: eventMonth, eventYear: eventYear, currentMonth: currentMonth, currentYear: currentYear) {
                    let estimatedIncome = position.shareCount * event.amount
                    let event = PortfolioListEventsRowViewModel(symbol: symbol,
                                                                shareCount: position.shareCount,
                                                                lastDividendValue: event.amount,
                                                                lastDividendDate: event.date.timeIntervalSince1970,
                                                                lastDividendDateString: dateFormatter.string(from: event.date),
                                                                estimatedIncome: estimatedIncome)
                    recentEvents.append(event)
                }
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // update recent dividends
            strongSelf.portfolioListEventsRowViewModels = recentEvents.sorted{ $0.lastDividendDate > $1.lastDividendDate }
        }
    }

    // helper function for determining recent dividend
    private func isRecentDividend(eventMonth: Int, eventYear: Int, currentMonth: Int, currentYear: Int) -> Bool {
        if currentMonth == 12 {
            return (eventYear == currentYear && eventMonth == currentMonth) || (eventYear == currentYear+1 && eventMonth == 1)
        } else {
            return eventYear == currentYear && (eventMonth == currentMonth || eventMonth == currentMonth+1)
        }
    }
}
