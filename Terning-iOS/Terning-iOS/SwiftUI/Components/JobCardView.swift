//
//  JobCardView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/7/24.
//

import SwiftUI

struct jobCardView: View {
    var model: AnnouncementModel
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 8.adjusted) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 76.adjusted, height: 76.adjusted)
                        .background(Color(red: 0.87, green: 0.87, blue: 0.87))
                        .cornerRadius(5)
                    
                    VStack(alignment: .leading, spacing: 4.adjusted) {                    Text(model.dDay)
                            .font(.detail0)
                            .foregroundStyle(.terningMain)
                        
                        Text(model.title)
                            .font(.title5)
                            .frame(width: 219.adjusted, height: 36.adjustedH, alignment: .topLeading)
                        
                        HStack(spacing: 4.adjusted) {
                            Text("근무기간")
                                .font(.detail3)
                                .foregroundStyle(.grey400)
                            
                            Text(model.workingPeriod)
                                .font(.detail3)
                                .foregroundStyle(.terningMain)
                            
                        }.padding(.top, 4.adjusted)
                        
                    }
                    
                }
                .frame(width: 303.adjusted, height: 78.adjustedH)
                .background(.white)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 10, trailing: 12))
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ScrapButton(isScrap: model.isScrapped)
                    }
                }.padding(12)
            }
            
        }.frame(width: 327.adjusted, height: 100.adjustedH)
            .background(.white)
            .cornerRadius(10)
            .shadow(
                color: Color(red: 0.88, green: 0.88, blue: 0.88, opacity: 1), radius: 4
            )
    }
}

let dummyAnnouncement = AnnouncementModel(
    internshipAnnouncementId: 101,
    companyImage: "https://example.com/company_logo.png",
    dDay: "D-5",
    title: "[Someone] 콘텐츠 마케터 대학생 인턴 채용",
    workingPeriod: "3개월",
    isScrapped: true,
    color: "#FF5733",
    deadline: "2024-12-31",
    startYearMonth: "2024-12",
    companyInfo: "국내 최대 디자인 전문 기업으로, UI/UX 분야에 강점을 가지고 있습니다."
)
let dummyAnnouncement2 = AnnouncementModel(
    internshipAnnouncementId: 101,
    companyImage: "https://example.com/company_logo.png",
    dDay: "D-5",
    title: "[Someone] 콘텐츠 마케터 대학생 인턴 채용",
    workingPeriod: "6개월",
    isScrapped: false,
    color: "#FF5733",
    deadline: "2024-12-31",
    startYearMonth: "2024-12",
    companyInfo: "국내 최대 디자인 전문 기업으로, UI/UX 분야에 강점을 가지고 있습니다."
)

struct ScrapButton: View {
    @State var isScrap: Bool = false
    
    var body: some View {
        Button {
            isScrap.toggle()
        } label: {
            Image(isScrap ? .icScrapFill : .icScrap)
        }
    }
}

#Preview {
    MainHomeView(jobList: upcomingCardLists)
}
