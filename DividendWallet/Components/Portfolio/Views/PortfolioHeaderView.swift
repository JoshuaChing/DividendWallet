//
//  PortfolioHeaderView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioHeaderView: View {
    @ObservedObject var portfolioManager: PortfolioManager

    var body: some View {
        VStack {
            VStack {
                Text(Constants.annualDividendTitle)
                    .textCase(.uppercase)
                    .tracking(Constants.trackingDefault)
                    .font(.subheadline)
                    .fontWeight(.light)
                Text(portfolioManager.annualDividend.toMoneyString())
                    .tracking(CGFloat(Constants.trackingDefault))
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .padding(.init(top: Constants.paddingSmallest,
                                   leading: Constants.paddingNone,
                                   bottom: Constants.paddingSmallest,
                                   trailing: Constants.paddingNone))
            }
            .padding(.init(top: Constants.paddingXLarge,
                           leading: Constants.paddingMedium,
                           bottom: Constants.paddingNone,
                           trailing: Constants.paddingMedium))
            VStack {
                Text(String(format: Constants.formatMonthlyText, (portfolioManager.annualDividend/Constants.numOfMonthsInYear).toMoneyString()))
                    .font(.subheadline)
                    .fontWeight(.light)
                Text(String(format: Constants.formatDailyText, (portfolioManager.annualDividend/Constants.numOfDaysInYear).toMoneyString()))
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            .padding(.init(top: Constants.paddingNone,
                           leading: Constants.paddingMedium,
                           bottom: Constants.paddingMedium,
                           trailing: Constants.paddingMedium))
        }
    }
}

struct PortfolioHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioHeaderView(portfolioManager: PortfolioManager())
    }
}
