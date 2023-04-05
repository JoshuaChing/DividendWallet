//
//  PortfolioListRowView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListRowView: View {
    var viewModel: PortfolioListRowView.ViewModel

    var body: some View {
        VStack() {
            HStack() {
                VStack(alignment: .leading) {
                    Text(viewModel.symbol)
                    Text(viewModel.shareCount.toSharesString())
                        .font(.caption)
                }
                Spacer()
                Text((viewModel.estimatedAnnualDividendIncome).toMoneyString())
                    .multilineTextAlignment(.trailing)
            }
            .padding()
        }
        .background(Constants.portfolioRowBackgroundColor)
        .foregroundColor(Constants.primaryTextColor)
        .cornerRadius(Constants.cornerRadius)
    }
}

struct PortfolioListRowView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListRowView(viewModel: PortfolioListRowView.ViewModel(symbol: "AAPL",
                                                                       shareCount: 1,
                                                                       quoteType: "EQUITY",
                                                                       trailingAnnualDividendRate: 0.9,
                                                                       trailingAnnualDividendYield: 0.6,
                                                                       estimatedAnnualDividendIncome: 0.9))
    }
}
