//
//  PortView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/26.
//

import SwiftUI
import SwiftData

struct PortView: View {
    @Environment(HomeViewModel.self) var vm
    @Environment(\.modelContext) var modelContext
    
    @State var selectCoin: CoinModel?
    @State var query: String = ""
    @State var num: String = ""
    @State var showFlag: Bool = false
    
    @Query(sort: \PortfolioModel.id) var portfolioList: [PortfolioModel]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(keyStr: $query)
                        .onChange(of: query) { oldValue, newValue in
                            guard newValue.isEmpty else { return }
                            handleRemove()
                        }
                    
                    extCoinLogoList()
                    
                    extCoinInfo()
                        .isPresented(selectCoin != nil)
                }
            }
            .navigationTitle("Edit portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ImgBtnView()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Group {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.myActGreen)
                            .isPresented(showFlag)
                        
                        Text("Save".uppercased())
                            .padding(.horizontal)
                            .isPresented(handleFlag())
                            .onTapGesture {
                                handleSave()
                            }
                    }
                }
            }
        }
        .task(id: showFlag) {
            guard showFlag else { return }
            
            try? await Task.sleep(for: .seconds(1))
            withAnimation { showFlag = false }
        }
    }
}

#Preview {
    PortView()
        .environment(XPreview.dev.homeVm)
}

@MainActor
extension PortView {
    @ViewBuilder
    private func extCoinLogoList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.handleFilter(with: query)) { item in
                    CoinLogoView(coin: item)
                        .frame(width: 75)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectCoin?.id != item.id ? .gray.opacity(0.3) : Color.myActGreen, lineWidth: 2)
                        )
                        .animation(.default, value: selectCoin?.id)
                        .onTapGesture {
                            selectCoin = item
                            if let amount = item.currentHoldings, amount > 0 {
                                num = "\(amount)"
                            } else {
                                num = ""
                            }
                        }
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    @ViewBuilder
    private func extCoinInfo() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Coin:")
                Spacer()
                Text(selectCoin?.symbol.uppercased() ?? "")
            }
            Divider()
            HStack {
                Text("Price:")
                Spacer()
                Text(selectCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount:")
                Spacer()
                TextField("Ex: 1.4", text: $num)
                    .foregroundStyle(Color.myActGreen)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Total:")
                Spacer()
                Text(handleGetValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private func handleGetValue() -> Double {
        return (Double(num) ?? 0) * (selectCoin?.currentPrice ?? 0)
    }
    
    private func handleFlag() -> Bool {
        guard selectCoin != nil , let amount = Double(num), amount >= 0 else { return false }
        
        return true
    }
    
    private func handleSave() {
        guard let coin = selectCoin, let amount = Double(num), amount >= 0 else { return }
        
        if let target = portfolioList.first(where: { $0.id == coin.id }) {
            if amount > 0 {
                target.amount = amount
            } else {
                modelContext.delete(target)
            }
        } else {
            modelContext.insert(PortfolioModel(id: coin.id, amount: amount))
        }
        
        withAnimation { showFlag = true }
        handleRemove()
    }
    
    private func handleRemove() {
        num = ""
        selectCoin = nil
        UIApplication.shared.handleEnd()
        if !query.isEmpty {
            query = ""
        }
    }
}
