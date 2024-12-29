//
//  ClosingSoonView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/2/24.
//

import SwiftUI

struct ClosingSoonView: View {
    
    var model: AnnouncementModel
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .frame(width: 8.adjusted, height: 118.adjustedH)
                .foregroundStyle(Color(UIColor(hex: model.color ?? "#ED4E54")))
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.body5)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    CompanyProfileView(companyImage: model.companyImage, companyName: model.companyInfo ?? "")
                    
                    Spacer()
                    
                    DdayView(date: model.dDay)
                    
                }
            }.padding(EdgeInsets(top: 16.adjustedH, leading: 0, bottom: 12.adjustedH, trailing: 12.adjusted))
        }.frame(width: 246.adjusted, height: 116.adjustedH)
            .background(.white)
            .cornerRadius(5)
            .shadow(
                color: Color(red: 0.88, green: 0.88, blue: 0.88, opacity: 1), radius: 4
            )
    }
}

//#Preview {
//    ClosingSoonView(model: upcomingCard)
//}

#Preview {
    MainHomeView(jobList: upcomingCardLists)
}

// 회사 사진, 이름 View
struct CompanyProfileView: View {
    
    var companyImage: String
    var companyName: String
    
    var body: some View {
        HStack(spacing: 6) {
            RemoteImageView(urlString: companyImage)
                .frame(width: 32, height: 32)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 0.50)
                        .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 0.50)
                )
            
            Text(companyName)
                .font(.button5)
                .foregroundStyle(.grey500)
                .lineLimit(1)
            
        }
    }
}

// 데드라인 View
struct DdayView: View {
    var date: String
    
    var body: some View {
        HStack {
            Text(date)
                .font(.body4)
                .foregroundColor(.terningMain)
        }
        .frame(width: 52.adjusted, height: 20.adjustedH)
        .background(.terningSub3)
        .cornerRadius(5)
    }
}

var upcomingCard: AnnouncementModel = AnnouncementModel(
    internshipAnnouncementId: 61,
    companyImage: "https://media-cdn.linkareer.com/activity_manager/logos/409527",
    dDay: "D-DAY",
    title: "[대학내일] 마케팅(AE)_익스피리언스플래닝4팀_인턴(체험형)",
    workingPeriod: "6개월",
    isScrapped: true,
    color: "#F3A649",
    deadline: "2024년 9월 19일",
    startYearMonth: "2024년 10월",
    companyInfo: "대학내일"
)
