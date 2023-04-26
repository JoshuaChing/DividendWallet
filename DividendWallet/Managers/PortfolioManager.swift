//
//  PortfolioManager.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation
import Combine

class PortfolioManager: ObservableObject {
    @Published var dividendChartViewModel: DividendChartViewModel
    private var dividendHistoryCache: DividendHistoryModel = [:]

    private var portfolioPositions: [PortfolioPositionDividendModel] = [] {
        didSet {
            NotificationCenterManager.postUpdatePositionsDividends(positions: self.portfolioPositions)
            fetchDividendHistory()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let dividendManager: DividendManagerProtocol = DividendManager()
    private var positionsSubscription: AnyCancellable?

    init() {
        // initialize all view models
        self.dividendChartViewModel = DividendChartViewModel(pastMonthsToShow: Constants.pastMonthsToShow, futureMonthsToShow: Constants.futureMonthsToShow)
        subscribeToPositionsPublisher()
    }

    deinit {
        positionsSubscription?.cancel()
    }

    private func subscribeToPositionsPublisher() {
        if positionsSubscription == nil {
            positionsSubscription = NotificationCenterManager.getUpdatePositionsPublisher()
                .map { $0.object as? [PortfolioPositionModel] }
                .sink(receiveValue: { [weak self] positions in
                    guard let strongSelf = self, let unwrappedPositions = positions else {
                        return
                    }
                    strongSelf.fetchPortfolio(positions: unwrappedPositions)
                })
        }
    }

    // MARK: fetch dividend history

    private func fetchDividendHistory() {
        let dispatchGroup = DispatchGroup()
        var currentDividendHistory:PositionsDividendHistoryModel = [:]

        for position in portfolioPositions {
            dispatchGroup.enter()

            // fetch dividend history if not in cache
            if ((dividendHistoryCache[position.symbol]) == nil) {
                let fetchedEvents = position.isMutualFundOrETF() ?
                    WSApiClient.shared.getDividendEventsForFund(symbol: position.symbol) :
                    WSApiClient.shared.getDividendEventsForIndividualEquity(symbol: position.symbol)
                dividendHistoryCache[position.symbol] = fetchedEvents
            }

            // build current dividend history
            if let events = dividendHistoryCache[position.symbol] {
                currentDividendHistory[position.symbol] = PositionDividendHistoryModel(events: events, shareCount: position.shareCount)
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .global(qos: .background)) {
            // post positions dividend history
            NotificationCenterManager.postUpdatePositionsDividendHistory(dividendHistory: currentDividendHistory)
        }
    }

    // TODO: remove after refactor dividend charts
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
