//
//  DetailView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/6/1.
//

import SwiftUI

struct DetailView: View {
    @State var vm: DetailViewModel
    @State var showMore: Bool = false
    
    var cols: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(coin: CoinModel) {
        _vm = State(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChartView(coin: vm.coin)
                    .frame(height: 150)
                    .padding(.vertical, 30)
                
                extGrid(title: "Overview", data: vm.overStats)
                
                extGrid(title: "Additional Details", data: vm.addiStats)
                
                extLinks()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundStyle(Color.myTextSecondary)
                    CoinImgView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailView(coin: XPreview.dev.coin)
    }
}

extension DetailView {
    @ViewBuilder
    private func extDesc() -> some View {
        if let coinDesc = vm.coinDesc, !coinDesc.isEmpty {
            VStack(alignment: .leading) {
                Text(coinDesc)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.myTextSecondary)
                    .lineLimit(showMore ? nil : 2)
                
                Button {
                    withAnimation {
                        showMore.toggle()
                    }
                } label: {
                    Text(showMore ? "Less" : "Read more...")
                        .font(.caption.bold())
                        .foregroundStyle(Color.myActBlue)
                        .padding(.vertical, 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private func extGrid(title: String, data: [StatModel]) -> some View {
        Text(title)
            .font(.title.bold())
            .foregroundStyle(Color.myActPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
        Divider()
        
        extDesc()
            .isPresented(title.starts(with: "Over"))
        
        LazyVGrid(columns: cols, alignment: .leading, spacing: 30) {
            ForEach(data) { item in
                StatView(stat: item)
            }
        }
    }
    
    @ViewBuilder
    private func extLinks() -> some View {
        HStack(spacing: 30) {
            if let webUrl = vm.webUrl, let url = URL(string: webUrl) {
                Link("Website", destination: url)
            }
            
            if let redUrl = vm.redUrl, let url = URL(string: redUrl) {
                Link("Reddit", destination: url)
            }
        }
        .font(.headline)
        .foregroundStyle(Color.myActBlue)
    }
}
