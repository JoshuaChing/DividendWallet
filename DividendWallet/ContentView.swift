//
//  ContentView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PortfolioView()
            .background(Constants.primaryBackgroundColor)
            .foregroundColor(Constants.primaryTextColor)
            .frame(minWidth: Constants.windowMinWidth,
                   idealWidth: Constants.windowIdealWidth,
                   minHeight: Constants.windowMinHeight,
                   idealHeight: Constants.windowIdealHeight)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: Constants.windowIdealWidth,
                   height: Constants.windowIdealHeight)
    }
}
