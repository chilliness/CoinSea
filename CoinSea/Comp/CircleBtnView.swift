//
//  CircleBtnView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/14.
//

import SwiftUI

struct CircleBtnView: View {
    @State var isAnim: Bool = false
    
    var iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .frame(width: 50, height: 50)
            .foregroundStyle(Color.myActPrimary)
            .background {
                ZStack {
                    Circle()
                        .stroke(.black.opacity(0.5), lineWidth: 1)
                        .scaleEffect(isAnim ? 1.2 : 0.8)
                        .isPresented(iconName == "plus")
                        .task {
                            withAnimation(.linear(duration: 0.6).repeatCount(3, autoreverses: false)) {
                                isAnim = true
                            } completion: {
                                isAnim = false
                            }
                        }
                    
                    Circle()
                        .foregroundStyle(Color.myBgPrimary)
                        .shadow(color: Color.myActPrimary.opacity(0.1), radius: 10)
                }
            }
    }
}

#Preview {
    VStack {
        CircleBtnView(iconName: "info")
        
        CircleBtnView(iconName: "plus")
            .modifier(XModiTheme())
    }
}

