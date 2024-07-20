//
//  LogoutViewContoller.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/20/24.
//

import UIKit

import SnapKit

@frozen
enum logoutViewType {
    case logout
    case withdraw
}

final class LogoutViewContoller: UIViewController {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    
    var viewType: logoutViewType
    
    // MARK: - UI Components
    
    private let titleLabel = LabelFactory.build(
        text: "잠깐만요!",
        font: .heading1
    )
    
    private let subTitleLabel = LabelFactory.build(
        text: "정말 로그아웃 하시겠어요?",
        font: .body4,
        textColor: .grey400
    ).then {
        $0.numberOfLines = 4
    }
    
    private lazy var yesButton = CustomButton(title: "로그아웃하기").then {
        $0.addTarget(self, action: #selector(yesButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var noButton = CustomButton(title: "취소").then{
        $0.setColor(bgColor: .clear, disableColor: .clear)
        $0.addTarget(self, action: #selector(noButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Init
    
    init(viewType: logoutViewType) {
        self.viewType = viewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setHierarchy()
        setLayout()
      
    }
}

// MARK: - UI & Layout

extension LogoutViewContoller {
    private func setUI() {
        if viewType == .logout {
            subTitleLabel.text = "정말 로그아웃 하시겠어요?"
            yesButton.setTitle(title: "로그아웃 하기")
        } else {
            subTitleLabel.text = "탈퇴 시 계정 및 이용 기록은 모두 삭제되며,\n삭제된 데이터는 복구가 불가능합니다.\n\n탈퇴를 진행할까요?"
            yesButton.setTitle(title: "탈퇴하기")
        }
    }
    
    private func setHierarchy() {
        view.addSubviews(
            titleLabel,
            subTitleLabel,
            yesButton,
            noButton
        )
    }
    
    private func  setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(71)
            $0.height.equalTo(80)
        }
        yesButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(noButton.snp.top).offset(-8)
        }
        noButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
        }
    }

}

// MARK: - Methods

extension LogoutViewContoller {
    @objc
    private func yesButtonDidTap() {
        postLogout()
        UserManager.shared.logout()
        navigateToSplashVC()
    }
    
    @objc
    private func noButtonDidTap() {
        deleteWithdraw()
        UserManager.shared.logout()
        navigateToSplashVC()
    }
    
    private func navigateToSplashVC() {
        let SplashVC = UINavigationController(rootViewController: SplashVC())
        
        guard let window = self.view.window else {
            print("Window is nil")
            return
        }
        ViewControllerUtils.setRootViewController(window: window, viewController: SplashVC, withAnimation: true)
    }
}

// MARK: - API

extension LogoutViewContoller {
    func postLogout() {
        myPageProvider.request(.logout) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
            
                if 200..<300 ~= status {
                    do {
                        let responseDto = try response.map(BaseResponse<BlankData>.self)

                    } catch {
                        print("네트워크 에러")
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
    
    func deleteWithdraw() {
        myPageProvider.request(.withdraw) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
            
                if 200..<300 ~= status {
                    do {
                        let responseDto = try response.map(BaseResponse<BlankData>.self)

                    } catch {
                        print("네트워크 에러")
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
