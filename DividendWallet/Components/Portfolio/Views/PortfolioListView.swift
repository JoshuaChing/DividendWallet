//
//  PortfolioListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListView: View {
    @ObservedObject var portfolioManager: PortfolioManager

    var body: some View {
        List(portfolioManager.portfolioPositions, id: \.symbol) { position in
            PortfolioListRowView(position: position)
        }
        .scrollContentBackground(.hidden)
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView(portfolioManager: PortfolioManager())
    }
}
