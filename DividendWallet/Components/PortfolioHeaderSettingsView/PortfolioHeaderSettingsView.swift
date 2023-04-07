//
//  PortfolioHeaderSettingsView.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/21/22.
//

import SwiftUI

struct PortfolioHeaderSettingsView: View {
    @StateObject var viewModel: PortfolioHeaderSettingsViewModel

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
                    .scrollContentBackground(.hidden)
                    .padding(Constants.paddingMedium)
                    .foregroundColor(Constants.secondaryTextColor)
                    .background(Constants.secondaryBackgroundColorRaised)
                    .cornerRadius(Constants.cornerRadius)
            }
        }
    }

    private func onEdit() {
        withAnimation{
            viewModel.onEdit()
        }
    }

    private func onCancelEdit() {
        withAnimation{
            viewModel.onCancelEdit()
        }
    }

    private func onSaveEdit() {
        withAnimation {
            viewModel.onSaveEdit()
        }
    }
}

struct PortfolioHeaderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioHeaderSettingsView(viewModel: PortfolioHeaderSettingsViewModel(portfolioStorageManager: FileStorageManager()))
    }
}
