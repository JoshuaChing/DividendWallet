//
//  PortfolioStorageProtocol.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import Foundation

protocol PortfolioStorageProtocol {
    func fetchPortfolio() -> [PortfolioPositionModel]
    func readPortfolioContent() -> String
    func savePortfolioContent(content: String) -> String?
}
