//
//  FilterButtonView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/11/24.
//

import SwiftUI

struct FilterButtonView: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(.icFilter)
            
            Text("필터링")
                .font(.button3)
                .foregroundStyle(.terningMain)
            
        }.padding(EdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 9))
            .frame(width: 80.adjusted, height: 30.adjustedH)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .inset(by: 0.50)
                    .stroke(.terningMain)
            )
    }
}

#Preview {
    FilterButtonView()
}
