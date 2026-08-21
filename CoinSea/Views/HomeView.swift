//
//  HomeView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/14.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(HomeViewModel.self) var vm
    @AppStorage("themes") var themes: Themes = .dark
    
    @State var showPort: Bool = false
    @State var showEdit: Bool = false
    @State var showInfo: Bool = false
    
    @Query(sort: \PortfolioModel.id) var portfolioList: [PortfolioModel]
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            
            VStack {
                extHeader()
                
                MarketView(showFlag: $showPort)
                
                SearchBarView(keyStr: Bindable(vm).keyStr)
                
                extCaption()
                
                if !showPort {
                    Group {
                        if vm.allCoins.isEmpty && vm.keyStr.isEmpty {
                            extInitTips()
                        } else {
                            extCoinList(data: vm.allCoins)
                        }
                    }
                    .transition(.move(edge: .leading))
                } else {
                    Group {
                        if vm.portfolioCoins.isEmpty && vm.keyStr.isEmpty {
                            extTodoTips()
                        } else {
                            extCoinList(data: vm.portfolioCoins)
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            CircleBtnView(iconName: themes == .dark ? "sun.min.fill" : "moon.fill")
                .offset(x: -16)
                .onTapGesture {
                    themes = themes == .dark ? .light : .dark
                }
        }
        .onChange(of: portfolioList, initial: true) { _, newValue in
            vm.portfolioModel = newValue
        }
        .sheet(isPresented: $showEdit) {
            PortView()
                .environment(vm)
        }
        .sheet(isPresented: $showInfo) {
            AboutView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
    }
    .environment(XPreview.dev.homeVm)
}

extension HomeView {
    @ViewBuilder
    private func extHeader() -> some View {
        HStack {
            CircleBtnView(iconName: showPort ? "plus" : "info")
                .animation(.none, value: showPort)
                .onTapGesture {
                    !showPort ? showInfo.toggle() : showEdit.toggle()
                }
            Spacer()
            Text(showPort ? "Portfolio" : "Live Price")
                .font(.headline)
                .fontWeight(.heavy)
                .animation(.none, value: showPort)
            Spacer()
            CircleBtnView(iconName: "chevron.right")
                .rotationEffect(.degrees(showPort ? 180 : 0))
                .animation(.spring, value: showPort)
                .onTapGesture {
                    withAnimation(.spring) { showPort.toggle() }
                }
        }
        .padding()
    }
    
    @ViewBuilder
    private func extCaption() -> some View {
        Grid {
            GridRow {
                HStack {
                    Group {
                        Image(systemName: "chevron.down")
                            .opacity([.rank, .rankDesc].contains(vm.sortOption) ? 1 : 0)
                            .rotationEffect(.degrees(vm.sortOption != .rank ? 0 : -180))
                            .animation(.default, value: vm.sortOption)
                        Text("Coin")
                    }
                    .onTapGesture {
                        vm.sortOption = vm.sortOption != .rank ? .rank : .rankDesc
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("Holdings")
                        .padding(.trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .opacity(showPort ? 1 : 0)
                HStack {
                    Group {
                        Image(systemName: "chevron.down")
                            .opacity([.price, .priceDesc].contains(vm.sortOption) ? 1 : 0)
                            .rotationEffect(.degrees(vm.sortOption == .price ? 0 : -180))
                            .animation(.default, value: vm.sortOption)
                        Text("Price")
                    }
                    .onTapGesture {
                        vm.sortOption = vm.sortOption != .price ? .price : .priceDesc
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
        }
        .font(.subheadline)
        .padding(.horizontal)
        .foregroundStyle(Color.myTextSecondary)
    }
    
    @ViewBuilder
    private func extCoinList(data: [CoinModel]) -> some View {
        List {
            ForEach(data) { item in
                NavigationLink(value: item) {
                    CoinRowView(coin: item, isShowCol: showPort)
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: CoinModel.self) { item in
            DetailView(coin: item)
        }
        .refreshable {
            await vm.handleReload()
        }
    }
    
    @ViewBuilder
    private func extInitTips() -> some View {
        VStack(spacing: 40) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(Color.myActPrimary)
                .symbolEffect(.bounce)
            
            Text("Getting everything ready...")
                .font(.headline)
                .foregroundStyle(Color.myActPrimary)
        }
        .padding(40)
    }
    
    @ViewBuilder
    private func extTodoTips() -> some View {
        VStack(spacing: 40) {
            Image(systemName: "tray.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.myActPrimary)
            
            Text("Ready to add your crypto holdings? Just tap the '+' button in the top-left corner.")
                .font(.headline)
                .foregroundStyle(Color.myActPrimary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}
