//
//  PortfolioHeaderViewModelTests.swift
//  DividendWalletTests
//
//  Created by Joshua Ching on 4/6/23.
//

import XCTest

final class PortfolioHeaderViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func tests_positionsDividendsUpdated_annualDividendUpdates() {
        // Given
        let positions: [PortfolioPositionDividendModel] = [
            PortfolioPositionDividendModel.createModel(estimatedAnnualDividend: 1.1),
            PortfolioPositionDividendModel.createModel(estimatedAnnualDividend: 2.2),
            PortfolioPositionDividendModel.createModel(estimatedAnnualDividend: 3.3)
        ]
        let sut = PortfolioHeaderViewModel()
        XCTAssertEqual(sut.annualDividend, 0.0)

        // When
        NotificationCenterManager.postUpdatePositionsDividends(positions: positions)
        RunLoop.main.run(mode: .default, before: .distantPast)

        // Then
        XCTAssertEqual(sut.annualDividend, 6.6)
    }
}
