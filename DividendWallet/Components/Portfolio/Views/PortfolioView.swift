//
//  PortfolioView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioView: View {
    @StateObject var portfolioObserved = PortfolioObserved()

    let positions = [
        PortfolioPositionModel(symbol: "MSFT", shareCount: 100),
        PortfolioPositionModel(symbol: "JEPI", shareCount: 100),
        PortfolioPositionModel(symbol: "SCHD", shareCount: 100),
        PortfolioPositionModel(symbol: "VTSAX", shareCount: 100),
        PortfolioPositionModel(symbol: "VTIAX", shareCount: 100),
        PortfolioPositionModel(symbol: "AAPL", shareCount: 100),
        PortfolioPositionModel(symbol: "VWO", shareCount: 100),
        PortfolioPositionModel(symbol: "COST", shareCount: 100),
    ]

    var body: some View {
        VStack {
            PortfolioHeaderView(portfolioObserved: portfolioObserved)
            PortfolioListView(portfolioObserved: portfolioObserved)
        }
        .onAppear {
            portfolioObserved.fetchPortfolio(positions: positions)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
