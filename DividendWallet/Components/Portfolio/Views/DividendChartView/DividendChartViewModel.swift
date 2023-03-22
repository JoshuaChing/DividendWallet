//
//  DividendChartViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 2/19/23.
//

import Foundation

extension DividendChartView {
    struct ChartData: Identifiable, Equatable {
        var id = UUID()
        var month: String
        var value: Double

        static func ==(lhs: ChartData, rhs: ChartData) -> Bool {
            return lhs.value == rhs.value
        }
    }

    class ViewModel: ObservableObject {
        static private let MAX_MONTH_NUMBER = 12
        static private let DEFAULT_MONTH = ""
        static private let DEFAULT_VALUE = 0.0

        @Published var chartData: [ChartData]

        init(pastMonthsToShow: Int, futureMonthsToShow: Int) {
            var monthIndex = Calendar.current.component(.month, from: Date()) - pastMonthsToShow // get start month index
            let totalMonthsToShow = 1 + pastMonthsToShow + futureMonthsToShow // current month + months prior + future months
            let initChartData = Array(repeating: ChartData(month: DividendChartView.ViewModel.DEFAULT_MONTH, value: DividendChartView.ViewModel.DEFAULT_VALUE),
                                      count: totalMonthsToShow)
                .map { data in
                    let data = ChartData(month: DividendChartView.ViewModel.getStringForMonthNumber(monthIndex), value: DividendChartView.ViewModel.DEFAULT_VALUE)
                    monthIndex = monthIndex + 1
                    return data
                }
            chartData = initChartData
        }

        func isChartDataEmpty() -> Bool {
            return chartData.isEmpty
        }

        func setChartData(currentMonth: Int, currentMonthTotal: Double, nextMonthTotal: Double) {
            DispatchQueue.main.async {
                self.chartData[0].value = currentMonthTotal
                self.chartData[1].value = nextMonthTotal
            }
        }

        static private func getStringForMonthNumber(_ monthNumber: Int) -> String {
            var monthNumber = monthNumber
            if monthNumber > MAX_MONTH_NUMBER {
                monthNumber -= MAX_MONTH_NUMBER
            } else if monthNumber <= 0 {
                monthNumber += MAX_MONTH_NUMBER
            }
            return Calendar.current.monthSymbols[monthNumber-1]
        }
    }
}
