//
//  PortfolioPositionDividendModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import Foundation

struct PortfolioPositionDividendModel {
    let symbol: String
    let shareCount: Double
    let quoteType: String
    let estimatedAnnualDividendIncome: Double
    let trailingAnnualDividendRate: Double? // dividend dollar amount
    let trailingAnnualDividendYield: Double? // dividend percentage yield (not available for ETFs & Mutual Funds)
    let lastDividendValue: Double?
    let lastDividendDate: Double?
}

extension PortfolioPositionDividendModel {
    func toPortfolioListRowViewModel() -> PortfolioListRowViewModel {
        return PortfolioListRowViewModel(symbol: self.symbol,
                                         shareCount: self.shareCount,
                                         quoteType: self.quoteType,
                                         trailingAnnualDividendRate: self.trailingAnnualDividendRate ?? 0.0,
                                         trailingAnnualDividendYield: self.trailingAnnualDividendYield ?? 0.0,
                                         estimatedAnnualDividendIncome: self.estimatedAnnualDividendIncome)
    }
}
