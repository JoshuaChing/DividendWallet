//
//  PortfolioListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListView: View {
    var portfolioListEventsRowViewModels: [PortfolioListEventsRowView.ViewModel]
    var portfolioListRowViewModels: [PortfolioListRowView.ViewModel]

    var body: some View {
        List {
            Section() {
                Text(Constants.recentEventsTitle)
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.medium)
                    .tracking(Constants.trackingDefault)
                if !portfolioListEventsRowViewModels.isEmpty {
                    ForEach(portfolioListEventsRowViewModels, id: (\.id)) { viewModel in
                        PortfolioListEventsRowView(viewModel: viewModel)
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
                ForEach(portfolioListRowViewModels, id: \.symbol) { viewModel in
                    PortfolioListRowView(viewModel: viewModel)
                }
            }
        }
        .padding(.leading, Constants.paddingSmall)
        .padding(.trailing, Constants.paddingSmall)
        .scrollContentBackground(.hidden)
        .animation(.default, value: portfolioListRowViewModels.count)
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView(portfolioListEventsRowViewModels: [], portfolioListRowViewModels: [])
    }
}
