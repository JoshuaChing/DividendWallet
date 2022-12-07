//
//  AssetListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct AssetListView: View {
    let assets = [
        AssetModel(ticker: "AAPL", numberOfShares: 5.0),
        AssetModel(ticker: "MSFT", numberOfShares: 10.0),
        AssetModel(ticker: "AMZN", numberOfShares: 15.0),
        AssetModel(ticker: "GOOGL", numberOfShares: 5.0),
        AssetModel(ticker: "TSLA", numberOfShares: 10.0),
        AssetModel(ticker: "TSM", numberOfShares: 15.0),
        AssetModel(ticker: "TD", numberOfShares: 5.0),
        AssetModel(ticker: "BRK.B", numberOfShares: 10.0),
        AssetModel(ticker: "NFLX", numberOfShares: 15.0)
    ]

    var body: some View {
        List(assets, id: \.ticker) { asset in
            AssetRowView(asset: asset)
        }
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        AssetListView()
    }
}
