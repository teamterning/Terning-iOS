//
//  LogoutViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/4/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LogoutViewModel: AccountOptionViewModelType {
    
    // MARK: - Properties
    
    private let myPageProvider = Providers.myPageProvider
    
    // MARK: - Transform
    
    func transform(input: AccountOptionViewModelInput, disposeBag: DisposeBag) -> AccountOptionViewModelOutput {
        let showSplashScreen = input.yesButtonTap
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.postLogout()
            }
            .asDriver(onErrorJustReturn: ())
        
        let dismissModal = input.noButtonTap
            .asDriver(onErrorJustReturn: ())
        
        return AccountOptionViewModelOutput(
            showSplashScreen: showSplashScreen,
            dismissModal: dismissModal
        )
    }
}

// MARK: - API

extension LogoutViewModel {
    private func postLogout() -> Observable<Void> {
        return Observable.create { observer in
            self.myPageProvider.request(.logout) { result in
                switch result {
                case .success(let response):
                    if 200..<300 ~= response.statusCode {
                        
                        UserManager.shared.logout()
                        
                        observer.onNext(())
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "로그아웃 오류", code: response.statusCode))
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
