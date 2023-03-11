//
//  PortfolioView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioView: View {
    @StateObject var portfolioManager = PortfolioManager()
    private let portfolioStorageManager: PortfolioStorageProtocol = FileStorageManager()

    var body: some View {
        VStack {
            PortfolioHeaderView(viewModel: portfolioManager.portfolioHeaderViewModel,
                                dividendChartViewModel: portfolioManager.dividendChartViewModel,
                                portfolioManager: portfolioManager,
                                portfolioStorageManager: portfolioStorageManager)
            PortfolioListView(portfolioManager: portfolioManager)
        }
        .onAppear {
            let positions = portfolioStorageManager.fetchPortfolio()
            portfolioManager.fetchPortfolio(positions: positions)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
