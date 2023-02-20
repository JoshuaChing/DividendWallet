//
//  PortfolioListEventsRowView.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import SwiftUI

struct PortfolioListEventsRowView: View {
    private let EVENT_TEXT_WIDTH: CGFloat = 50
    var position: PortfolioListEventsRowViewModel

    var body: some View {
        HStack {
            Text(position.lastDividendDateString)
                .frame(width: EVENT_TEXT_WIDTH, alignment: .leading)
            Text(position.symbol)
                .frame(width: EVENT_TEXT_WIDTH, alignment: .leading)
            Text(String(format: Constants.formatDividendPerShare, position.lastDividendValue.toMoneyString(), position.shareCount.toSharesString()))
                .font(.caption)
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
