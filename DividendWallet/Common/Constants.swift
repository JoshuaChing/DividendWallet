//
//  Constants.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import SwiftUI

struct Constants {
    static let windowMinWidth:CGFloat = 300
    static let windowMinHeight:CGFloat = 300
    static let windowIdealWidth:CGFloat = 400
    static let windowIdealHeight: CGFloat = 600

    static let paddingSmall: CGFloat = 5
    static let paddingMedium: CGFloat = 10
    static let paddingLarge: CGFloat = 20
    static let paddingXLarge: CGFloat = 40

    static let cornerRadius: CGFloat = 5
    static let trackingDefault: CGFloat = 1

    static let summaryTitle = "Summary"
    static let annualDividendTitle = "Estimated Annual Income"
    static let monthlyDividendTitle = "Estimated Monthly Income"
    static let formatMonthlyText = "%@ Monthly"
    static let formatMoney = "$%.2f"
    static let formatShares = "%@ Shares"
    static let formatSharesMinDigits = 0
    static let formatSharesMaxDigits = 3

    static let etf = "ETF"
    static let mutualFund = "MUTUALFUND"

    static let numOfMonthsInYear = 12.0

    static let fileDelimiter = ","
    static let filePortfolioName = "portfolio"
    static let fileTxtExtension = "txt"

    /*
     dark gray color: Color(red: 34.0/255.0, green: 37.0/255.0, blue: 40.0/255.0)
     star command blue #1481BA: Color(red: 0x14/255, green: 0x81/255, blue: 0xBA/255, opacity: 1.0)
     cyan process #11B5E4: Color(red: 0x11/255, green: 0xB5/255, blue: 0xE4/255, opacity: 1.0)
     cerculean crayola #0CAADC: Color(red: 0x0C/255, green: 0xAA/255, blue: 0xDC/255, opacity: 1.0)
     rich black #001021
     cloud gray #ecf0f1: Color(red: 0xec/255, green: 0xf0/255, blue: 0xf1/255, opacity: 1.0)
     */
    static let primaryBackgroundColor = Color(red: 0xec/255, green: 0xf0/255, blue: 0xf1/255, opacity: 1.0) // cloud gray
    static let primaryTextColor = Color.black
    static let secondaryBackgroundColor = Color(red: 0x14/255, green: 0x81/255, blue: 0xBA/255, opacity: 1.0) // star command blue
    static let secondaryTextColor = Color.white
    static let portfolioRowBackgroundColor = Color.white
}
