//
//  SearchBarView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/20.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var keyStr: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(keyStr.isEmpty ? Color.myTextSecondary : Color.myActPrimary)
            TextField("type your content", text: $keyStr)
                .foregroundStyle(Color.myActPrimary)
                .padding(.trailing, 40)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .overlay(alignment: .trailing) {
                    if !keyStr.isEmpty {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.myActPrimary)
                            .padding()
                            .offset(x: 10)
                            .onTapGesture {
                                keyStr = ""
                                UIApplication.shared.handleEnd()
                            }
                    }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.myBgPrimary)
                .shadow(color: Color.myActPrimary.opacity(0.1), radius: 10)
        )
        .padding()
    }
}

#Preview {
    VStack {
        SearchBarView(keyStr: .constant(""))
        
        SearchBarView(keyStr: .constant(""))
            .modifier(XModiTheme())
    }
}

