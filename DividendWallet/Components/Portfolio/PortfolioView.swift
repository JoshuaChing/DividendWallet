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
        PortfolioPosition(symbol: "MSFT", shareCount: 175),
        PortfolioPosition(symbol: "JEPI", shareCount: 40),
        PortfolioPosition(symbol: "SCHD", shareCount: 58),
        PortfolioPosition(symbol: "VTSAX", shareCount: 76.01),
        PortfolioPosition(symbol: "VTIAX", shareCount: 63.725),
        PortfolioPosition(symbol: "AAPL", shareCount: 27),
        PortfolioPosition(symbol: "BRK-B", shareCount: 4.123),
        PortfolioPosition(symbol: "SCHY", shareCount: 7),
        PortfolioPosition(symbol: "VWO", shareCount: 4),
        PortfolioPosition(symbol: "MCHI", shareCount: 4),
        PortfolioPosition(symbol: "TD", shareCount: 0.4),
        PortfolioPosition(symbol: "UNP", shareCount: 1),
        PortfolioPosition(symbol: "COST", shareCount: 0),
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
