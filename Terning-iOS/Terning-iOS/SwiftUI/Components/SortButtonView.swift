//
//  SortButtonView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/11/24.
//

import SwiftUI

struct SortButtonView: View {
    
    @State var sortName: String = "채용 마감 이른순"
    
    var body: some View {
        HStack(spacing: 3) {
            Image(.icUnderArrow)
            
            Text(sortName)
                .font(.button3)
                .foregroundStyle(.grey350)
        }.padding(EdgeInsets(top: 0, leading: 6.adjusted, bottom: 0, trailing: 10.adjusted))
            .frame(width: 131.adjusted, height: 30.adjustedH)
            .cornerRadius(5)
            .overlay(
            RoundedRectangle(cornerRadius: 5)
            .inset(by: 0.50)
            .stroke(Color(red: 0.68, green: 0.68, blue: 0.68), lineWidth: 0.50)
            )
    }
}

#Preview {
    SortButtonView()
}
