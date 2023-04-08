//
//  PortfolioListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListView: View {
    @StateObject var viewModel = PortfolioListViewModel()
    var portfolioListEventsRowViewModels: [PortfolioListEventsRowView.ViewModel]

    var body: some View {
        List {
            Section() {
                Text(Constants.recentEventsTitle)
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.medium)
                    .tracking(Constants.trackingDefault)
                if !portfolioListEventsRowViewModels.isEmpty {
                    ForEach(portfolioListEventsRowViewModels, id: (\.id)) { PortfolioListEventsRowView(viewModel: $0) }
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
                ForEach(viewModel.portfolioListRowViewModels, id: \.symbol) { PortfolioListRowView(viewModel: $0) }
            }
        }
        .padding(.leading, Constants.paddingSmall)
        .padding(.trailing, Constants.paddingSmall)
        .scrollContentBackground(.hidden)
        .animation(.default, value: viewModel.portfolioListRowViewModels.count)
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView(portfolioListEventsRowViewModels: [])
    }
}
