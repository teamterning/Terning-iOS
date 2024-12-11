//
//  MainHomeTitleView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/2/24.
//

import SwiftUI

struct MainHomeLogoView: View {    
    var body: some View {
        HStack {
            Image(.homeLogo)
                .padding(.leading, 24)
                .frame(maxHeight: .infinity, alignment: .center)
            Spacer()
        }.frame(height: 52, alignment: .center)
    }
}

#Preview {
    MainHomeLogoView()
}
