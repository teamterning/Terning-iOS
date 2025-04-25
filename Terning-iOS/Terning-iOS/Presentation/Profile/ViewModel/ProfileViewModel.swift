//
//  ProfileViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/10/24.
//

import UIKit

import RxCocoa
import RxSwift

final class ProfileViewModel: ProfileViewModelType {
    
    // MARK: - Properties
    
    private let authProvider = Providers.authProvider
    
    var userInfo: UserProfileInfoModel?
    let nameRelay = BehaviorRelay<String>(value: "")
    let imageStringRelay = BehaviorRelay<String>(value: "basic")
    
    private let nameValidationMessageRelay = BehaviorRelay<ValidationMessage>(value: .defaultMessage)
    
    // MARK: - Init
    
    init(userInfo: UserProfileInfoModel? = nil) {
        self.userInfo = userInfo
        if let userInfo = userInfo {
            nameRelay.accept(userInfo.name)
            imageStringRelay.accept(userInfo.profileImage)
        }
    }
    
    // MARK: - Transform
    
    func transform(input: ProfileViewModelInput, disposeBag: DisposeBag) -> ProfileViewModelOutput {
        let userInfo = input.userInfo.asDriver(onErrorJustReturn: UserProfileInfoModel(name: "", profileImage: "basic", authType: ""))
        
        let text = input.name
            .do(onNext: { [weak self] name in
                guard let self = self else { return }
                self.nameRelay.accept(name)
            })
            .share(replay: 1, scope: .whileConnected)
        
        let isNameValid = nameRelay
            .map { [weak self] name in
                guard let self = self else { return false }
                let isValid = !name.isEmpty && self.characterCount(of: name) <= 12 && !self.containsSpecialCharacters(name) && !self.containsSymbols(name)
                return isValid
            }
            .share(replay: 1, scope: .whileConnected)
        
        let nameCountText = nameRelay
            .map { "\($0.count)/12" }
            .share(replay: 1, scope: .whileConnected)
        
        let nameValidationMessage = nameValidationMessageRelay.asObservable()
        
        let isSaveButtonEnabled = isNameValid
            .share(replay: 1, scope: .whileConnected)
        
        let saveAlert = input.saveButtonTap
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.signUp(
                    name: self.nameRelay.value,
                    profileImage: self.imageStringRelay.value,
                    authType: Config.authType,
                    fcmToken: Config.fcmToken
                )
            }
            .asDriver(onErrorJustReturn: ())
        
        return ProfileViewModelOutput(
            userInfo: userInfo,
            text: text,
            nameCountText: nameCountText,
            isNameValid: isNameValid,
            nameValidationMessage: nameValidationMessage,
            saveAlert: saveAlert,
            isSaveButtonEnabled: isSaveButtonEnabled
        )
    }
}
extension ProfileViewModel {
    func validateInput(newText: String) -> Bool {
        if newText.isEmpty {
            nameValidationMessageRelay.accept(.defaultMessage)
        } else if characterCount(of: newText) > 12 {
            nameValidationMessageRelay.accept(.tooLong)
            return false
        } else if containsSpecialCharacters(newText) {
            nameValidationMessageRelay.accept(.containsSpecialCharacters)
        } else if containsSymbols(newText) {
            nameValidationMessageRelay.accept(.containsSymbols)
        } else {
            nameValidationMessageRelay.accept(.valid)
        }
        return true
    }
}

// MARK: - API

extension ProfileViewModel {
    private func signUp(name: String, profileImage: String, authType: String, fcmToken: String) -> Observable<Void> {
        return Observable.create { observer in
            self.authProvider.request(.signUp(name: name, profileImage: profileImage, authType: authType, fcmToken: fcmToken)) { result in
                LoadingIndicator.hideLoading()
                switch result {
                case .success(let response):
                    let status = response.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try response.map(BaseResponse<SignInResponseModel>.self)
                            if let model = responseDto.result {
                                UserManager.shared.accessToken = model.accessToken
                                UserManager.shared.refreshToken = model.refreshToken
                                UserManager.shared.userId = model.userId
                                UserManager.shared.authType = model.authType
                                observer.onNext(())
                                observer.onCompleted()
                            } else {
                                observer.onError(NSError(domain: "가입 오류", code: status))
                            }
                        } catch {
                            observer.onError(NSError(domain: "가입 오류", code: status))
                        }
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
