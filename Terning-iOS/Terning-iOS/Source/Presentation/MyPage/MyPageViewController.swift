//
//  MyPageViewController.swift
//  Terning-iOS
//
//  Created by 김민성 on 7/17/24.
//

import UIKit

import SnapKit
import Then

class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var UserProfileInfomModelItems: [UserProfileInfoModel] = UserProfileInfoModel.getUserProfileInfo()
    
    lazy var model = UserProfileInfomModelItems[0]
    
    var appVersion: String?
    
    private let myPageProvider = Providers.myPageProvider
    
    // MARK: - UIComponents
    
    var rootView = MyPageView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyPageInfo()
        rootView.bind(
            model: UserProfileInfoModel(
                name: model.name,
                authType: model.authType
            )
        )
        setTapGesture()
        setAddTarget()
        getAppVersion()
        
    }
}

extension MyPageViewController {
    
    // MARK: - Methods
    
    private func setTapGesture() {
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutButtonDidTap))
        rootView.logoutButton.addGestureRecognizer(logoutTapGesture)
        
        let leaveTapGesture = UITapGestureRecognizer(target: self, action: #selector(leaveButtonDidTap))
        rootView.leaveButton.addGestureRecognizer(leaveTapGesture)
    }
    
    private func setAddTarget() {
        rootView.noticeButton.addTarget(self, action: #selector(noticeButtonDidTap), for: .touchUpInside)
        rootView.sendOpinionButton.addTarget(self, action: #selector(sendOpinionButtonDidTap), for: .touchUpInside)
    }
    
    private func getAppVersion() {
        appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "알 수 없어요"
        rootView.versionInfo.text = appVersion
        print(appVersion ?? "알 수 없어요")
    }
    
    // MARK: - objc Functions
    
    @objc
    func logoutButtonDidTap() {
        let contentViewController = LogoutViewContoller(viewType: .logout)
        
        let bottomSheetVC = CustomBottomSheetViewController(
            bottomType: .low,
            contentViewController: contentViewController,
            upScroll: false,
            isNotch: false
        )
        
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false)
    }
    
    @objc
    func leaveButtonDidTap() {
        let contentViewController = LogoutViewContoller(viewType: .withdraw)
        
        let bottomSheetVC = CustomBottomSheetViewController(
            bottomType: .low,
            contentViewController: contentViewController,
            upScroll: false,
            isNotch: false
        )
        
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false)
    }
    
    @objc
    func noticeButtonDidTap() {
        print("공지사항")
    }
    
    @objc
    func sendOpinionButtonDidTap() {
        print("의견 보내기")
    }
    
    @objc
    func profileEditButtonDidTap() {
        print("navigate to profile edit view")
    }
    
   
}

extension MyPageViewController {
    private func showBottomView() {
      
    }
}


// MARK: - API

extension MyPageViewController {
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
                        
                        rootView.userNameLabel.text = "\(data.name)님"
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
