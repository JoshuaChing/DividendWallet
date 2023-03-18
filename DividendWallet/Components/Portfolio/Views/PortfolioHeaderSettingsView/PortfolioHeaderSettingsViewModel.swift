//
//  PortfolioHeaderSettingsViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 3/11/23.
//

import Foundation

protocol PortfolioHeaderSettingsDelegate {
    func onEdit()
    func onSave()
}

extension PortfolioHeaderSettingsView {
    class ViewModel: ObservableObject {
        var portfolioStorageManager: PortfolioStorageProtocol

        @Published var editing = false
        @Published var portfolioEditorText = ""
        @Published var alertShow = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""

        init(portfolioStorageManager: PortfolioStorageProtocol) {
            self.portfolioStorageManager = portfolioStorageManager
        }

        func onEdit() {
            portfolioEditorText = portfolioStorageManager.readPortfolioContent()
        }

        func onSaveEdit() -> Bool {
            if let errorMessage = portfolioStorageManager.savePortfolioContent(content: portfolioEditorText) {
                self.alertMessage = errorMessage
                self.alertTitle = Constants.saveError
                self.alertShow = true
                return false
            }
            return true
        }
    }
}
