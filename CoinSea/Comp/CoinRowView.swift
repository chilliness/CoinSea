//
//  CoinRowView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/18.
//

import SwiftUI

struct CoinRowView: View {
    var coin: CoinMod
    var isShowCol: Bool
    
    var body: some View {
        Grid {
            GridRow {
                extLeftCol()
                    .frame(maxWidth: .infinity, alignment: .leading)
                extCenterCol()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .opacity(isShowCol ? 1 : 0)
                extRightCol()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    VStack {
        CoinRowView(coin: XPreview.dev.coin, isShowCol: true)
        
        CoinRowView(coin: XPreview.dev.coin, isShowCol: true)
            .modifier(XModiTheme())
    }
}

extension CoinRowView {
    @ViewBuilder
    private func extLeftCol() -> some View {
        HStack(spacing: 6) {
            CoinImgView(coin: coin)
                .frame(width: 30, height: 30)
                .overlay(alignment: .bottom) {
                    Text("\(coin.rank)")
                        .font(.footnote.bold())
                        .foregroundStyle(Color.myTextSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .offset(y: 15)
                }
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.myActPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
        }
    }
    
    @ViewBuilder
    private func extCenterCol() -> some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.myActPrimary)
    }
    
    @ViewBuilder
    private func extRightCol() -> some View {
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                .bold()
                .foregroundStyle(Color.myActPrimary)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.myActGreen : Color.myActRed)
        }
    }
}


