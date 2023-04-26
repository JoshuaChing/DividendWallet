//
//  PortfolioListViewModelTests.swift
//  DividendWalletTests
//
//  Created by Joshua Ching on 4/8/23.
//

import XCTest
import Combine

final class PortfolioListViewModelTests: XCTestCase {
    func tests_onPositionsUpdated_updateListRowModels() {
        // Given
        let positions = [
            PortfolioPositionDividendModel.createModel(symbol: "A", estimatedAnnualDividend: 1.0),
            PortfolioPositionDividendModel.createModel(symbol: "B", estimatedAnnualDividend: 2.0),
            PortfolioPositionDividendModel.createModel(symbol: "C", estimatedAnnualDividend: 3.0)
        ]
        let sut = PortfolioListViewModel()
        XCTAssertEqual(sut.portfolioListRowViewModels.count, 0)

        // When
        NotificationCenterManager.postUpdatePositionsDividends(positions: positions)
        RunLoop.main.run(mode: .default, before: .distantPast)

        // Then
        XCTAssertEqual(sut.portfolioListRowViewModels.count, 3)
        XCTAssertEqual(sut.portfolioListRowViewModels[0].symbol, "C")
        XCTAssertEqual(sut.portfolioListRowViewModels[0].estimatedAnnualDividendIncome, 3.0)
        XCTAssertEqual(sut.portfolioListRowViewModels[1].symbol, "B")
        XCTAssertEqual(sut.portfolioListRowViewModels[1].estimatedAnnualDividendIncome, 2.0)
        XCTAssertEqual(sut.portfolioListRowViewModels[2].symbol, "A")
        XCTAssertEqual(sut.portfolioListRowViewModels[2].estimatedAnnualDividendIncome, 1.0)
    }

    func tests_onDividendHistoryUpdated_updateListEventsRowModels() {
        // Given
        let mockDividendHistoryModel = createMockDividendHistoryModel()
        let sut = PortfolioListViewModel()
        XCTAssertEqual(sut.portfolioListEventsRowViewModels.count, 0)
        XCTAssertFalse(sut.shouldShowEvents())

        // When
        NotificationCenterManager.postUpdatePositionsDividendHistory(dividendHistory: mockDividendHistoryModel)
        RunLoop.main.run(mode: .default, before: .distantPast)

        // Then
        XCTAssertTrue(sut.shouldShowEvents())
        XCTAssertEqual(sut.portfolioListEventsRowViewModels.count, 2)
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[0].symbol, "C")
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[0].lastDividendValue, 2.0)
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[0].shareCount, 5.0)
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[0].estimatedIncome, 10.0)
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[1].symbol, "B")
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[1].lastDividendValue, 3.0)
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[1].shareCount, 6.0)
        XCTAssertEqual(sut.portfolioListEventsRowViewModels[1].estimatedIncome, 18.0)
    }

    private func createMockDividendHistoryModel() -> PositionsDividendHistoryModel{
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)

        // get first day of current month
        guard let currentMonthDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: currentMonth, day: 1)) else {
            fatalError("Could not get the first day of the current month.")
        }

        // get previous month
        guard let previousMonthDate = calendar.date(byAdding: DateComponents(month: -1), to: currentDate) else {
            fatalError("Could not get the previous month.")
        }

        // get next month
        guard let nextMonthDate = calendar.date(byAdding: DateComponents(month: 1), to: currentDate) else {
            fatalError("Could not get the next month.")
        }

        // get next next month
        guard let nextNextMonthDate = calendar.date(byAdding: DateComponents(month: 2), to: currentDate) else {
            fatalError("Could not get the next next month.")
        }

        let dividendHistoryModel: PositionsDividendHistoryModel = [
            "A": PositionDividendHistoryModel(events: [WSDividendEventModel(date: previousMonthDate, amount: 1.0)], shareCount: 5),
            "B": PositionDividendHistoryModel(events: [
                WSDividendEventModel(date: previousMonthDate, amount: 1.0),
                WSDividendEventModel(date: currentMonthDate, amount: 3.0), // this dividend should be captured
                WSDividendEventModel(date: nextNextMonthDate, amount: 1.0)
            ], shareCount: 6),
            "C": PositionDividendHistoryModel(events: [
                WSDividendEventModel(date: previousMonthDate, amount: 1.0),
                WSDividendEventModel(date: nextMonthDate, amount: 2.0), // this dividend should be captured
                WSDividendEventModel(date: nextNextMonthDate, amount: 1.0)
            ], shareCount: 5),
            "D": PositionDividendHistoryModel(events: [WSDividendEventModel(date: nextNextMonthDate, amount: 1.0)], shareCount: 5),
        ]

        return dividendHistoryModel
    }
}
