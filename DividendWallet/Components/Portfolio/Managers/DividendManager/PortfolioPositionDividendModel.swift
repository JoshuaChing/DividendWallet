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
    func isMutualFundOrETF() -> Bool {
        return self.quoteType == Constants.mutualFund || self.quoteType == Constants.etf
    }
}
