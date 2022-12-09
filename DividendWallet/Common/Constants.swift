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
    static let windowIdealWidth:CGFloat = windowMinWidth
    static let windowIdealHeight: CGFloat = 500

    static let paddingNone: CGFloat = 0
    static let paddingSmallest: CGFloat = 1
    static let paddingSmall: CGFloat = 5
    static let paddingMedium: CGFloat = 10
    static let paddingXLarge: CGFloat = 40

    static let trackingDefault: CGFloat = 1

    static let annualDividendTitle = "Estimated Annual Dividend Income"
    static let formatMonthlyText = "%@ Monthly"
    static let formatDailyText = "%@ Daily"
    static let formatMoney = "$%.2f"
    static let formatShares = "%.3f Shares"

    static let etf = "ETF"
    static let mutualFund = "MUTUALFUND"

    static let numOfMonthsInYear = 12.0
    static let numOfDaysInYear = 365.0

    /*
     dark gray color: Color(red: 34.0/255.0, green: 37.0/255.0, blue: 40.0/255.0)
     */
    static let primaryBackgroundColor = Color(red: 34.0/255.0, green: 37.0/255.0, blue: 40.0/255.0)
    static let primaryTextColor = Color.white
    static let subTextColor = Color.blue
}
