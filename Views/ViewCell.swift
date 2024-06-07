//
//  CredentialViewCell.swift
//  PasswordManager
//
//  Created by Lochan on 07/06/24.
//

import SwiftUI

struct ViewCell: View {
    @State var account: String
    var body: some View {
        HStack {
            Text(account)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.black.opacity(0.3))
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .frame(width: getWidth() - 32)
    }
}

#Preview {
    ViewCell(account: "Instagram")
}
