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
        List {
            Section() {
                Text(Constants.recentEventsTitle)
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.medium)
                    .tracking(Constants.trackingDefault)
                if !portfolioManager.portfolioListEventsRowViewModels.isEmpty {
                    ForEach(portfolioManager.portfolioListEventsRowViewModels, id: (\.id)) { position in
                        PortfolioListEventsRowView(position: position)
                    }
                } else {
                    Text(Constants.noRecentEvents)
                        .italic(true)
                }
            }
            Section() {
                Text(Constants.portfolioTitle)
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.medium)
                    .tracking(Constants.trackingDefault)
                ForEach(portfolioManager.portfolioListRowViewModels, id: \.symbol) { position in
                    PortfolioListRowView(position: position)
                }
            }
        }
        .padding(.leading, Constants.paddingSmall)
        .padding(.trailing, Constants.paddingSmall)
        .scrollContentBackground(.hidden)
        .animation(.default, value: portfolioManager.portfolioListRowViewModels.count)
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView(portfolioManager: PortfolioManager())
    }
}
