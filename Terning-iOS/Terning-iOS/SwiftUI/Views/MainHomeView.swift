//
//  MainHomeView.swift
//  Terning-iOS
//
//  Created by 이명진 on 12/2/24.
//

import SwiftUI
import UIKit

struct MainHomeView: View {
    
    // MARK: - Propreties

    @State var jobList: UpcomingCardModel
    @State private var isSticky: Bool = false // 스티키 상태 관리
    @State private var isBottomSheetPresented: Bool = false // 바텀시트 표시 여부
    
    private let shadowConstant: CGFloat = 120
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            VStack {
                // 상단 로고
                MainHomeLogoView()
                
                // ScrollView로 콘텐츠 영역
                ScrollView {
                    VStack(spacing: 0) {
                        // "곧 마감되는 관심 공고"
                        HStack {
                            Text("곧 마감되는 관심 공고")
                                .font(.title1)
                                .padding(.leading, 24)
                                .lineLimit(2)
                            Spacer()
                        }
                        .frame(height: 24) // 명시적으로 높이를 설정
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                        
                        // 가로 스크롤 섹션
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(jobList.scraps, id: \.internshipAnnouncementId) { scrap in
                                    Button(action: {
                                        self.navigateToDetailViewController(scrapModel: scrap)
                                    }) {
                                        ClosingSoonView(model: scrap)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // 스티키 헤더로 설정할 뷰
                        LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                            Section(header: StickyHeaderView(isSticky: $isSticky, isBottomSheetPresented: $isBottomSheetPresented)) {
                                // 나머지 콘텐츠
                                LazyVStack(spacing: 16) {
                                    ForEach(0..<8, id: \.self) { index in
                                        jobCardView(model: jobCardLists[index])
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .global).minY) { newY in
                                        isSticky = newY <= shadowConstant // 스크롤 위치를 감지
                                    }
                            }
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $isBottomSheetPresented, onDismiss: didDismiss) {
            BottomSheetView(isPresented: $isBottomSheetPresented)
        }
    }
    
    func didDismiss() {
        print("시트 닫을때 호출 됩니다.")
    }
    
    // MARK: - Methods
    
    private func navigateToDetailViewController(scrapModel: AnnouncementModel) {
        print(scrapModel.internshipAnnouncementId)
        let jobDetailVC = JobDetailViewController(
            viewModel: JobDetailViewModel(
                jobDetailRepository: JobDetailRepository(
                    scrapService: ScrapsService(
                        provider: Providers.scrapsProvider
                    )
                )
            )
        )
        
        jobDetailVC.internshipAnnouncementId.accept(scrapModel.internshipAnnouncementId)
        jobDetailVC.hidesBottomBarWhenPushed = true
        
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.findNavigationController()?.pushViewController(jobDetailVC, animated: true)
        }
    }
}

// 예시 BottomSheetView
struct BottomSheetView: View {
    @Binding var isPresented: Bool // 바텀시트 상태 전달
    
    var body: some View {
        VStack {
            Text("바텀시트 내용")
                .font(.title)
                .padding(.bottom, 20)
            
            Button("닫기") {
                isPresented.toggle()
                print(isPresented)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

// 스티키 헤더 컴포넌트
struct StickyHeaderView: View {
    @Binding var isSticky: Bool // 외부에서 상태를 전달받도록 수정
    @Binding var isBottomSheetPresented: Bool
    
    var body: some View {
        ZStack {
            // 헤더 콘텐츠
            VStack(spacing: 0) {
                MainTitleView(userName: "이명진")
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))
                
                HStack {
                    Text("총 182개")
                        .font(.button3)
                        .foregroundStyle(.grey400)
                        .padding(.trailing, 54)
                    
                    Button(action: {
                        isBottomSheetPresented.toggle()
                    }) {
                        SortButtonView()
                    }
                    
                    FilterButtonView()
                }
                .padding(.horizontal, 24)
            }
            .background(Color.white) // 기본 배경
            
            // 헤더 바로 아래 그림자 이미지
            if isSticky {
                Image(.gradationBar)
                    .offset(y: 61.adjustedH)
            }
        }
    }
}

struct DetailView: View {
    let scrap: AnnouncementModel
    
    var body: some View {
        VStack {
            Text("Detail View")
                .font(.largeTitle)
                .padding()
            Text("Internship ID: \(scrap.internshipAnnouncementId)")
            Text("Internship Title: \(scrap.title)")
            
        }
        .padding()
        
    }
}

#Preview {
    MainHomeView(jobList: upcomingCardLists)
}

struct MainTitleView: View {
    
    var userName: String = ""
    
    var body: some View {
        HStack {
            Text(formattedTitle)
                .font(.title1)
                .padding(.leading, 24)
                .lineLimit(2)
            
            Spacer()
        }
        .frame(height: userName.count > 6 ? 48 : 24) // 명시적으로 높이를 설정
    }
    
    private var formattedTitle: String {
        if userName.count > 6 {
            return "\(userName)님에게 \n딱 맞는 대학생 인턴 공고"
        } else {
            return "\(userName)님에게 딱 맞는 대학생 인턴 공고"
        }
    }
}

extension UIViewController {
    func findNavigationController() -> UINavigationController? {
        if let navigationController = self as? UINavigationController {
            return navigationController
        }
        for child in children {
            if let navigationController = child.findNavigationController() {
                return navigationController
            }
        }
        return nil
    }
}

// 곧 마감되는 공고

var upcomingCardLists: UpcomingCardModel = UpcomingCardModel(
    hasScrapped: true,
    scraps: [
        AnnouncementModel(
            internshipAnnouncementId: 61,
            companyImage: "https://bit.ly/47cx4Mi",
            dDay: "D-DAY",
            title: "[대학내일] 마케팅(AE)_익스피리언스플래닝4팀_인턴(체험형)",
            workingPeriod: "6개월",
            isScrapped: true,
            color: "#F3A649",
            deadline: "2024년 9월 19일",
            startYearMonth: "2024년 10월",
            companyInfo: "대학내일"
        ),
        AnnouncementModel(
            internshipAnnouncementId: 62,
            companyImage: "https://bit.ly/3AU2Em7",
            dDay: "D-2",
            title: "[비나우] 글로벌 마케팅 인턴",
            workingPeriod: "3개월",
            isScrapped: true,
            color: "#84D558",
            deadline: "2024년 9월 21일",
            startYearMonth: "2024년 10월",
            companyInfo: "비나우"
        ),
        AnnouncementModel(
            internshipAnnouncementId: 58,
            companyImage: "https://tinyurl.com/msty9a6v",
            dDay: "D-4",
            title: "[링글잉글리시에듀케이션서비스] Ringle Tutor-Product Team 글로벌 사업 운영 인턴",
            workingPeriod: "6개월",
            isScrapped: true,
            color: "#F260AC",
            deadline: "2024년 9월 23일",
            startYearMonth: "2024년 10월",
            companyInfo: "링글잉글리시에듀케이션서비스"
        ),
        AnnouncementModel(
            internshipAnnouncementId: 58,
            companyImage: "https://tinyurl.com/msty9a6v",
            dDay: "D-4",
            title: "[링글잉글리시에듀케이션서비스] Ringle Tutor-Product Team 글로벌 사업 운영 인턴",
            workingPeriod: "6개월",
            isScrapped: true,
            color: "#F260AC",
            deadline: "2024년 9월 23일",
            startYearMonth: "2024년 10월",
            companyInfo: "링글잉글리시에듀케이션서비스"
        ),
        AnnouncementModel(
            internshipAnnouncementId: 58,
            companyImage: "https://tinyurl.com/msty9a6v",
            dDay: "D-4",
            title: "[링글잉글리시에듀케이션서비스] Ringle Tutor-Product Team 글로벌 사업 운영 인턴",
            workingPeriod: "6개월",
            isScrapped: true,
            color: "#F260AC",
            deadline: "2024년 9월 23일",
            startYearMonth: "2024년 10월",
            companyInfo: "링글잉글리시에듀케이션서비스"
        )
    ]
)

// 전체 공고

var jobCardLists: [AnnouncementModel] = [AnnouncementModel(
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
), AnnouncementModel(
    internshipAnnouncementId: 101,
    companyImage: "https://example.com/company_logo.png",
    dDay: "D-5",
    title: "UX/UI 디자이너 인턴 모집",
    workingPeriod: "3개월",
    isScrapped: true,
    color: "#FF5733",
    deadline: "2024-12-31",
    startYearMonth: "2024-12",
    companyInfo: "국내 최대 디자인 전문 기업으로, UI/UX 분야에 강점을 가지고 있습니다."
), AnnouncementModel(
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
), AnnouncementModel(
    internshipAnnouncementId: 101,
    companyImage: "https://example.com/company_logo.png",
    dDay: "D-5",
    title: "UX/UI 디자이너 인턴 모집",
    workingPeriod: "3개월",
    isScrapped: true,
    color: "#FF5733",
    deadline: "2024-12-31",
    startYearMonth: "2024-12",
    companyInfo: "국내 최대 디자인 전문 기업으로, UI/UX 분야에 강점을 가지고 있습니다."
), AnnouncementModel(
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
), AnnouncementModel(
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
), AnnouncementModel(
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
), AnnouncementModel(
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
)]
