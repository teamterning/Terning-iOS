//
//  MyPageAccountOptionViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class MyPageAccountOptionViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let logoutTapSubject = PublishSubject<Void>()
    let withdrawTapSubject = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let logoutLabel = LabelFactory.build(
        text: "로그아웃",
        font: .button4,
        textColor: .grey350
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    private let verticalStickView = UIImageView().then {
        $0.image = UIImage(resource: .myPageVerticalBar)
    }
    
    private let withdrawLabel = LabelFactory.build(
        text: "탈퇴하기",
        font: .button4,
        textColor: .grey350
    ).then {
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension MyPageAccountOptionViewCell {
    private func setUI() {
        contentView.addSubviews(
            logoutLabel,
            verticalStickView,
            withdrawLabel
        )
    }
    
    private func setLayout() {
        verticalStickView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(8.adjustedH)
            $0.width.equalTo(1.adjusted)
        }
        
        logoutLabel.snp.makeConstraints {
            $0.trailing.equalTo(verticalStickView.snp.leading).offset(-12.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        withdrawLabel.snp.makeConstraints {
            $0.leading.equalTo(verticalStickView.snp.trailing).offset(12.adjusted)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyPageAccountOptionViewCell {
    private func bindViewModel() {
        let logoutTapGesture = UITapGestureRecognizer()
        logoutTapGesture.cancelsTouchesInView = false

        logoutLabel.addGestureRecognizer(logoutTapGesture)
        logoutTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.logoutTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        let withdrawTapGesture = UITapGestureRecognizer()
        withdrawTapGesture.cancelsTouchesInView = false
        withdrawLabel.addGestureRecognizer(withdrawTapGesture)

        withdrawTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.withdrawTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
