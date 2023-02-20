//
//  DividendChartView.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 2/14/23.
//

import SwiftUI
import Charts

struct DividendChartView: View {
    private let X_KEY = "Month"
    private let Y_KEY = "Amount ($)"

    @StateObject var viewModel: ViewModel

    var body: some View {
        if !viewModel.isChartDataEmpty() {
            Chart {
                ForEach(viewModel.chartData) { dataPoint in
                    BarMark(x: .value(X_KEY, dataPoint.month),
                            y: .value(Y_KEY, dataPoint.value)
                    )
                    .annotation(position: .top, alignment: .center) {
                        Text(dataPoint.value.toMoneyStringRounded())
                    }
                }
            }
        }
    }
}
