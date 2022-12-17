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
        List(portfolioObserved.portfolioPositions, id: \.symbol) { position in
            PortfolioListRowView(position: position)
        }
        .scrollContentBackground(.hidden)
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView(portfolioObserved: PortfolioObserved())
    }
}
