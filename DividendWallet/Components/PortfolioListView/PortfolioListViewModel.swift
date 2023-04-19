//
//  PortfolioListViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 4/7/23.
//

import Foundation
import Combine

class PortfolioListViewModel: ObservableObject {
    var portfolioListEventsRowViewModels: [PortfolioListEventsRowViewModel] = []
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
            .map { $0.object as? DividendHistoryModel }
            .sink(receiveValue: { [weak self] dividendHistory in
                guard let strongSelf = self, let unwrappedDividendHistory = dividendHistory else {
                    return
                }
                strongSelf.updateDividendHistoryEvents(dividendHistory: unwrappedDividendHistory)
            })
    }

    // update dividend history events
    private func updateDividendHistoryEvents(dividendHistory: DividendHistoryModel) {
        print(dividendHistory)
    }
}
