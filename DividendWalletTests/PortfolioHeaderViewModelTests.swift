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

    func tests_positionsDividendsUpdated_annualDividendUpdates() async {
        // Given
        let positions: [PortfolioPositionDividendModel] = [
            createDividendPosition(value: 1.1),
            createDividendPosition(value: 2.2),
            createDividendPosition(value: 3.3)
        ]
        let sut = PortfolioHeaderViewModel()
        XCTAssertEqual(sut.annualDividend, 0.0)

        // When
        NotificationCenterManager.postUpdatePositionsDividends(positions: positions)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            XCTAssertEqual(sut.annualDividend, 6.6)
        }
    }

    private func createDividendPosition(value: Double) -> PortfolioPositionDividendModel {
        PortfolioPositionDividendModel(symbol: "",
                                       shareCount: 0,
                                       quoteType: "",
                                       estimatedAnnualDividendIncome: value,
                                       trailingAnnualDividendRate: nil,
                                       trailingAnnualDividendYield: nil,
                                       lastDividendValue: nil,
                                       lastDividendDate: nil)
    }
}
