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
        PortfolioPosition(symbol: "MSFT", shareCount: 100),
        PortfolioPosition(symbol: "JEPI", shareCount: 100),
        PortfolioPosition(symbol: "SCHD", shareCount: 100),
        PortfolioPosition(symbol: "VTSAX", shareCount: 100),
        PortfolioPosition(symbol: "VTIAX", shareCount: 100),
        PortfolioPosition(symbol: "AAPL", shareCount: 100),
        PortfolioPosition(symbol: "SCHY", shareCount: 100),
        PortfolioPosition(symbol: "VWO", shareCount: 100),
        PortfolioPosition(symbol: "MCHI", shareCount: 100),
        PortfolioPosition(symbol: "TD", shareCount: 100),
        PortfolioPosition(symbol: "UNP", shareCount: 100),
        PortfolioPosition(symbol: "BRK-B", shareCount: 100),
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
