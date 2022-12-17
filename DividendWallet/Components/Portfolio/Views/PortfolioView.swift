//
//  PortfolioView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioView: View {
    @StateObject var portfolioManager = PortfolioManager()

    var body: some View {
        VStack {
            PortfolioHeaderView(portfolioManager: portfolioManager)
            PortfolioListView(portfolioManager: portfolioManager)
        }
        .onAppear {
            portfolioManager.fetchPortfolio()
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
