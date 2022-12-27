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
    @Published var portfolioListRowViewModels: [PortfolioListRowViewModel] = [PortfolioListRowViewModel]()
    private var portfolioPositions: [PortfolioPositionDividendModel] = [] {
        didSet {
            updateAnnualDividend()
            updatePortfolioListRowViewModels()
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
