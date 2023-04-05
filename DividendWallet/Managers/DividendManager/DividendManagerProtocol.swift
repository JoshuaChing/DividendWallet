//
//  DividendManagerProtocol.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/26/22.
//

import Foundation
import Combine

protocol DividendManagerProtocol {
    func fetchPortfolioDividendData(positions: [PortfolioPositionModel]) -> Future<[PortfolioPositionDividendModel], Error>
}
