//
//  AssetListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct AssetListView: View {
    @State var assets: [YFQuoteResult] = []

    var body: some View {
        List(assets, id: \.symbol) { asset in
            AssetRowView(asset: asset)
        }.onAppear {
            YFApiClient.shared.getQuotes { result in
                switch result {
                case .success(let quotes):
                    assets = quotes
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        AssetListView()
    }
}
