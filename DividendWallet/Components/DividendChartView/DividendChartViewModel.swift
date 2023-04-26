//
//  DividendChartViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 2/19/23.
//

import Foundation
import Combine

struct ChartData: Identifiable, Equatable {
    var id = UUID()
    var month: String
    var value: Double

    static func ==(lhs: ChartData, rhs: ChartData) -> Bool {
        return lhs.value == rhs.value
    }
}

class DividendChartViewModel: ObservableObject {
    private let MAX_MONTH_NUMBER = 12
    private let DEFAULT_MONTH = ""
    private let DEFAULT_VALUE = 0.0
    private var positionsDividendHistorySubscription: AnyCancellable?

    @Published var chartData: [ChartData] = []

    init(pastMonthsToShow: Int, futureMonthsToShow: Int) {
        // init empty columns
        var monthIndex = Calendar.current.component(.month, from: Date()) - pastMonthsToShow // get start month index
        let totalMonthsToShow = 1 + pastMonthsToShow + futureMonthsToShow // current month + months prior + future months
        let initChartData = Array(repeating: ChartData(month: DEFAULT_MONTH, value: DEFAULT_VALUE), count: totalMonthsToShow)
            .map { data in
                let data = ChartData(month: getStringForMonthNumber(monthIndex), value: DEFAULT_VALUE)
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
        print(dividendHistory)
    }

    private func getStringForMonthNumber(_ monthNumber: Int) -> String {
        var monthNumber = monthNumber
        if monthNumber > MAX_MONTH_NUMBER {
            monthNumber -= MAX_MONTH_NUMBER
        } else if monthNumber <= 0 {
            monthNumber += MAX_MONTH_NUMBER
        }
        return Calendar.current.monthSymbols[monthNumber-1]
    }
}
