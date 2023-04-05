//
//  PortfolioHeaderViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 3/10/23.
//

import Foundation

extension PortfolioHeaderView {
    class ViewModel: ObservableObject {
        @Published var annualDividend = 0.0
    }
}
