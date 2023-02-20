//
//  DividendChartViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 2/19/23.
//

import Foundation

extension DividendChartView {
    struct ChartData: Identifiable {
        var id = UUID()
        var month: String
        var value: Double
    }

    class ViewModel: ObservableObject {
        @Published var chartData: [ChartData] = [ChartData]()

        func isChartDataEmpty() -> Bool {
            return chartData.isEmpty
        }

        func setFakeData() {
            DispatchQueue.main.async { [weak self] in
                self?.chartData = [
                    .init(month: "Oct", value: 60.3),
                    .init(month: "Nov", value: 20.40),
                    .init(month: "Dec", value: 10.35),
                    .init(month: "Jan", value: 60.3),
                    .init(month: "Feb", value: 20.40),
                    .init(month: "Mar", value: 10.35)
                ]
            }
        }
    }
}
