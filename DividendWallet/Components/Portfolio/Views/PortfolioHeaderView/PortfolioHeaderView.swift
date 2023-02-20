//
//  PortfolioHeaderView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioHeaderView: View {
    @ObservedObject var portfolioManager: PortfolioManager
    var portfolioStorageManager: PortfolioStorageProtocol

    var body: some View {
        VStack {
            VStack {
                PortfolioHeaderSettingsView(portfolioManager: portfolioManager, portfolioStorageManager: portfolioStorageManager)
                Text(Constants.summaryTitle)
                    .textCase(.uppercase)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top, Constants.paddingMedium)
                    .padding(.bottom, Constants.paddingLarge)
                    .tracking(Constants.trackingDefault)
                Text(Constants.annualDividendTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .tracking(Constants.trackingDefault)
                Text(portfolioManager.annualDividend.toMoneyString())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .fontWeight(.ultraLight)
                    .padding(.bottom, Constants.paddingMedium)
                    .tracking(Constants.trackingDefault)
                Text(Constants.monthlyDividendTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textCase(.uppercase)
                    .font(.caption)
                    .fontWeight(.medium)
                    .tracking(Constants.trackingDefault)
                Text((portfolioManager.annualDividend/Constants.numOfMonthsInYear).toMoneyString())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                    .fontWeight(.ultraLight)
                    .tracking(Constants.trackingDefault)
                DividendChartView(viewModel: portfolioManager.dividendChartViewModel)
            }
            .padding(.init(top: Constants.paddingSmall,
                           leading: Constants.paddingLarge,
                           bottom: Constants.paddingXLarge,
                           trailing: Constants.paddingLarge))
        }
        .background(Constants.secondaryBackgroundColor)
        .foregroundColor(Constants.secondaryTextColor)
    }
}

struct PortfolioHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioHeaderView(portfolioManager: PortfolioManager(), portfolioStorageManager: FileStorageManager())
    }
}
