//
//  AssetRowView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct AssetRowView: View {
    var asset: AssetModel

    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(asset.ticker)
                Text("\(String(asset.numberOfShares)) shares")
                    .font(.caption)
            }
            Spacer()
            Text("$\(String(format: "%.2f", asset.numberOfShares*1.23))")
                .multilineTextAlignment(.trailing)
        }
    }
}

struct AssetRowView_Previews: PreviewProvider {
    static var previews: some View {
        AssetRowView(asset: AssetModel(ticker: "AAPL", numberOfShares: 5.0))
    }
}
