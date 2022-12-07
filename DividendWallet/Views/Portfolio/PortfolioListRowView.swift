//
//  PortfolioListRowView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListRowView: View {
    var asset: YFQuoteResult

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(asset.symbol)
                Text("1 shares")
                    .font(.caption)
            }
            Spacer()
            Text("$\(String(format: "%.2f", asset.trailingAnnualDividendRate ?? 0.0))")
                .multilineTextAlignment(.trailing)
        }
    }
}

struct PortfolioListRowView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListRowView(asset: YFQuoteResult(symbol: "AAPL",
                                                  quoteType: "EQUITY",
                                                  trailingAnnualDividendRate: 0.9,
                                                  trailingAnnualDividendYield: 0.6))
    }
}
