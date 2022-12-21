//
//  FileStorageManager.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/16/22.
//

import Foundation

class FileStorageManager {
    var positions = [PortfolioPositionModel]()

    func fetchPortfolio() -> [PortfolioPositionModel] {
        guard let url = Bundle.main.url(forResource: Constants.filePortfolioName, withExtension: Constants.fileTxtExtension) else {
            return [PortfolioPositionModel]()
        }

        do {
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            let lines = fileContent.components(separatedBy: .newlines)
            for line in lines {
                let values = line.components(separatedBy: Constants.fileDelimiter)
                processLine(values: values)
            }
            return positions
        } catch {
            print(error.localizedDescription)
        }
        return [PortfolioPositionModel]()
    }

    private func processLine(values: [String]) {
        if (values.isEmpty) {
            return
        }

        // process first value: ticker symbol
        let symbol = values[0].trimmingCharacters(in: .whitespacesAndNewlines)
        if values.isEmpty || values.count <= 0 {
            return
        }

        // process second value: share count
        if values.count <= 1 {
            positions.append(PortfolioPositionModel(symbol: symbol, shareCount: 0.0))
            return
        }
        let shareCount = values[1].trimmingCharacters(in: .whitespacesAndNewlines)
        let shareCountNum = Double(shareCount) ?? 0.0
        positions.append(PortfolioPositionModel(symbol: symbol, shareCount: shareCountNum))
    }

    func editPortfolio() {
        guard let url = Bundle.main.url(forResource: Constants.filePortfolioName, withExtension: Constants.fileTxtExtension) else {
            return
        }
        print(url)
    }
}
