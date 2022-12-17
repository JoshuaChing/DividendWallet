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
        .padding(EdgeInsets(top: Constants.paddingSmall,
                            leading: Constants.paddingMedium,
                            bottom: Constants.paddingSmall,
                            trailing: Constants.paddingMedium))
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
