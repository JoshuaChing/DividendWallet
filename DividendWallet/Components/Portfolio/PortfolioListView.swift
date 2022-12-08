//
//  PortfolioListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListView: View {
    @ObservedObject var portfolioObserved: PortfolioObserved

    var body: some View {
        List(portfolioObserved.stocks, id: \.symbol) { stock in
            PortfolioListRowView(stock: stock)
        }
        .scrollContentBackground(.hidden)
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView(portfolioObserved: PortfolioObserved())
    }
}
