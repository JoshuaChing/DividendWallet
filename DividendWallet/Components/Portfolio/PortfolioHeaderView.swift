//
//  PortfolioHeaderView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI

struct PortfolioHeaderView: View {
    @State var annualDividend = 1989.40
    let numOfMonthsInYear = 12.0
    let numOfDaysInYear = 365.0

    var body: some View {
        VStack {
            VStack {
                Text(Constants.annualDividendTitle)
                    .textCase(.uppercase)
                    .tracking(Constants.trackingDefault)
                    .font(.subheadline)
                    .fontWeight(.light)
                Text(annualDividend.toMoneyString())
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
                Text(String(format: Constants.formatMonthlyText, (annualDividend/numOfMonthsInYear).toMoneyString()))
                    .font(.subheadline)
                    .fontWeight(.light)
                Text(String(format: Constants.formatDailyText, (annualDividend/numOfDaysInYear).toMoneyString()))
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
        PortfolioHeaderView()
    }
}
