//
//  NewCustomAlertVC.swift
//  Terning-iOS
//
//  Created by 이명진 on 9/12/24.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

import SnapKit
import Then

@frozen
enum AlertViewType {
    case custom
    case info
}

@frozen
enum AlertButtonType {
    case changeColorAndViewJobDetail
    case scrap
}

final class NewCustomAlertVC: UIViewController {
    
    // MARK: - Properties
    var alertViewType: AlertViewType!
    var alertButtonType: AlertButtonType?
    
    let selectedColorIndexRelay = BehaviorRelay<Int>(value: 0)
    
    // Optional로 변경하여 메모리 절약
    private var JobImageView: UIImageView?
    private var mainJobLabel: UILabel?
    private var subLabelView: UIView?
    private var subLabel: UILabel?
    private var subInfoLabel: UILabel?
    
    private var alertImageView: UIImageView?
    
    // custom 타입에서만 사용되므로 lazy로 선언
    private lazy var paletteCollectionView: UICollectionView? = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: 41, height: 41)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let sepeartorView = UIView()
    
    private let deadlineInfoView = JobDetailInfoView(title: "서류 마감", description: "123")
    private let workPeriodInfoView = JobDetailInfoView(title: "근무 기간", description: "123")
    private let workStartInfoView = JobDetailInfoView(title: "근무 시작", description: "123")
    
    private lazy var detailsVStackView = UIStackView(
        arrangedSubviews: [
            deadlineInfoView,
            workPeriodInfoView,
            workStartInfoView
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 5.adjustedH
    }
    
    private let centerButton = CustomButton(title: "내 캘린더에 스크랩 하기", font: .button3)
    private let changeColorButton = CustomButton(title: "색상 변경하기", font: .button3)
    private let viewJobDetailButton = CustomButton(title: "공고 상세 정보 보기", font: .button3)
    
    private let colors: [UIColor] = [
        .calRed,
        .calOrange2,
        .calGreen1,
        .calBlue1,
        .calPurple,
        .calPink
    ]
    
    private let closeButton = UIButton()
    
    private let alertView = UIView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI(alertViewType)
        setHierachy(alertViewType)
        setLayout(alertViewType)
        setDelegate()
        setRegister()
    }
    
    init(alertViewType: AlertViewType, alertButtonType: AlertButtonType? = nil) {
        self.alertViewType = alertViewType
        self.alertButtonType = alertButtonType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI(_ type: AlertViewType) {
        view.backgroundColor = .terningBlack.withAlphaComponent(0.3)
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
        
        closeButton.do {
            $0.setImage(UIImage(resource: .icX), for: .normal)
            $0.tintColor = .grey300
        }
        
        switch type {
        case .custom:
            JobImageView = UIImageView().then {
                $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
            }
            
            subLabelView = UIView().then {
                $0.backgroundColor = .grey100
                $0.layer.cornerRadius = 10
            }
            
            subLabel = LabelFactory.build(
                text: "스크랩 색상",
                font: .body6,
                textColor: .grey400
            )
            
            mainJobLabel = LabelFactory.build(
                text: "[NAVER Cloud] 의료 특화 초거대 언어모델 학습 데이터 구축 및 안전성 평가 업무 (체험형 인턴)",
                font: .title4,
                textColor: .grey500
            ).then {
                $0.numberOfLines = 3
            }
            
        case .info:
            alertImageView = UIImageView().then {
                $0.image = .iosScrapCancel
            }
            
            mainJobLabel = LabelFactory.build(
                text: "관심 공고가 캘린더에서 사라져요",
                font: .title4,
                textColor: .grey500
            ).then {
                $0.numberOfLines = 3
            }
            
            subInfoLabel = LabelFactory.build(
                text: "스크랩을 취소하시겠어요?",
                font: .body5,
                textColor: .grey350
            )
        }
    }
    
    private func setHierachy(_ type: AlertViewType) {
        view.addSubviews(alertView)
        
        switch type {
        case .custom:
            guard let jobImageView = JobImageView,
                  let mainJobLabel = mainJobLabel,
                  let subLabelView = subLabelView,
                  let subLabel = subLabel,
                  let paletteCollectionView = paletteCollectionView else { return }
            
            alertView.addSubviews(
                jobImageView,
                mainJobLabel,
                subLabelView,
                subLabel,
                paletteCollectionView,
                sepeartorView,
                detailsVStackView,
                centerButton,
                changeColorButton,
                viewJobDetailButton,
                closeButton
            )
            
        case .info:
            guard let alertImageView = alertImageView,
                  let mainJobLabel = mainJobLabel,
                  let subInfoLabel = subInfoLabel else { return }
            
            alertView.addSubviews(
                alertImageView,
                mainJobLabel,
                subInfoLabel,
                centerButton,
                closeButton
            )
        }
    }
    
    private func setLayout(_ type: AlertViewType) {
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30.adjusted)
            $0.height.equalTo(421.adjustedH)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18.adjustedH)
            $0.trailing.equalToSuperview().offset(-18.adjusted)
            $0.width.height.equalTo(32)
        }
        
        switch type {
        case .custom:
            setCommonCustomLayout()
            setButtonLayout(alertButtonType)
        case .info:
            setInfoLayout()
        }
    }
    
    private func setDelegate() {
        guard let paletteCollectionView = paletteCollectionView else { return }
        
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
    }
    
    private func setRegister() {
        guard let paletteCollectionView = paletteCollectionView else { return }
        
        paletteCollectionView.register(PaletteCell.self, forCellWithReuseIdentifier: PaletteCell.className)
    }
    
    private func setCommonCustomLayout() {
        guard let jobImageView = JobImageView,
              let mainJobLabel = mainJobLabel,
              let subLabelView = subLabelView,
              let subLabel = subLabel,
              let paletteCollectionView = paletteCollectionView else { return }
        
        paletteCollectionView.isScrollEnabled = false
        
        jobImageView.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(32.adjustedH)
            $0.centerX.equalTo(alertView)
            $0.width.height.equalTo(80.adjustedH)
        }
        
        mainJobLabel.snp.makeConstraints {
            $0.top.equalTo(jobImageView.snp.bottom).offset(10.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        subLabelView.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(194.adjustedH)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(71)
            $0.height.equalTo(23)
        }
        
        subLabelView.addSubview(subLabel)
        
        subLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        paletteCollectionView.snp.makeConstraints {
            $0.top.equalTo(subLabelView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(41)
            $0.width.equalTo(256)
        }
        
        sepeartorView.snp.makeConstraints {
            $0.top.equalTo(paletteCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.height.equalTo(1)
        }
        
        detailsVStackView.snp.makeConstraints {
            $0.top.equalTo(sepeartorView.snp.bottom).offset(13.adjustedH)
            $0.leading.equalTo(alertView.snp.leading).offset(24.adjusted)
        }
    }
    
    private func setButtonLayout(_ type: AlertButtonType?) {
        guard let type = type else { return }
        
        switch type {
        case .changeColorAndViewJobDetail:
            centerButton.isHidden = true
            
            changeColorButton.snp.makeConstraints {
                $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
                $0.leading.equalToSuperview().inset(16.adjusted)
                $0.height.equalTo(40.adjustedH)
                $0.width.equalTo(140.adjusted)
            }
            
            viewJobDetailButton.snp.makeConstraints {
                $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
                $0.trailing.equalToSuperview().offset(-16.adjusted)
                $0.height.equalTo(40.adjustedH)
                $0.width.equalTo(140.adjusted)
            }
            
        case .scrap:
            changeColorButton.isHidden = true
            viewJobDetailButton.isHidden = true
            
            centerButton.snp.makeConstraints {
                $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.height.equalTo(40)
            }
        }
    }
    
    private func setInfoLayout() {
        guard let alertImageView = alertImageView,
              let mainJobLabel = mainJobLabel,
              let subInfoLabel = subInfoLabel else { return }
        
        alertImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        
        mainJobLabel.snp.makeConstraints {
            $0.top.equalTo(alertImageView.snp.bottom).offset(20.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        subInfoLabel.snp.makeConstraints {
            $0.top.equalTo(mainJobLabel.snp.bottom).offset(4.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        centerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func handleColorSelection(at index: Int) {
        selectedColorIndexRelay.accept(index)
    }
}

extension NewCustomAlertVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let paletteCollectionView = paletteCollectionView else { return }
        print("\(indexPath.item) 번 터치")
        self.handleColorSelection(at: indexPath.item)
        paletteCollectionView.reloadData()
    }
}

extension NewCustomAlertVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaletteCell.className, for: indexPath) as? PaletteCell else { return UICollectionViewCell() }
        
        let color = colors[indexPath.item]
        let isSelected = indexPath.item == selectedColorIndexRelay.value
        cell.configure(color: color, isSelected: isSelected)
        return cell
    }
}
