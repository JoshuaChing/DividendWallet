//
//  PortfolioListRowView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListRowView: View {
    var position: PortfolioListRowViewModel

    var body: some View {
        VStack() {
            HStack() {
                VStack(alignment: .leading) {
                    Text(position.symbol)
                    Text(position.shareCount.toSharesString())
                        .font(.caption)
                }
                Spacer()
                Text((position.estimatedAnnualDividendIncome).toMoneyString())
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
        PortfolioListRowView(position: PortfolioListRowViewModel(symbol: "AAPL",
                                                                 shareCount: 1,
                                                                 quoteType: "EQUITY",
                                                                 trailingAnnualDividendRate: 0.9,
                                                                 trailingAnnualDividendYield: 0.6,
                                                                 estimatedAnnualDividendIncome: 0.9))
    }
}
