//
//  PortfolioListRowView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioListRowView: View {
    var stock: YFQuoteResult

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                Text("1 shares")
                    .font(.caption)
            }
            Spacer()
            Text("$\(String(format: "%.2f", stock.trailingAnnualDividendRate ?? 0.0))")
                .multilineTextAlignment(.trailing)
        }
    }
}

struct PortfolioListRowView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListRowView(stock: YFQuoteResult(symbol: "AAPL",
                                                  quoteType: "EQUITY",
                                                  trailingAnnualDividendRate: 0.9,
                                                  trailingAnnualDividendYield: 0.6))
    }
}
