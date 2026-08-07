//
//  ChartView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/6/2.
//

import SwiftUI

struct ChartView: View {
    @State var percent: CGFloat = 0
    
    var data: [Double]
    var maxY: Double
    var minY: Double
    var lineColor: Color
    var eDate: Date
    var sDate: Date
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        self.lineColor = (data.last ?? 0) - (data.first ?? 0) > 0 ? Color.myActGreen : Color.myActRed
        self.eDate = Date(utcDate: coin.lastUpdated ?? "")
        self.sDate = eDate.addingTimeInterval(-7 * 24 * 3600)
    }
    
    var body: some View {
        VStack {
            extChart()
                .frame(height: 200)
                .background(extBgLine())
                .overlay(alignment: .leading) {
                    extYAxis()
                }
            extXDate()
        }
        .font(.caption)
        .foregroundStyle(Color.myTextSecondary)
        .task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation(.linear(duration: 2)) { percent = 1 }
        }
    }
}

#Preview {
    ChartView(coin: XPreview.dev.coin)
}

extension ChartView {
    @ViewBuilder
    private func extChart() -> some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    let xPos = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPos = (1 - (data[index] - minY) / yAxis) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPos, y: yPos))
                    } else {
                        path.addLine(to: CGPoint(x: xPos, y: yPos))
                    }
                }
            }
            .trim(from: 0, to: percent)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    @ViewBuilder
    private func extBgLine() -> some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    @ViewBuilder
    private func extYAxis() -> some View {
        VStack {
            Text(maxY.asWithAbbr())
            Spacer()
            Text(((maxY + minY) / 2).asWithAbbr())
            Spacer()
            Text(minY.asWithAbbr())
        }
    }
    
    @ViewBuilder
    private func extXDate() -> some View {
        HStack {
            Text(sDate.asShortString())
            Spacer()
            Text(eDate.asShortString())
        }
    }
}
