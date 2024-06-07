//
//  ContentView.swift
//  PasswordManager
//
//  Created by Lochan on 07/06/24.
//

import SwiftUI
import LocalAuthentication
import SwiftData
import CryptoKit

struct HomeView: View {
    @State private var isUnlocked = false
    @State private var isSheetPresentedAdd = false
    @State var selectedItem: Credentials?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Query private var credentials: [Credentials]
    var keychainManager: KeychainController = KeychainController()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                if isUnlocked {
                    VStack {
                        List {
                            ForEach(credentials) { data in
                                Section {
                                    ViewCell(account: data.account)
                                        .onTapGesture {
                                            self.selectedItem = data
                                        }
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listSectionSpacing(.compact)
                        .listRowBackground(Color("background"))
                        HStack {
                            Spacer()
                            Button(action: {
                                print("Add button clicked")
                                
                                isSheetPresentedAdd = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.blue)
                                    )
                                    .foregroundColor(.white)
                            }
                            .sheet(isPresented: $isSheetPresentedAdd) {
                                InputView(credential: Credentials(account: "", username: "", password: ""), buttonType: "Add New Account")
                                    .presentationDetents([.medium, .large])
                            }
                            .sheet(item: $selectedItem) { item in
                                DetailsView(credential: item)
                                    .presentationDetents([.medium, .large])
                            }
                        }
                        .frame(width: getWidth() - 64)
                    }
                } else {
                    Text("App is Locked")
                }
            }
            .navigationTitle("Password Manager")
        }
        .onAppear {
            authenticate()
        }
    }
    
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "It's needed to unlock your passwords."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked.toggle()
                } else {
                    print("Error unlocking")
                }
            }
        } else {
            print("No biometrics")
        }
    }
}

#Preview {
    HomeView()
}
