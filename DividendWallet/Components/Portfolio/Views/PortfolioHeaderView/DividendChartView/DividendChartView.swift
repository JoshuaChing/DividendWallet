//
//  DividendChartView.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 2/14/23.
//

import SwiftUI
import Charts

struct DividendChartView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        if !viewModel.isChartDataEmpty() {
            Chart {
                ForEach(viewModel.chartData) { dataPoint in
                    BarMark(x: .value("Month", dataPoint.month),
                            y: .value("Amount ($)", dataPoint.value)
                    )
                }
            }
        }
    }
}
