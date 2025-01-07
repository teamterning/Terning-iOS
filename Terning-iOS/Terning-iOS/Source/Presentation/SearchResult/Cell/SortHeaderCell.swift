//
//  SortHeaderCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift

import SnapKit

final class SortHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    let sortButtonTapSubject = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    private let gradientView = GradientLayerView()
    
    private let searchResultCountLabel = LabelFactory.build(
        text: "총 0개의 공고가 있어요",
        font: .detail1,
        textColor: .grey400,
        textAlignment: .left,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    var sortButton = CustomSortButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
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

extension SortHeaderCell {
    func setHierarchy() {
        backgroundColor = .white
        addSubviews(
            searchResultCountLabel,
            sortButton,
            gradientView
        )
    }
    
    func setLayout() {
        searchResultCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.adjusted)
            $0.top.equalToSuperview().inset(5.adjustedH)
            $0.trailing.equalTo(sortButton.snp.leading).inset(10.adjusted)
        }
        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22.adjusted)
            $0.centerY.equalToSuperview()
        }
        gradientView.snp.makeConstraints {
            $0.top.equalTo(searchResultCountLabel.snp.bottom).offset(3.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28.adjustedH)
        }
    }
}

extension SortHeaderCell {
    private func bindViewModel() {
        sortButton.rx.tap
            .bind(to: sortButtonTapSubject)
            .disposed(by: disposeBag)
    }
}

extension SortHeaderCell {
    func bind(with count: Int) {
        var countString = "\(count)"
        
        if countString.count > 12 {
            let startIndex = countString.startIndex
            let endIndex = countString.index(startIndex, offsetBy: 10)
            countString = String(countString[startIndex..<endIndex]) + "..."
        }
        
        let fullText = "총 \(countString)개의 공고가 있어요"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.detail1,
                .foregroundColor: UIColor.grey400,
                .kern: 0.002,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        let range = (fullText as NSString).range(of: countString)
        attributedText.addAttributes([
            .font: UIFont.body5,
            .foregroundColor: UIColor.terningMain,
            .kern: 0.002,
            .paragraphStyle: paragraphStyle
        ], range: range)
        
        searchResultCountLabel.attributedText = attributedText
    }
    
    func setSortButtonTitle(_ title: String) {
        sortButton.setTitle(title, for: .normal)
    }
}
