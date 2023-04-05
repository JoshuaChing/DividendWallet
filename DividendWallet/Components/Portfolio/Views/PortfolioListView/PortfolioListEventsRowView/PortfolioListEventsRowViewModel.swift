//
//  PortfolioListEventsRowViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import Foundation

extension PortfolioListEventsRowView {
    // used to represent what is to be displayed in portfolio event row
    struct ViewModel: Identifiable {
        let id = UUID()
        let symbol: String
        let shareCount: Double
        let quoteType: String
        let lastDividendValue: Double
        let lastDividendDate: Double
        let lastDividendDateString: String
        let estimatedIncome: Double
    }
}
