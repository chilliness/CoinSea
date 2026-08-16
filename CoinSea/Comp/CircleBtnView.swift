//
//  CircleBtnView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/14.
//

import SwiftUI

struct CircleBtnView: View {
    @State var scale: CGFloat = 0.8
    
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
                        .scaleEffect(scale)
                        .isPresented(iconName == "plus")
                        .task {
                            withAnimation(.linear(duration: 0.6).repeatCount(3, autoreverses: false)) {
                                scale = 1.2
                            } completion: {
                                scale = 0.8
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

