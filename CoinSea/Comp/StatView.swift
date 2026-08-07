//
//  StatView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/21.
//

import SwiftUI

struct StatView: View {
    var stat: StatModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.myTextSecondary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.myActPrimary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(.degrees((stat.percent ?? 0) >= 0 ? 0 : 180))
                Text(stat.percent?.asPercentString() ?? "")
                    .font(.caption.bold())
            }
            .foregroundStyle((stat.percent ?? 0) >= 0 ? Color.myActGreen : Color.myActRed)
            .opacity(stat.percent == nil ? 0 : 1)
        }
    }
}

#Preview {
    VStack {
        StatView(stat: XPreview.dev.stat1)
        
        StatView(stat: XPreview.dev.stat2)
        
        StatView(stat: XPreview.dev.stat3)
            .modifier(XModiTheme())
    }
}
