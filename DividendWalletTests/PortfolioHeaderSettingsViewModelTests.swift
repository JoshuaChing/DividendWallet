//
//  PortfolioHeaderSettingsViewModelTests.swift
//  DividendWalletTests
//
//  Created by Joshua Ching on 4/3/23.
//

import XCTest

final class PortfolioHeaderSettingsViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_onEdit_readPortfolioContent() {
        let sut = createSystemUnderTest(storedContent: "stored_content")

        sut.onEdit()

        XCTAssertTrue(sut.editing)
        XCTAssertEqual(sut.portfolioEditorText, "stored_content")
    }

    func test_onCancelEdit_setEditingFalse() {
        let sut = createSystemUnderTest()
        sut.editing = true

        sut.onCancelEdit()

        XCTAssertFalse(sut.editing)
    }

    func test_onSaveEditError_showAlert() {
        let sut = createSystemUnderTest(saveErrorMessage: "error_message",
                                        shouldReturnSaveError: true)

        sut.onSaveEdit()

        XCTAssertEqual(sut.alertMessage, "error_message")
        XCTAssertEqual(sut.alertTitle, "Unable to save")
        XCTAssertTrue(sut.alertShow)
    }

    func test_onSaveEdit_fetchPositions() {
        let models: [PortfolioPositionModel] = [
            PortfolioPositionModel(symbol: "AAPL", shareCount: 10)
        ]
        let sut = createSystemUnderTest(models: models)
        let handler: (Notification) -> Bool = { notification in
            guard let models = notification.object as? [PortfolioPositionModel] else {
                XCTFail("Notification failed to receive models.")
                return false
            }
            XCTAssertEqual(models.count, 1)
            XCTAssertEqual(models[0].symbol, "AAPL")
            XCTAssertEqual(models[0].shareCount, 10)
            return true
        }

        expectation(forNotification: Notification.Name("UpdatePositionsNotification"),
                    object: nil,
                    handler: handler)
        sut.onSaveEdit()

        waitForExpectations(timeout: 3)
        XCTAssertFalse(sut.alertShow)
        XCTAssertFalse(sut.editing)
    }

    func createSystemUnderTest(storedContent: String = "",
                               saveErrorMessage: String = "",
                               shouldReturnSaveError: Bool = false,
                               models: [PortfolioPositionModel] = []) -> PortfolioHeaderSettingsViewModel {
        let storageSpy = PortfolioStorageSpy()
        storageSpy.storedContent = storedContent
        storageSpy.saveErrorMessage = saveErrorMessage
        storageSpy.shouldReturnSaveError = shouldReturnSaveError
        storageSpy.models = models
        return PortfolioHeaderSettingsViewModel(portfolioStorageManager: storageSpy)
    }
}
