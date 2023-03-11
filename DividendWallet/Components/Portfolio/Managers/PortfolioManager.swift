//
//  PortfolioManager.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

class PortfolioManager: ObservableObject {
    @Published var portfolioListEventsRowViewModels: [PortfolioListEventsRowViewModel] = [PortfolioListEventsRowViewModel]()
    @Published var portfolioListRowViewModels: [PortfolioListRowViewModel] = [PortfolioListRowViewModel]()
    @Published var portfolioHeaderViewModel: PortfolioHeaderView.ViewModel = PortfolioHeaderView.ViewModel()
    @Published var dividendChartViewModel: DividendChartView.ViewModel = DividendChartView.ViewModel()

    private var portfolioPositions: [PortfolioPositionDividendModel] = [] {
        didSet {
            updateAnnualDividend()
            updatePortfolioPositions()
            updateRecentDividends()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let portfolioStorageManager: PortfolioStorageProtocol = FileStorageManager()
    private let dividendManager: DividendManagerProtocol = DividendManager()

    // MARK: HEADER section business logic

    private func updateAnnualDividend() {
        var sum = 0.0
        for position in portfolioPositions {
            sum += position.estimatedAnnualDividendIncome
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.portfolioHeaderViewModel.annualDividend = sum
        }
    }

    // MARK: PORTFOLIO section business logic

    private func updatePortfolioPositions() {
        DispatchQueue.main.async {
            let convertedModels = self.portfolioPositions.map { $0.toPortfolioListRowViewModel() }
            self.portfolioListRowViewModels = convertedModels.sorted{ $0.estimatedAnnualDividendIncome > $1.estimatedAnnualDividendIncome }
        }
    }

    // MARK: UPCOMING DIVIDENDS section business logic

    private func updateRecentDividends() {
        // variables to be displayed
        var recentEvents = [PortfolioListEventsRowViewModel]()
        var currentMonthTotal = 0.0
        var nextMonthTotal = 0.0

        // business logic variables
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentYear = Calendar.current.component(.year, from: currentDate)

        for position in portfolioPositions {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let strongSelf = self else { return }
                // fetch dividend data
                let events = position.isMutualFundOrETF() ?
                    WSApiClient.shared.getDividendEventsForFund(symbol: position.symbol) :
                    WSApiClient.shared.getDividendEventsForIndividualEquity(symbol: position.symbol) // TODO: cache fetched results

                // check event date if within range
                for event in events {
                    let eventMonth = Calendar.current.component(.month, from: event.date)
                    let eventYear = Calendar.current.component(.year, from: event.date)
                    if strongSelf.isRecentDividend(eventMonth: eventMonth, eventYear: eventYear, currentMonth: currentMonth, currentYear: currentYear) {
                        let eventAmount = position.shareCount * event.amount
                        let event = PortfolioListEventsRowViewModel(symbol: position.symbol,
                                                                    shareCount: position.shareCount,
                                                                    quoteType: position.quoteType,
                                                                    lastDividendValue: event.amount,
                                                                    lastDividendDate: event.date.timeIntervalSince1970,
                                                                    lastDividendDateString: dateFormatter.string(from: event.date),
                                                                    estimatedIncome: eventAmount)
                        recentEvents.append(event)
                        if eventMonth == currentMonth {
                            currentMonthTotal += eventAmount
                        } else {
                            nextMonthTotal += eventAmount
                        }

                        // update events
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.portfolioListEventsRowViewModels = recentEvents.sorted{ $0.lastDividendDate > $1.lastDividendDate }
                        }
                    }
                }

                // update dividend chart
                strongSelf.dividendChartViewModel.setChartData(currentMonth: currentMonth, currentMonthTotal: currentMonthTotal, nextMonthTotal: nextMonthTotal)
            }
        }
    }

    private func isRecentDividend(eventMonth: Int, eventYear: Int, currentMonth: Int, currentYear: Int) -> Bool {
        if currentMonth == 12 {
            return (eventYear == currentYear && eventMonth == currentMonth) || (eventYear == currentYear+1 && eventMonth == 1)
        } else {
            return eventYear == currentYear && (eventMonth == currentMonth || eventMonth == currentMonth+1)
        }
    }

    // MARK: fetch portfolio business logic

    func fetchPortfolio(positions: [PortfolioPositionModel]) {
        dividendManager.fetchPortfolioDividendData(positions: positions)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("PortfolioManager.fetchPortfolio: \(error.localizedDescription)")
                default:
                    // do nothing
                    break
                }
            }, receiveValue: { [weak self] models in
                if let self = self {
                    self.portfolioPositions = models
                }
            }).store(in: &cancellables)
    }
}
