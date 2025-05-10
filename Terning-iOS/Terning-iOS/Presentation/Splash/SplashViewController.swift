//
//  SplashViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/18/24.
//

import UIKit

import FirebaseRemoteConfig

import SnapKit
import Then

final class SplashVC: UIViewController {
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = .imgSplash
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setNavigationBar()
        self.setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkAppVersion {
            self.checkDidSignIn()
        }
        addAppDidBecomeActiveObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeAppDidBecomeActiveObserver()
    }
}

// MARK: - Methods

extension SplashVC {
    private func checkDidSignIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserManager.shared.hasAccessToken {
                UserManager.shared.getNewToken { [weak self] result in
                    print("❤️❤️ 자동 로그인 시도 중 ❤️❤️")
                    switch result {
                    case .success:
                        print("SplashVC-토큰 재발급 성공")
                        self?.pushToTabBarController()
                    case .failure(let error):
                        print("토큰 재발급 실패: \(error.localizedDescription)")
                        self?.pushToSignInView()
                    }
                }
            } else {
                print("토큰 없음, 로그인 페이지로 이동")
                self.pushToSignInView()
            }
        }
    }
    
    private func pushToSignInView() {
        let signInVC = LoginViewController(
            viewModel: LoginViewModel(
                loginRepository: LoginRepository(
                    loginService: LoginService()
                )
            )
        )
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func pushToTabBarController() {
        let tabBarController = TNTabBarController()
        guard let window = self.view.window else { return }

        ViewControllerUtils.setRootViewController(window: window, viewController: tabBarController, withAnimation: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            PushNavigator.applyPendingPushIfNeeded()
        }
    }
    
}

// MARK: - Update Methods

extension SplashVC {
    func checkAppVersion(completion: @escaping () -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 86400
        remoteConfig.configSettings = settings
        
        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                print("🌷❌ Remote Config fetch error: \(error.localizedDescription)")
                completion()
                return
            }
            
            switch status {
            case .successFetchedFromRemote:
                print("🌷✅ Remote Config: fetched from remote")
            case .successUsingPreFetchedData:
                print("🌷ℹ️ Remote Config: using cached data")
            case .error:
                completion()
                print("🌷⚠️ Remote Config: activation error")
                return
            @unknown default:
                completion()
                print("🌷⚠️ Remote Config: unknown status")
                return
            }
            
            let remoteVersion = remoteConfig.configValue(forKey: "ios_app_version").stringValue
            let majorTitle = remoteConfig.configValue(forKey: "ios_major_update_title").stringValue
            let majorBody = remoteConfig.configValue(forKey: "ios_major_update_body").stringValue
            let patchTitle = remoteConfig.configValue(forKey: "ios_patch_update_title").stringValue
            let patchBody = remoteConfig.configValue(forKey: "ios_patch_update_body").stringValue
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            guard !remoteVersion.isEmpty else {
                print("🌷❌ Remote Config에서 앱 버전이 누락됨")
                return
            }
            
            guard currentVersion?.compare(remoteVersion, options: .numeric) == .orderedAscending else {
                print("🌷✅ 최신 버전입니다")
                completion()
                return
            }
            
            let currentComponents = currentVersion?.split(separator: ".").compactMap { Int($0) } ?? [0, 0, 0]
            let remoteComponents = remoteVersion.split(separator: ".").compactMap { Int($0) }
            
            let currentMajor = currentComponents[0]
            let currentMinor = currentComponents[1]
            
            let remoteMajor = remoteComponents[0]
            let remoteMinor = remoteComponents[1]
            
            let isMajorUpdate = remoteMajor > currentMajor || (remoteMajor == currentMajor && remoteMinor > currentMinor)
            
            let type: UpdateAlertViewController.UpdateViewType = isMajorUpdate ? .force : .normal
            let titleRaw = isMajorUpdate ? majorTitle : patchTitle
            let bodyRaw = isMajorUpdate ? majorBody : patchBody
            
            let title = titleRaw.replacingOccurrences(of: "\\n", with: "\n")
            let body = bodyRaw.replacingOccurrences(of: "\\n", with: "\n")
            
            guard !title.isEmpty, !body.isEmpty else {
                print("🌷❌ 업데이트 문구 누락 → 팝업 표시 중단")
                completion()
                return
            }
            
            let updateVC = UpdateAlertViewController(updateViewType: type, title: title, discription: body)
            updateVC.modalPresentationStyle = .overFullScreen
            
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootVC.present(updateVC, animated: false)
            }
            
            updateVC.rx.centerButtonTap
                .bind { [weak updateVC] in
                    self.goToAppStore()
                    updateVC?.dismiss(animated: false)
                }
                .disposed(by: updateVC.disposeBag)
            
            updateVC.rx.rightButtonTap
                .bind { [weak updateVC] in
                    self.goToAppStore()
                    updateVC?.dismiss(animated: false)
                }
                .disposed(by: updateVC.disposeBag)
            
            updateVC.rx.leftButtonTap
                .bind { [weak updateVC] in
                    updateVC?.dismiss(animated: false)
                    completion()
                }
                .disposed(by: updateVC.disposeBag)
        }
    }
    
    private func addAppDidBecomeActiveObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    private func removeAppDidBecomeActiveObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    private func goToAppStore() {
        if let url = URL(string: "https://apps.apple.com/app/id6547866420") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc
    private func appDidBecomeActive() {
        checkAppVersion { [self] in
            checkDidSignIn()
        }
    }
}

// MARK: - UI & Layout

extension SplashVC {
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
