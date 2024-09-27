//  CustomAlertViewController.swift
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

import Lottie

@frozen
enum AlertViewType {
    case scrap
    case changeColorAndPushJobDetail
    case info
}

final class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    let selectedColorNameRelay = BehaviorRelay<String>(value: "red") // 서버에 보낼때는 컬러 Name으로
    let selectedColorHexRelay = BehaviorRelay<String>(value: "#ED4E54") // 서버에서 받을 때는 Hex로
    
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
        .calRed, .calOrange, .calGreen, .calBlue, .calPurple, .calPink
    ]
    
    private let colorNames: [String] = [
        "red", "orange", "green", "blue", "purple", "pink"
    ]
    
    private let hexColors: [String] = [
        "#ED4E54", "#F3A649", "#84D558", "#4AA9F2", "#9B64E2", "#F260AC"
    ]
    
    // MARK: - UIComponents
    
    private let jobImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.makeBorder(width: 1, color: .terningMain, cornerRadius: 10)
        $0.clipsToBounds = true
    }
    
    private let mainJobLabel = LabelFactory.build(
        text: "관심 공고가 캘린더에서 사라져요!",
        font: .title4,
        textColor: .grey500
    ).then {
        $0.numberOfLines = 3
    }
    
    private let subLabelView = UIView().then {
        $0.backgroundColor = .grey100
        $0.layer.cornerRadius = 10
    }
    
    private let subLabel = LabelFactory.build(
        text: "스크랩 색상",
        font: .body6,
        textColor: .grey400
    )
    
    private let subInfoLabel = LabelFactory.build(
        text: "스크랩을 취소하시겠어요?",
        font: .body5,
        textColor: .grey350
    )
    
    private let alertImageView = LottieAnimationView().then {
        let animation = LottieAnimation.named("scrapCancel")
        $0.animation = animation
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .playOnce
        $0.animationSpeed = 1
        $0.play()
    }
    
    private lazy var paletteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: 41, height: 41)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    private let changeColorButton = CustomButton(title: "색상 변경하기", font: .button3).setEnabled(false).setAlertViewColor()
    private let viewJobDetailButton = CustomButton(title: "공고 상세 정보 보기", font: .button3)
    private let closeButton = UIButton()
    
    private let alertView = UIView()
    
    private lazy var imageLabelVStackView = UIStackView(
        arrangedSubviews: [
            jobImageView,
            mainJobLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 10.adjustedH
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI(alertViewType)
        setHierarchy(alertViewType)
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
        
        if type != .info {
            sepeartorView.do {
                $0.backgroundColor = .grey200
            }
        }
    }
    
    private func setHierarchy(_ type: AlertViewType) {
        view.addSubviews(alertView)
        
        switch type {
        case .scrap, .changeColorAndPushJobDetail:
            alertView.addSubviews(
                imageLabelVStackView,
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
            $0.height.equalTo(421.adjustedH)
            $0.width.equalTo(320.adjusted)
        }
        closeButton.snp.makeConstraints {
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
    
    private func setScrapLayout() {
        changeColorButton.isHidden = true
        viewJobDetailButton.isHidden = true
        
        centerButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func setChangeColorAndPushJobDetailLayout() {
        centerButton.isHidden = true
        
        changeColorButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.height.equalTo(40.adjustedH)
            $0.width.equalTo(140.adjusted)
        }
        viewJobDetailButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(20.adjustedH)
            $0.leading.equalTo(changeColorButton.snp.trailing).offset(8.adjusted)
            $0.height.equalTo(40.adjustedH)
            $0.width.equalTo(140.adjusted)
        }
    }
    
    private func setInfoLayout() {
        alertImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(203.adjustedH)
        }
        
        subInfoLabel.snp.makeConstraints {
            $0.top.equalTo(mainJobLabel.snp.bottom).offset(4.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        mainJobLabel.snp.makeConstraints {
            $0.top.equalTo(alertImageView.snp.bottom).offset(20.adjustedH)
            $0.centerX.equalToSuperview()
        }

        centerButton.setTitle(title: "스크랩 취소하기")
        
        centerButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func setCommonLayout() {
        paletteCollectionView.isScrollEnabled = false
        
        imageLabelVStackView.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(32.adjustedH)
            $0.centerX.equalTo(alertView)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(153)
        }
        
        mainJobLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        jobImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(80.adjustedH)
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
    
    // MARK: - Methods
    
    private func setDelegate() {
        paletteCollectionView.delegate = self
        paletteCollectionView.dataSource = self
    }
    
    private func setRegister() {
        paletteCollectionView.register(PaletteCell.self, forCellWithReuseIdentifier: PaletteCell.className)
    }
    
    private func handleColorSelection(at indexPath: IndexPath) {
        let selectedColorName = colorNames[indexPath.item] // 헥사 코드로 선택
        selectedColorNameRelay.accept(selectedColorName) // 선택한 색상을 Relay에 저장
        
        let selectedHexColor = hexColors[indexPath.item]
        selectedColorHexRelay.accept(selectedHexColor)
    }
    
    
    private func bindViews() {
        centerButtonDidTap
            .drive(onNext: { [weak self] in
                self?.centerButtonDidTapAction?()
            })
            .disposed(by: disposeBag)
        
        leftButtonDidTap
            .drive(onNext: { [weak self] in
                self?.leftButtonDidTapAction?()
            })
            .disposed(by: disposeBag)
        
        rightButtonDidTap
            .drive(onNext: { [weak self] in
                self?.rightButtonDidTapAction?()
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: false)
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    public func setJobDetailData(model: JobDetailModel) {
        jobImageView.setImage(with: model.companyImage)
        mainJobLabel.text = model.title
        deadlineInfoView.setDescriptionText(description: model.deadline)
        workPeriodInfoView.setDescriptionText(description: model.workingPeriod)
        workStartInfoView.setDescriptionText(description: model.startYearMonth)
        
        let selectedColor = model.color ?? "#ED4E54"
        selectedColorHexRelay.accept(selectedColor)
        
        paletteCollectionView.reloadData()
    }
    
    public func setAnnouncementData(model: AnnouncementModel) {
        jobImageView.setImage(with: model.companyImage)
        mainJobLabel.text = model.title
        deadlineInfoView.setDescriptionText(description: model.deadline)
        workPeriodInfoView.setDescriptionText(description: model.workingPeriod)
        workStartInfoView.setDescriptionText(description: model.startYearMonth)
        
        let selectedColor = model.color ?? "#ED4E54"
        selectedColorHexRelay.accept(selectedColor)
        
        paletteCollectionView.reloadData()
        
        if let selectedIndex = colorNames.firstIndex(of: selectedColor) {
            let selectedIndexPath = IndexPath(item: selectedIndex, section: 0)
            paletteCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CustomAlertViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("선택한 index \(indexPath.item) 는 \(colorNames[indexPath.item])색")
        changeColorButton.isEnabled = true // 다른거 선택하면 활성화
        
        handleColorSelection(at: indexPath)
        collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDataSource

extension CustomAlertViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaletteCell.className, for: indexPath) as? PaletteCell else { return UICollectionViewCell() }
        
        let color = colors[indexPath.item]
        let colorName = hexColors[indexPath.item]
        let isSelected = colorName == selectedColorHexRelay.value
        
        cell.configure(color: color, isSelected: isSelected)
        return cell
    }
}
