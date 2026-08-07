//
//  AboutView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/6/2.
//

import SwiftUI

struct AboutView: View {
    var tUrl: URL = URL(string: "https://docs.github.com/site-policy/github-terms")!
    var pUrl: URL = URL(string: "https://docs.github.com/site-policy/privacy-policies")!
    
    var body: some View {
        NavigationStack {
            List {
                extOverview()
                
                extAdditional()
            }
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ImgBtnView()
                }
            }
        }
    }
}

#Preview {
    AboutView()
}

extension AboutView {
    @ViewBuilder
    private func extOverview() -> some View {
        Section {
            VStack {
                Image("AppImg")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .isRounded(20)
                Text("Built with MVVM Architecture and SwiftData, following an expert-led YouTuber course.")
                    .font(.callout.bold())
                    .foregroundStyle(Color.myActPrimary)
            }
            .padding(.vertical)
            Group {
                Link("Terms of Service", destination: tUrl)
                Link("Privacy Policy", destination: pUrl)
            }
            .font(.caption.bold())
            .foregroundStyle(Color.myActBlue)
        } header: {
            Text("Overview")
        }
    }
    
    @ViewBuilder
    private func extAdditional() -> some View {
        Section {
            VStack {
                Image("AppCoin")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                Text("Cryptocurrency data provided by CoinGecko's free API. Prices may be slightly delayed.")
                    .font(.callout.bold())
                    .foregroundStyle(Color.myActPrimary)
            }
            .padding(.vertical)
            Group {
                Link("Terms of Service", destination: tUrl)
                Link("Privacy Policy", destination: pUrl)
            }
            .font(.caption.bold())
            .foregroundStyle(Color.myActBlue)
        } header: {
            Text("Additional")
        }
    }
}
