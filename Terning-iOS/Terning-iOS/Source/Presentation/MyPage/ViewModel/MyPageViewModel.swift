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
    
    private var defaultUserInfo: UserProfileInfoModel {
        return UserProfileInfoModel(name: "", profileImage: "", authType: "")
    }
    
    private let sectionsRelay = BehaviorRelay<[SectionData]>(value: [])
    private let userInfoRelay = BehaviorRelay<UserProfileInfoModel>(value: UserProfileInfoModel(name: "회원", profileImage: "basic", authType: "UNKNOWN"))
    
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
                    .asDriver(onErrorJustReturn: UserProfileInfoModel(name: "", profileImage: "basic" ,authType: ""))
        let showLogoutAlert = input.logoutTap.asDriver(onErrorJustReturn: ())
        let showWithdrawAlert = input.withdrawTap.asDriver(onErrorJustReturn: ())
        
        let cellTapped = input.itemSelected
            .map { sectionItem -> CellAction in
                switch sectionItem {
                case .userInfoViewModel:
                    return .nonAction
                case .cellViewModel(let cellModel):
                    switch cellModel.title {
                    case "공지사항":
                        return .showNotice
                    case "의견보내기":
                        return .sendFeedback
                    case "서비스 이용약관":
                        return .showTermsOfUse
                    case "개인정보 처리방침":
                        return .showPrivacyPolicy
                    default:
                        return .nonAction
                    }
                case .emptyCell:
                    return .nonAction
                }
            }
            .asDriver(onErrorJustReturn: .nonAction)
        
        let defaultSections = [
            SectionData(
                title: "프로필",
                items: [
                    .userInfoViewModel(userInfoRelay.value)
                ]
            ),
            SectionData(
                title: "터닝 커뮤니티",
                items: [
                    .cellViewModel(MyPageBasicCellModel(image: .icNotice, title: "공지사항", accessoryType: .disclosureIndicator)),
                    .cellViewModel(MyPageBasicCellModel(image: .icOpinion, title: "의견보내기", accessoryType: .disclosureIndicator))
                ]
            ),
            SectionData(
                title: "서비스 정보",
                items: [
                    .cellViewModel(MyPageBasicCellModel(image: .icService, title: "서비스 이용약관", accessoryType: .disclosureIndicator)),
                    .cellViewModel(MyPageBasicCellModel(image: .icPersonal, title: "개인정보 처리방침", accessoryType: .disclosureIndicator)),
                    .cellViewModel(MyPageBasicCellModel(image: .icVersion, title: "버전 정보", accessoryType: .label(text: "1.1.0")))
                ]
            ),
            SectionData(
                title: "기타",
                items: [
                    .emptyCell
                ]
            )
        ]
        
        sectionsRelay.accept(defaultSections)
        getMyPageInfo()
        
        return Output(
            sections: sectionsRelay.asDriver(),
            navigateToProfileEdit: navigateToProfileEdit,
            showLogoutAlert: showLogoutAlert,
            showWithdrawAlert: showWithdrawAlert,
            cellTapped: cellTapped
        )
    }
}

// MARK: - API

extension MyPageViewModel {
    func getMyPageInfo() {
        myPageProvider.request(.getProfileInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try response.map(BaseResponse<UserProfileInfoModel>.self)
                        guard let data = responseDto.result else { return }

                        let updatedUserInfo = UserProfileInfoModel(
                            name: data.name,
                            profileImage: data.profileImage,
                            authType: data.authType
                        )
                        self.userInfoRelay.accept(updatedUserInfo)

                        var updatedSections = self.sectionsRelay.value
                        updatedSections[0] = SectionData(
                            title: "프로필",
                            items: [
                                .userInfoViewModel(updatedUserInfo)
                            ]
                        )
                        self.sectionsRelay.accept(updatedSections)
                        
                    } catch {
                        print("사용자 정보를 불러올 수 없어요.")
                        print(error.localizedDescription)
                    }
                    
                } else {
                    print("404 error")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
