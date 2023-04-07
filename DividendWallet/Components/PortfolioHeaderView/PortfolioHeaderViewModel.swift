//
//  PortfolioHeaderViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 3/10/23.
//

import Foundation
import Combine

class PortfolioHeaderViewModel: ObservableObject {
    var annualDividend = 0.0
    private var positionsDividendsSubscriber: AnyCancellable?

    init() {
        setUpPositionsDividendsSubscriber()
    }

    deinit {
        positionsDividendsSubscriber?.cancel()
    }

    private func setUpPositionsDividendsSubscriber() {
        positionsDividendsSubscriber = NotificationCenterManager.getUpdatePositionsDividendsPublisher()
            .map { $0.object as? [PortfolioPositionDividendModel] }
            .sink(receiveValue: { [weak self] positions in
                guard let strongSelf = self, let unwrappedPositions = positions else {
                    return
                }
                strongSelf.updateAnnualDividend(positions: unwrappedPositions)
            })
    }

    private func updateAnnualDividend(positions: [PortfolioPositionDividendModel]) {
        var sum = 0.0
        for position in positions {
            sum += position.estimatedAnnualDividendIncome
        }
        self.annualDividend = sum
    }
}
