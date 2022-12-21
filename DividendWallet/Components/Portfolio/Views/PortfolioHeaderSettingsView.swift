//
//  PortfolioHeaderSettingsView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/21/22.
//

import SwiftUI

struct PortfolioHeaderSettingsView: View {
    var fileStorageManager: FileStorageManager

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                fileStorageManager.editPortfolio()
            }) {
                Image(systemName: Constants.iconGear)
            }
            .padding(.top, Constants.paddingSmall)
            .padding(.bottom, Constants.paddingMedium)
            .foregroundColor(Constants.secondaryTextColor)
            .buttonStyle(.plain)
            .font(.title3)
        }
    }
}

struct PortfolioHeaderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioHeaderSettingsView(fileStorageManager: FileStorageManager())
    }
}
