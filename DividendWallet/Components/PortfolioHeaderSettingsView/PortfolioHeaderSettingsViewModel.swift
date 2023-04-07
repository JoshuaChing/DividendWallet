//
//  PortfolioHeaderSettingsViewModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 3/11/23.
//

import Foundation

class PortfolioHeaderSettingsViewModel: ObservableObject {
    private var portfolioStorageManager: PortfolioStorageProtocol

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
        self.editing = true
    }

    func onCancelEdit() {
        self.editing = false
    }

    func onSaveEdit() {
        if let errorMessage = portfolioStorageManager.savePortfolioContent(content: portfolioEditorText) {
            self.alertMessage = errorMessage
            self.alertTitle = Constants.saveError
            self.alertShow = true
        } else {
            let positions = self.portfolioStorageManager.fetchPortfolio()
            NotificationCenter.default.post(name: Notification.Name("PortfolioManagerFetchPortfolio"), object: positions) // TODO: use new notification manager
            self.editing = false
        }
    }
}
