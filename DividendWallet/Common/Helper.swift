//
//  Helper.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation

extension Double {
    func toMoneyString() -> String {
        return String(format: Constants.formatMoney, self)
    }

    func toSharesString() -> String {
        return String(format: Constants.formatShares, self)
    }
}

extension YFQuoteResult {
    func isMissingDividendInformation() -> Bool {
        return self.quoteType == Constants.etf || self.quoteType == Constants.mutualFund || self.trailingAnnualDividendRate == nil
    }
}
