//
//  CoinImgView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/19.
//

import SwiftUI

struct CoinImgView: View {
    @State var vm: CoinImgViewModel
    
    init(coin: CoinModel) {
        self._vm = State(wrappedValue: CoinImgViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let img = vm.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.myTextSecondary)
            }
        }
        .task {
            await vm.handleDll()
        }
    }
}

#Preview {
    VStack {
        CoinImgView(coin: XPreview.dev.coin)
        
        CoinImgView(coin: XPreview.dev.coin)
            .modifier(XModiTheme())
    }
}
