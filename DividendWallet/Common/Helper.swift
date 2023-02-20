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

    func toMoneyStringRounded() -> String {
        return String(format: Constants.formatMoneyRounded, self)
    }

    func toSharesString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = Constants.formatSharesMinDigits
        formatter.maximumFractionDigits = Constants.formatSharesMaxDigits
        let number = NSNumber(value: self)
        let formattedNumber = formatter.string(from: number) ?? ""
        return String(format: Constants.formatShares, formattedNumber)
    }
}

extension YFQuoteResponseResult {
    func isMissingDividendInformation() -> Bool {
        return self.quoteType == Constants.etf || self.quoteType == Constants.mutualFund || self.trailingAnnualDividendRate == nil
    }
}
