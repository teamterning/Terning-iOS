//
//  ProfileFixViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

import RxCocoa
import RxSwift

final class ProfileFixViewModel: ProfileViewModelType {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    
    var userInfo: UserProfileInfoModel?
    let nameRelay = BehaviorRelay<String>(value: "")
    let imageStringRelay = BehaviorRelay<String>(value: "")
    
    private let nameValidationMessageRelay = BehaviorRelay<ValidationMessage>(value: .nullMessage)
    
    private let isNameChanged = BehaviorRelay<Bool>(value: false)
    private let isImageChanged = BehaviorRelay<Bool>(value: false)
    
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
            .skip(1)
            .do(onNext: { [weak self] name in
                guard let self = self else { return }
                self.nameRelay.accept(name)
                
                if name != self.userInfo?.name {
                    self.isNameChanged.accept(true)
                }
            })
            .share(replay: 1, scope: .whileConnected)
        
        input.imageStringSubject
            .skip(1)
            .subscribe(onNext: { [weak self] newImageString in
                guard let self = self else { return }
                if newImageString != self.userInfo?.profileImage {
                    self.isImageChanged.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
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
        
        let isSaveButtonEnabled = Observable
            .combineLatest(isNameChanged, isImageChanged, isNameValid)
            .map { nameChanged, imageChanged, nameValid in
                return (nameChanged || imageChanged) && nameValid
            }
            .startWith(false)
            .share(replay: 1, scope: .whileConnected)
        
        let saveAlert = input.saveButtonTap
            .withLatestFrom(isSaveButtonEnabled)
            .filter { $0 }
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.patchProfileInfo(
                    name: self.nameRelay.value,
                    profileImage: self.imageStringRelay.value
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

extension ProfileFixViewModel {
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

extension ProfileFixViewModel {
    private func patchProfileInfo(name: String, profileImage: String) -> Observable<Void> {
        return Observable.create { observer in
            self.myPageProvider.request(.patchProfileInfo(name: name, profileImage: profileImage)) { result in
                LoadingIndicator.hideLoading()
                switch result {
                case .success(let response):
                    if 200..<300 ~= response.statusCode {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
