//
//  Helper.swift
//  DividendWalletTests
//
//  Created by Joshua Ching on 4/8/23.
//

import Foundation

extension PortfolioPositionDividendModel {
    static func createModel(symbol: String = "", estimatedAnnualDividend: Double = 0.0) -> PortfolioPositionDividendModel{
        return PortfolioPositionDividendModel(symbol: symbol,
                                              shareCount: 0,
                                              quoteType: "",
                                              estimatedAnnualDividendIncome: estimatedAnnualDividend,
                                              trailingAnnualDividendRate: nil,
                                              trailingAnnualDividendYield: nil,
                                              lastDividendValue: nil,
                                              lastDividendDate: nil)
    }
}
