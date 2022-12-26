//
//  PortfolioView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioView: View {
    @StateObject var portfolioManager = PortfolioManager()
    private let fileStorageManager: PortfolioStorageProtocol = FileStorageManager()

    var body: some View {
        VStack {
            PortfolioHeaderView(portfolioManager: portfolioManager, fileStorageManager: fileStorageManager)
            PortfolioListView(portfolioManager: portfolioManager)
        }
        .onAppear {
            let positions = fileStorageManager.fetchPortfolio()
            portfolioManager.fetchPortfolio(positions: positions)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
