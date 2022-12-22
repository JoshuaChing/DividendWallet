//
//  PortfolioHeaderSettingsView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/21/22.
//

import SwiftUI

struct PortfolioHeaderSettingsView: View {
    var portfolioManager: PortfolioManager
    var fileStorageManager: FileStorageManager
    @State private var editing = false
    @State private var portfolioEditorText = ""
    @State private var onSaveErrorShow = false
    @State private var onSaveErrorMessage = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                // settings button
                if !editing {
                    Button(action: { onEdit() }) { Image(systemName: Constants.iconGear) }
                        .padding(.trailing, -Constants.paddingMedium)
                } else {
                    // save button
                    Button(action: { onSaveEdit() }) { Text(Constants.save) }
                        .alert(isPresented: $onSaveErrorShow) {
                            Alert(title: Text(Constants.saveError),
                                  message: Text(onSaveErrorMessage),
                                  dismissButton: .cancel(Text(Constants.ok)))
                        }

                    // cancel button
                    Button(action: { onCancelEdit() }) { Text(Constants.cancel) }
                }
            }
            .buttonStyle(.plain)
            .font(.title3)
            .foregroundColor(Constants.secondaryTextColor)
            .padding(.top, Constants.paddingSmall)

            // portfolio editor
            if editing {
                TextEditor(text: $portfolioEditorText)
                    .frame(height: Constants.portfolioEditorHeight)
                    .cornerRadius(Constants.cornerRadius)
            }
        }
    }

    private func onEdit() {
        portfolioEditorText = fileStorageManager.readPortfolioContent()
        withAnimation{
            self.editing = true
        }
    }

    private func onCancelEdit() {
        withAnimation{
            self.editing = false
        }
    }

    private func onSaveEdit() {
        if let errorMessage = fileStorageManager.savePortfolioContent(content: portfolioEditorText) {
            self.onSaveErrorMessage = errorMessage
            self.onSaveErrorShow = true
        } else {
            let positions = fileStorageManager.fetchPortfolio()
            portfolioManager.fetchPortfolio(positions: positions)
            withAnimation{
                self.editing = false
            }
        }
    }
}

struct PortfolioHeaderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioHeaderSettingsView(portfolioManager: PortfolioManager(), fileStorageManager: FileStorageManager())
    }
}
