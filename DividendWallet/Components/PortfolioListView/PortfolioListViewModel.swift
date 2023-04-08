//
//  PortfolioListViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 4/7/23.
//

import Foundation
import Combine

class PortfolioListViewModel: ObservableObject {
    var portfolioListEventsRowViewModels: [PortfolioListEventsRowView.ViewModel] = []
    @Published var portfolioListRowViewModels: [PortfolioListRowView.ViewModel] = []
    var positionsDividendsSubscriber: AnyCancellable?

    init() {
        subscribeToPositionsDividendsPublisher()
    }

    private func subscribeToPositionsDividendsPublisher() {
        positionsDividendsSubscriber = NotificationCenterManager
            .getUpdatePositionsDividendsPublisher()
            .map { $0.object as? [PortfolioPositionDividendModel] }
            .sink(receiveValue: { [weak self] positions in
                guard let strongSelf = self, let unwrappedPositions = positions else {
                    return
                }
                strongSelf.updateListRowsModels(positions: unwrappedPositions)
            })
    }

    private func updateListRowsModels(positions: [PortfolioPositionDividendModel]) {
        let convertedModels = positions.map { $0.toPortfolioListRowViewModel() }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.portfolioListRowViewModels = convertedModels.sorted{ $0.estimatedAnnualDividendIncome > $1.estimatedAnnualDividendIncome }
        }
    }
}
