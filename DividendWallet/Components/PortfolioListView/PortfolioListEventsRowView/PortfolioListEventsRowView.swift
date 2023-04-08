//
//  PortfolioListEventsRowView.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import SwiftUI

struct PortfolioListEventsRowView: View {
    private let EVENT_TEXT_WIDTH: CGFloat = 50
    var viewModel: PortfolioListEventsRowViewModel

    var body: some View {
        HStack {
            Text(viewModel.lastDividendDateString)
                .frame(width: EVENT_TEXT_WIDTH, alignment: .leading)
            Text(viewModel.symbol)
                .frame(width: EVENT_TEXT_WIDTH, alignment: .leading)
            Text(String(format: Constants.formatDividendPerShare, viewModel.lastDividendValue.toMoneyString(), viewModel.shareCount.toSharesString()))
                .font(.caption)
            Spacer()
            Text((viewModel.estimatedIncome).toMoneyString())
                .multilineTextAlignment(.trailing)
        }
        .padding(.trailing, Constants.paddingSmall)
    }
}

struct PortfolioListEventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListEventsRowView(viewModel: PortfolioListEventsRowViewModel(symbol: "SCHD",
                                                                              shareCount: 1,
                                                                              quoteType: "ETF",
                                                                              lastDividendValue: 0.703,
                                                                              lastDividendDate: 1670423400,
                                                                              lastDividendDateString: "2022-12-07",
                                                                              estimatedIncome: 0.703))
    }
}
