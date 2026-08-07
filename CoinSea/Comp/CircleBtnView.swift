//
//  CircleBtnView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/14.
//

import SwiftUI

struct CircleBtnView: View {
    var iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .frame(width: 50, height: 50)
            .foregroundStyle(Color.myActPrimary)
            .background(
                Circle()
                    .foregroundStyle(Color.myBgPrimary)
                    .shadow(color: Color.myActPrimary.opacity(0.1), radius: 10)
            )
    }
}

#Preview {
    VStack {
        CircleBtnView(iconName: "info")
        
        CircleBtnView(iconName: "plus")
            .modifier(XModiTheme())
    }
}

