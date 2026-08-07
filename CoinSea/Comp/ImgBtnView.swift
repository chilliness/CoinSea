//
//  ImgBtnView.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/26.
//

import SwiftUI

struct ImgBtnView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Image(systemName: "xmark")
            .font(.headline)
            .onTapGesture {
                dismiss()
            }
    }
}

#Preview {
    ImgBtnView()
}
