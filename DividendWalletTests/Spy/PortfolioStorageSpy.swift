//
//  PortfolioStorageSpy.swift
//  DividendWalletTests
//
//  Created by Joshua Ching on 4/3/23.
//

import Foundation
@testable import Dividend_Wallet

class PortfolioStorageSpy: PortfolioStorageProtocol {
    var storedContent: String = ""
    var shouldReturnSaveError = false
    var saveErrorMessage = ""
    var models: [Dividend_Wallet.PortfolioPositionModel] = []

    func fetchPortfolio() -> [Dividend_Wallet.PortfolioPositionModel] {
        return models
    }

    func readPortfolioContent() -> String {
        return storedContent
    }

    func savePortfolioContent(content: String) -> String? {
        if shouldReturnSaveError {
            return saveErrorMessage
        } else {
            storedContent = content
            return nil
        }
    }
}
