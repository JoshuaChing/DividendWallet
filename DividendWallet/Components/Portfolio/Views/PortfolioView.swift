//
//  PortfolioView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioView: View {
    @StateObject var portfolioObserved = PortfolioObserved()

    var body: some View {
        VStack {
            PortfolioHeaderView(portfolioObserved: portfolioObserved)
            PortfolioListView(portfolioObserved: portfolioObserved)
        }
        .onAppear {
            portfolioObserved.fetchPortfolio()
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
