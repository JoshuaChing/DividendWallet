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
}
