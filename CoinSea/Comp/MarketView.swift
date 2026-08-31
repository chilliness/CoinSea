//
//  MarketView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/21.
//

import SwiftUI

struct MarketView: View {
    @Environment(HomeViewModel.self) var vm
    
    @Binding var showFlag: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(vm.statList.enumerated()), id: \.element.id) { i, item in
                StatView(stat: item)
                    .containerRelativeFrame(.horizontal, count: 3, spacing: 0)
            }
        }
        .containerRelativeFrame(.horizontal, count: 1, spacing: 0, alignment: showFlag ? .trailing : .leading)
    }
}

#Preview {
    VStack {
        MarketView(showFlag: .constant(false))
        
        MarketView(showFlag: .constant(true))
            .modifier(XModiTheme())
    }
    .environment(XPreview.dev.homeVm)
}
