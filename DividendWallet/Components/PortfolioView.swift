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
            PortfolioHeaderView(dividendChartViewModel: portfolioManager.dividendChartViewModel)
            PortfolioListView(portfolioListEventsRowViewModels: portfolioManager.portfolioListEventsRowViewModels)
        }
        .onAppear {
            let positions = portfolioStorageManager.fetchPortfolio()
            NotificationCenterManager.postUpdatePositions(positions: positions)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
