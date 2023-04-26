//
//  DividendChartViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 2/19/23.
//

import Foundation
import Combine

class ChartData: Identifiable, Equatable {
    var id = UUID()
    var month: String
    var value: Double
    var columnKey: String // column key to identify column

    init(month: String, value: Double, columnKey: String) {
        self.month = month
        self.value = value
        self.columnKey = columnKey
    }

    static func ==(lhs: ChartData, rhs: ChartData) -> Bool {
        return lhs.value == rhs.value
    }
}

class DividendChartViewModel: ObservableObject {
    private let MAX_MONTH_NUMBER = 12
    private let DEFAULT_MONTH = ""
    private let DEFAULT_VALUE = 0.0
    private let DEFAULT_COLUMN_KEY = ""
    private let COLUMN_KEY_FORMAT = "%@-%@"
    private var positionsDividendHistorySubscription: AnyCancellable?
    private var columnKeySet = Set<String>() // keeps track of existing column keys

    @Published var chartData: [ChartData] = []

    init(pastMonthsToShow: Int, futureMonthsToShow: Int) {
        // init empty columns
        var monthIndex = Calendar.current.component(.month, from: Date()) - pastMonthsToShow // get start month index
        let totalMonthsToShow = 1 + pastMonthsToShow + futureMonthsToShow // current month + months prior + future months
        let initChartData = Array(repeating: ChartData(month: DEFAULT_MONTH, value: DEFAULT_VALUE, columnKey: DEFAULT_COLUMN_KEY), count: totalMonthsToShow)
            .map { data in
                let data = ChartData(month: getStringForMonthNumber(monthIndex), value: DEFAULT_VALUE, columnKey: getColumnKeyForMonthNumber(monthIndex))
                monthIndex = monthIndex + 1
                return data
            }
        chartData = initChartData

        // set up subscriber
        subscribeToDividendHistoryPublisher()
    }

    deinit {
        positionsDividendHistorySubscription?.cancel()
    }

    func isChartDataEmpty() -> Bool {
        return chartData.isEmpty
    }

    // set up subscription for dividend history update
    private func subscribeToDividendHistoryPublisher() {
        positionsDividendHistorySubscription = NotificationCenterManager
            .getUpdatePositionsDividendHistoryPublisher()
            .map { $0.object as? PositionsDividendHistoryModel }
            .sink(receiveValue: { [weak self] dividendHistory in
                guard let strongSelf = self, let unwrappedDividendHistory = dividendHistory else {
                    return
                }
                strongSelf.updateChart(dividendHistory: unwrappedDividendHistory)
            })
    }

    // update chart
    private func updateChart(dividendHistory: PositionsDividendHistoryModel) {
        // get cleared values chart data
        let updatedChartData = self.chartData
        updatedChartData.forEach { $0.value = 0.0 }

        // set up output date formatter
        let outputDateFormat = "MMMM-yyyy"
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputDateFormat

        for (symbol, position) in dividendHistory {
            for event in position.events {
                // check if event is part of any columns
                let currentColumnKey = outputDateFormatter.string(from: event.date).lowercased()
                if columnKeySet.contains(currentColumnKey) {
                    for column in updatedChartData {
                        if column.columnKey == currentColumnKey {
                            let estimatedIncome = event.amount * position.shareCount
                            column.value = column.value + estimatedIncome
                            print("DividendChartViewModel.updateChart: \(column.columnKey) + \(symbol) (\(estimatedIncome))")
                        }
                    }
                }
            }
        }

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // update recent dividends
            strongSelf.chartData = updatedChartData
        }
    }

    // helper function to get month string from month index
    private func getStringForMonthNumber(_ monthNumber: Int) -> String {
        var monthNumber = monthNumber
        if monthNumber > MAX_MONTH_NUMBER {
            monthNumber -= MAX_MONTH_NUMBER
        } else if monthNumber <= 0 {
            monthNumber += MAX_MONTH_NUMBER
        }
        return Calendar.current.monthSymbols[monthNumber-1]
    }

    // helper function to get column key string from month index
    private func getColumnKeyForMonthNumber(_ monthIndex: Int) -> String {
        let monthString = getStringForMonthNumber(monthIndex)

        var currentYear = Calendar.current.component(.year, from: Date())
        if monthIndex > MAX_MONTH_NUMBER {
            currentYear = currentYear + 1
        } else if monthIndex <= 0 {
            currentYear = currentYear - 1
        }

        let columnKey = String(format: COLUMN_KEY_FORMAT, monthString, String(currentYear)).lowercased()
        columnKeySet.insert(columnKey)
        return columnKey
    }
}
