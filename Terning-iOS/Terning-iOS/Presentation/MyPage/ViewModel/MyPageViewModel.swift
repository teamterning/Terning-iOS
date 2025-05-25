//
//  MyPageViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

import RxSwift
import RxCocoa

enum CellAction {
    case nonAction
    case showNotice
    case sendFeedback
    case showTermsOfUse
    case showPrivacyPolicy
}

final class MyPageViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    
    private let sectionsRelay = BehaviorRelay<[SectionData]>(value: [])
    let userInfoRelay = BehaviorRelay<UserProfileInfoModel>(value: UserProfileInfoModel(name: "회원", profileImage: "basic", authType: "UNKNOWN", pushStatus: "ENABLED"))
    
    private let info = Bundle.main.infoDictionary
    
    // MARK: - Input
    struct Input {
        let fixProfileTap: Observable<Void>
        let logoutTap: Observable<Void>
        let withdrawTap: Observable<Void>
        let itemSelected: Observable<SectionItem>
    }
    
    // MARK: - Output
    struct Output {
        let sections: Driver<[SectionData]>
        let navigateToProfileEdit: Driver<UserProfileInfoModel>
        let showLogoutAlert: Driver<Void>
        let showWithdrawAlert: Driver<Void>
        let cellTapped: Driver<CellAction>
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let navigateToProfileEdit = input.fixProfileTap
            .withLatestFrom(userInfoRelay.asObservable())
            .asDriver(onErrorJustReturn: UserProfileInfoModel(name: "", profileImage: "basic", authType: "", pushStatus: "DISABLED"))
        
        let showLogoutAlert = input.logoutTap.asDriver(onErrorJustReturn: ())
        let showWithdrawAlert = input.withdrawTap.asDriver(onErrorJustReturn: ())
        
        let cellTapped = input.itemSelected
            .map { sectionItem -> CellAction in
                switch sectionItem {
                case .userInfoViewModel:
                    return .nonAction
                case .cellViewModel(let cellModel):
                    switch cellModel.title {
                    case "공지사항": return .showNotice
                    case "의견 보내기": return .sendFeedback
                    case "서비스 이용약관": return .showTermsOfUse
                    case "개인정보 처리방침": return .showPrivacyPolicy
                    default: return .nonAction
                    }
                case .emptyCell:
                    return .nonAction
                }
            }
            .asDriver(onErrorJustReturn: .nonAction)
        
        // 1. 최초 기본 섹션 구성 (서버 호출 전)
        configureDefaultSections()
        // 2. 서버에서 실제 정보 반영
        fetchMyPageInfo()
        
        return Output(
            sections: sectionsRelay.asDriver(),
            navigateToProfileEdit: navigateToProfileEdit,
            showLogoutAlert: showLogoutAlert,
            showWithdrawAlert: showWithdrawAlert,
            cellTapped: cellTapped
        )
    }
    
    private func configureDefaultSections() {
        let version = info?["CFBundleShortVersionString"] as? String ?? ""
        let userInfo = userInfoRelay.value
        let isPushOn = userInfo.pushStatus == "ENABLED"
        
        let sections = [
            SectionData(
                title: "프로필",
                items: [.userInfoViewModel(userInfo)]
            ),
            SectionData(
                title: "터닝 커뮤니티",
                items: [
                    .cellViewModel(MyPageBasicCellModel(image: .icNotice, title: "공지사항", accessoryType: .disclosureIndicator)),
                    .cellViewModel(MyPageBasicCellModel(image: .icOpinion, title: "의견 보내기", accessoryType: .disclosureIndicator))
                ]
            ),
            SectionData(
                title: "서비스 정보",
                items: [
                    .cellViewModel(MyPageBasicCellModel(image: .icService, title: "서비스 이용약관", accessoryType: .disclosureIndicator)),
                    .cellViewModel(MyPageBasicCellModel(image: .icPersonal, title: "개인정보 처리방침", accessoryType: .disclosureIndicator)),
                    .cellViewModel(MyPageBasicCellModel(image: .icVersion, title: "버전 정보", accessoryType: .label(text: version)))
                ]
            ),
            SectionData(
                title: "알림 설정",
                items: [
                    .cellViewModel(
                        MyPageBasicCellModel(image: .icPushAlarm, title: "푸시 알림", accessoryType: .toggle(isOn: isPushOn, action: nil))
                    )
                ]
            ),
            SectionData(title: "기타", items: [.emptyCell])
        ]
        
        sectionsRelay.accept(sections)
    }
}

// MARK: - API

extension MyPageViewModel {
    func fetchMyPageInfo() {
        myPageProvider.request(.getProfileInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard (200..<300).contains(response.statusCode) else {
                    print("❌ API status: \(response.statusCode)")
                    return
                }
                do {
                    let responseDto = try response.map(BaseResponse<UserProfileInfoModel>.self)
                    guard let data = responseDto.result else { return }
                    
                    let updatedUserInfo = UserProfileInfoModel(
                        name: data.name,
                        profileImage: data.profileImage,
                        authType: data.authType,
                        pushStatus: data.pushStatus ?? "DISABLED"
                    )
                    self.userInfoRelay.accept(updatedUserInfo)
                    UserManager.shared.userName = data.name
                    self.configureDefaultSections() // ✅ pushStatus 반영된 최신 정보로 다시 섹션 구성
                } catch {
                    print("❌ map 에러: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ API 실패: \(error.localizedDescription)")
            }
        }
    }
}
