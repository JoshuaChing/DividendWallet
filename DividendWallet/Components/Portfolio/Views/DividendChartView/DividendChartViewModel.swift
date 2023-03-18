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
        private let MAX_MONTH_NUMBER = 12

        @Published var chartData: [ChartData] = [ChartData]()

        func isChartDataEmpty() -> Bool {
            return chartData.isEmpty
        }

        func setChartData(currentMonth: Int, currentMonthTotal: Double, nextMonthTotal: Double) {
            let newChartData = [
                ChartData(month: getStringForMonthNumber(currentMonth), value: currentMonthTotal),
                ChartData(month: getStringForMonthNumber(currentMonth+1), value: nextMonthTotal)
            ]
            DispatchQueue.main.async {
                self.chartData = newChartData
            }
        }

        private func getStringForMonthNumber(_ monthNumber: Int) -> String {
            var monthNumber = monthNumber
            if monthNumber > MAX_MONTH_NUMBER {
                monthNumber -= MAX_MONTH_NUMBER
            }
            return Calendar.current.monthSymbols[monthNumber-1]
        }
    }
}
