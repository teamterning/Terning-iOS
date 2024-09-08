//
//  MyPageProfileViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class MyPageProfileViewCell: UITableViewCell {
    
    // MARK: - Properties

    let fixProfileTapSubject = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .grey200
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let nameLabel = LabelFactory.build(
        font: .title1
    )
    
    lazy var fixProfileButton = UIButton().then {
        $0.backgroundColor = .clear
        let attributedTitle = NSAttributedString(string: "프로필 수정", attributes: [
            .foregroundColor: UIColor.grey400,
            .font: UIFont.button3
        ])
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.setImage(.icProfileArrow, for: .normal)
        $0.tintColor = .grey400
        $0.semanticContentAttribute = .forceRightToLeft
        $0.contentHorizontalAlignment = .left
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
}

// MARK: - UI & Layout

extension MyPageProfileViewCell {
    private func setUI() {
        self.backgroundColor = .back
        
        contentView.addSubviews(
            profileImageView,
            nameLabel,
            fixProfileButton
        )
    }
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(24.adjustedH)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16.adjusted)
            $0.bottom.equalTo(profileImageView.snp.centerY)
        }
        
        fixProfileButton.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(6.adjustedH)
        }
    }
}

// MARK: - Methods

extension MyPageProfileViewCell {
    private func bindViewModel() {
        fixProfileButton.rx.tap
            .bind(to: fixProfileTapSubject)
            .disposed(by: disposeBag)
    }
    
    func bind(with viewModel: MyPageProfileModel) {
        nameLabel.text = viewModel.name
    }
}
