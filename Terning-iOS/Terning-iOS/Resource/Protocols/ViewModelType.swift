//
//  ViewModelType.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/11/24.
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}
