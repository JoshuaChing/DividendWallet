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
        if self <= 0 {
            return String(format: Constants.formatMultipleShares, self)
        } else if self <= 1 {
            return String(format: Constants.formatSingleShare, self)
        } else {
            return String(format: Constants.formatMultipleShares, self)
        }
    }
}

extension YFQuoteResult {
    func isMissingDividendInformation() -> Bool {
        return self.quoteType == Constants.etf || self.quoteType == Constants.mutualFund || self.trailingAnnualDividendRate == nil
    }
}
