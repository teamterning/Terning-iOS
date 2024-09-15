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
    case scrap
    case changeColorAndPushJobDetail
    case info
}

final class NewCustomAlertVC: UIViewController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    let selectedColorNameRelay = BehaviorRelay<String>(value: "red")
    
    var centerButtonDidTap: Driver<Void> {
        return centerButton.rx.tap.asDriver()
    }
    
    var leftButtonDidTap: Driver<Void> {
        return changeColorButton.rx.tap.asDriver()
    }
    
    var rightButtonDidTap: Driver<Void> {
        return viewJobDetailButton.rx.tap.asDriver()
    }
    
    var centerButtonDidTapAction: (() -> Void)?
    var leftButtonDidTapAction: (() -> Void)?
    var rightButtonDidTapAction: (() -> Void)?
    
    var alertViewType: AlertViewType!
    
    
    private let colors: [UIColor] = [
        .calRed,
        .calOrange,
        .calGreen,
        .calBlue,
        .calPurple,
        .calPink
    ]
    
    private let colorNames: [String] = [
        "red",
        "orange",
        "green",
        "blue",
        "purple",
        "pink"
    ]
    
    // MARK: - UIComponents
    
    private var jobImageView: UIImageView?
    private var mainJobLabel: UILabel?
    private var subLabelView: UIView?
    private var subLabel: UILabel?
    private var subInfoLabel: UILabel?
    private var alertImageView: UIImageView?
    
    private lazy var paletteCollectionView: UICollectionView? = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
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
        bindViews()
    }
    
    init(alertViewType: AlertViewType) {
        self.alertViewType = alertViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI & Layout

extension NewCustomAlertVC {
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
        case .scrap, .changeColorAndPushJobDetail:
            jobImageView = UIImageView().then {
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
        case .scrap, .changeColorAndPushJobDetail:
            guard let jobImageView = jobImageView,
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
        self.alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30.adjusted)
            $0.height.equalTo(421.adjustedH)
        }
        
        self.closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18.adjustedH)
            $0.trailing.equalToSuperview().offset(-18.adjusted)
            $0.width.height.equalTo(32)
        }
        
        switch type {
        case .scrap:
            setCommonLayout()
            setScrapLayout()
            
        case .changeColorAndPushJobDetail:
            setCommonLayout()
            setChangeColorAndPushJobDetailLayout()
            
        case .info:
            setInfoLayout()
        }
    }
    
    private func setChangeColorAndPushJobDetailLayout() {
        self.centerButton.isHidden = true
        
        self.changeColorButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(40.adjustedH)
            $0.width.equalTo(140.adjusted)
        }
        
        self.viewJobDetailButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
            $0.trailing.equalToSuperview().offset(-16.adjusted)
            $0.height.equalTo(40.adjustedH)
            $0.width.equalTo(140.adjusted)
        }
    }
    
    private func setScrapLayout() {
        self.changeColorButton.isHidden = true
        self.viewJobDetailButton.isHidden = true
        
        self.centerButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
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
        
        self.centerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func setCommonLayout() {
        guard let jobImageView = jobImageView,
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
        
        self.sepeartorView.snp.makeConstraints {
            $0.top.equalTo(paletteCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.height.equalTo(1)
        }
        
        self.detailsVStackView.snp.makeConstraints {
            $0.top.equalTo(sepeartorView.snp.bottom).offset(13.adjustedH)
            $0.leading.equalTo(alertView.snp.leading).offset(24.adjusted)
        }
    }
}


// MARK: - Methods

extension NewCustomAlertVC {
    private func setDelegate() {
        guard let paletteCollectionView = paletteCollectionView else { return }
        
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
    }
    
    private func setRegister() {
        guard let paletteCollectionView = paletteCollectionView else { return }
        
        paletteCollectionView.register(PaletteCell.self, forCellWithReuseIdentifier: PaletteCell.className)
    }
    
    private func handleColorSelection(at colorName: String) {
        selectedColorNameRelay.accept(colorName)
    }
    
    private func bindViews() {
        centerButtonDidTap
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.centerButtonDidTapAction?()
            })
            .disposed(by: disposeBag)
        
        leftButtonDidTap
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.leftButtonDidTapAction?()
            })
            .disposed(by: disposeBag)
        
        rightButtonDidTap
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.rightButtonDidTapAction?()
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: false)
        }.disposed(by: disposeBag)
    }
}

// MARK: - Public Methods

extension NewCustomAlertVC {
    public func setSearchData(model: SearchResult) {
        guard alertViewType == .scrap else { return }
        
        guard let jobImageView = jobImageView,
              let mainJobLabel = mainJobLabel
        else { return }
        
        jobImageView.setImage(with: model.companyImage)
        mainJobLabel.text = model.title
        self.deadlineInfoView.setDescriptionText(description: model.deadline)
        self.workPeriodInfoView.setDescriptionText(description: model.workingPeriod)
        self.workStartInfoView.setDescriptionText(description: model.startYearMonth)
        
        let selectedColor = model.color ?? "red"
        self.selectedColorNameRelay.accept(selectedColor)
        
        self.paletteCollectionView?.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension NewCustomAlertVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let paletteCollectionView = paletteCollectionView else { return }
        
        let selectedColorName = colorNames[indexPath.item]
        print("❤️ \(indexPath.item) 인덱스, 선택된 색상: \(selectedColorName)")
        self.handleColorSelection(at: selectedColorName)
        paletteCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension NewCustomAlertVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaletteCell.className, for: indexPath) as? PaletteCell else { return UICollectionViewCell() }
        
        let color = colors[indexPath.item]
        let colorName = colorNames[indexPath.item]
        let isSelected = colorName == selectedColorNameRelay.value
        
        cell.configure(color: color, isSelected: isSelected)
        return cell
    }
}
