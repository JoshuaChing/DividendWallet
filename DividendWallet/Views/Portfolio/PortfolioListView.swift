//
//  PortfolioListView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import SwiftUI
import Combine

struct PortfolioListView: View {
    @StateObject fileprivate var observed = Observed()

    var body: some View {
        List(observed.stocks, id: \.symbol) { stock in
            PortfolioListRowView(stock: stock)
        }.onAppear {
            observed.fetchQuotes()
        }
    }
}

extension PortfolioListView {
    fileprivate class Observed: ObservableObject {
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
    }
}

struct AssetListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView()
    }
}
