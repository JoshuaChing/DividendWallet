//
//  PortfolioListEventsRowViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import Foundation

// used to represent what is to be displayed in portfolio event row
struct PortfolioListEventsRowViewModel: Identifiable {
    let id = UUID()
    let symbol: String
    let shareCount: Double
    let lastDividendValue: Double
    let lastDividendDate: Double
    let lastDividendDateString: String
    let estimatedIncome: Double
}
