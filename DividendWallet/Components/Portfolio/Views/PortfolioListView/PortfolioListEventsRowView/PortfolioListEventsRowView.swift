//
//  PortfolioListEventsRowView.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import SwiftUI

struct PortfolioListEventsRowView: View {
    var position: PortfolioListEventsRowViewModel

    var body: some View {
        HStack {
            Text(String(format: Constants.formatRecentEvent, position.lastDividendDateString, position.symbol, position.lastDividendValue.toMoneyString()))
            Spacer()
            Text((position.estimatedIncome).toMoneyString())
                .multilineTextAlignment(.trailing)
        }
        .padding(.trailing, Constants.paddingSmall)
    }
}

struct PortfolioListEventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListEventsRowView(position: PortfolioListEventsRowViewModel(symbol: "SCHD",
                                                                             shareCount: 1,
                                                                             quoteType: "ETF",
                                                                             lastDividendValue: 0.703,
                                                                             lastDividendDate: 1670423400,
                                                                             lastDividendDateString: "2022-12-07",
                                                                             estimatedIncome: 0.703))
    }
}
