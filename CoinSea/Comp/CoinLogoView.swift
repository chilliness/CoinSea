//
//  CoinLogoView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/26.
//

import SwiftUI

struct CoinLogoView: View {
    @State var coin: CoinMod
    
    var body: some View {
        VStack {
            CoinImgView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.myActPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.myTextSecondary)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    VStack {
        CoinLogoView(coin: XPreview.dev.coin)
        
        CoinLogoView(coin: XPreview.dev.coin)
            .modifier(XModiTheme())
    }
}
