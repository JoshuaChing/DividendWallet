//
//  PortfolioListRowViewModel.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/16/22.
//

import Foundation

// used to represent what is to be displayed in portfolio row
struct PortfolioListRowViewModel {
    let symbol: String
    let shareCount: Double
    let quoteType: String
    let trailingAnnualDividendRate: Double // dividend dollar amount
    let trailingAnnualDividendYield: Double // dividend percentage yield
    let estimatedAnnualDividendIncome: Double
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
