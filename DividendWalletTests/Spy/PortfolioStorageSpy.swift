//
//  PortfolioStorageSpy.swift
//  DividendWalletTests
//
//  Created by Joshua Ching on 4/3/23.
//

import Foundation

class PortfolioStorageSpy: PortfolioStorageProtocol {
    var storedContent: String = ""
    var shouldReturnSaveError = false
    var saveErrorMessage = ""
    var models: [PortfolioPositionModel] = []

    func fetchPortfolio() -> [PortfolioPositionModel] {
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
