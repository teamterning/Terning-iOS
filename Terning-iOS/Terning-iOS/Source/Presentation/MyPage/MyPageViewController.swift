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
    
    // MARK: - UIComponents
    
    var rootView = MyPageView()
    
    // MARK: - LifeCycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.bind(model: UserProfileInfoModel(name: model.name, authType: model.authType))
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
        
        let profileEditTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileEditButtonDidTap))
        rootView.profileEditStack.addGestureRecognizer(profileEditTapGesture)
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
        print("로그아웃")
        print(model.name, model.authType)
    }
    
    @objc
    func leaveButtonDidTap() {
        print("탈퇴하기")
        print(model.name, model.authType)
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
