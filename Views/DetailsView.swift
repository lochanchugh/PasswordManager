//
//  CredentialDetailView.swift
//  PasswordManager
//
//  Created by Lochan on 07/06/24.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    var credential: Credentials
    @State var passVisible = false
    @State private var eyeName = "eye.slash"
    @State private var isSheetPresented = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    var keychainManager: KeychainController = KeychainController()
    var body: some View {
        ZStack {
            Color("background2")
            VStack(alignment: .leading) {
                Text("Account Details")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.blue)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 24, trailing: 0))
                
                Text("Account Type")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("gray1"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                Text(credential.account)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))

                Text("Username/Email")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("gray1"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))

                Text(credential.username)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))

                Text("Password")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("gray1"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                HStack {
                    if passVisible {
                        Text(credential.password)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    } else {
                        Text("*********")
                            .font(.system(size: 16))
                            .fontWeight(.medium)

                    }
                    Spacer()
                    Image(systemName: eyeName)
                        .foregroundStyle(Color.black.opacity(0.3))
                        .offset(y: -16)
                        .onTapGesture {
                            passVisible.toggle()
                            if passVisible {
                                credential.password = keychainManager.decryptData(data: credential.password)
                                print(credential.password)
                                eyeName = "eye"
                            } else {
                                credential.password = keychainManager.encryptData(password: credential.password)
                                print(credential.password)
                                eyeName = "eye.slash"
                            }
                        }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
                HStack {
                    Button("Edit") {
                        isSheetPresented.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .bold()
                    .foregroundColor(.white)
                    .background(Color("appBlack"))
                    .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                    Spacer()
                    Button("Delete") {
                        deleteData(data: credential)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .bold()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))

                }
                .frame(width: getWidth() - 32)
                
            }
            .frame(width: getWidth() - 32, alignment: .leading)
            .sheet(isPresented: $isSheetPresented) {
                InputView(credential: credential, buttonType: "Save Account")
                    .presentationDetents([.medium, .large])
            }

        }
    }
    
    func deleteData(data: Credentials) {
        context.delete(data)
    }
}

#Preview {
    DetailsView(credential: Credentials(account: "sample", username: "sample", password: "sample"))
}
