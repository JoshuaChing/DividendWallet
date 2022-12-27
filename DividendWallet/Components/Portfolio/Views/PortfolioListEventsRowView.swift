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
        Text("\(position.symbol), \(position.lastDividendValue), \(position.lastDividendDate)")
    }
}

struct PortfolioListEventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListEventsRowView(position: PortfolioListEventsRowViewModel(symbol: "AAPL",
                                                                             shareCount: 1,
                                                                             quoteType: "EQUITY",
                                                                             lastDividendValue: 1.5,
                                                                             lastDividendDate: 1663853400,
                                                                             lastDividendDateString: "2022-09-22"))
    }
}
