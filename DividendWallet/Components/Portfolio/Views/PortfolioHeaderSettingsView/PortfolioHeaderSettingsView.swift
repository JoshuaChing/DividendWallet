//
//  PortfolioHeaderSettingsView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/21/22.
//

import SwiftUI

struct PortfolioHeaderSettingsView: View {
    var portfolioManager: PortfolioManager
    @StateObject var viewModel: PortfolioHeaderSettingsView.ViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()
                // settings button
                if !viewModel.editing {
                    Button(action: { onEdit() }) { Image(systemName: Constants.iconGear) }
                        .padding(.trailing, -Constants.paddingMedium)
                } else {
                    // save button
                    Button(action: { onSaveEdit() }) { Text(Constants.save) }

                    // cancel button
                    Button(action: { onCancelEdit() }) { Text(Constants.cancel) }
                }
            }
            .buttonStyle(.plain)
            .font(.title3)
            .foregroundColor(Constants.secondaryTextColor)
            .padding(.top, Constants.paddingSmall)
            .alert(isPresented: $viewModel.alertShow) {
                Alert(title: Text(viewModel.alertTitle),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .cancel(Text(Constants.ok)))
            }

            // portfolio editor
            if viewModel.editing {
                TextEditor(text: $viewModel.portfolioEditorText)
                    .frame(height: Constants.portfolioEditorHeight)
                    .cornerRadius(Constants.cornerRadius)
            }
        }
    }

    private func onEdit() {
        viewModel.onEdit()
        withAnimation{
            self.viewModel.editing = true
        }
    }

    private func onCancelEdit() {
        withAnimation{
            self.viewModel.editing = false
        }
    }

    private func onSaveEdit() {
        if viewModel.onSaveEdit() {
            let positions = viewModel.portfolioStorageManager.fetchPortfolio()
            portfolioManager.fetchPortfolio(positions: positions)
            withAnimation{
                self.viewModel.editing = false
            }
        }
    }
}

struct PortfolioHeaderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioHeaderSettingsView(portfolioManager: PortfolioManager(), viewModel: PortfolioHeaderSettingsView.ViewModel(portfolioStorageManager: FileStorageManager()))
    }
}
