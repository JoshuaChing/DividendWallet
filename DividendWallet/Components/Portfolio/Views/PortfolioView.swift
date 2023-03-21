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
            PortfolioHeaderView(viewModel: portfolioManager.portfolioHeaderViewModel,
                                portfolioHeaderSettingsViewModel: portfolioManager.portfolioHeaderViewSettingsViewModel,
                                dividendChartViewModel: portfolioManager.dividendChartViewModel)
            PortfolioListView(portfolioManager: portfolioManager)
        }
        .onAppear {
            portfolioManager.setup()
            let positions = portfolioStorageManager.fetchPortfolio()
            NotificationCenter.default.post(name: Notification.Name(PortfolioManager.NOTIFICATON_FETCH_PORTFOLIO), object: positions)
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
