//
//  PortfolioObserved.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

class PortfolioObserved: ObservableObject {
    @Published var stocks: [YFQuoteResult] = []
    var cancellables = Set<AnyCancellable>()

    func fetchQuotes() {
        YFApiClient.shared.fetchQuotes()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    // do nothing
                    break
                }
            }, receiveValue: { [weak self] quotes in
                if let self = self {
                    DispatchQueue.main.async {
                        self.stocks = quotes
                    }
                }
            })
            .store(in: &cancellables)
    }

    func fetchChart() {
        YFApiClient.shared.fetchChart()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    // do nothing
                    break
                }
            }, receiveValue: { chart in
                if !chart.isEmpty, let dividends = chart[0].events?.dividends {
                    print("\(chart[0].meta.symbol), \(dividends.count) dividends in last twelve months")
                    for dividend in dividends {
                        let date = Date(timeIntervalSince1970: Double(dividend.value.date))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        print("date: \(dateFormatter.string(from: date)) -> \(dividend.value.amount)")
                    }
                }
            }).store(in: &cancellables)
    }
}
