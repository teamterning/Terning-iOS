//
//  CustomAlertViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/7/24.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift

import SnapKit
import Then

@frozen
enum AlertType {
    case custom
    case normal
}

enum AlertMode {
    case info
    case color
}

final class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var centerButtonTapAction: (() -> Void)?
    
    private var disposeBag = DisposeBag()
    var currentMode: AlertMode = .info
    
    private var alertType: AlertType!
    
    let selectedColorIndexRelay = BehaviorRelay<Int>(value: 0)
    
    // MARK: - UI Components
    
    private let alertView = UIView()
    
    private lazy var palettecollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: 40, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PaletteCell.self, forCellWithReuseIdentifier: PaletteCell.className)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let JobImageView = UIImageView().then {
        $0.setImage(with: "https://res.cloudinary.com/linkareer/image/fetch/f_auto,q_50/https://api.linkareer.com/attachments/397824")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.makeBorder(width: 1, color: .terningMain)
    }
    
    private let alertImageView = UIImageView().then {
        $0.image = UIImage(resource: .icHome)
    }
    
    private let mainLabel = LabelFactory.build(
        text: "[한양대학교 컬렉티브임팩트센터] /코이카 영프로페셔널(YP) 모집합니다",
        font: .title4,
        textColor: .grey500
    ).then {
        $0.numberOfLines = 3
    }
    
    private let subLabel = LabelFactory.build(
        text: "공고를 캘린더에 스크랩 하시겠어요?",
        font: .body5,
        textColor: .grey350
    )
    
    private let sepeartorView = UIView().then { $0.backgroundColor = .grey200 }
    
    private let dDayLabel = LabelFactory.build(
        text: "D-3",
        font: .body5,
        textColor: .terningMain
    )
    
    private var deadlineInfoView = JobDetailInfoView(title: "서류 마감", description: "123")
    private var workPeriodInfoView = JobDetailInfoView(title: "근무 기간", description: "123")
    private var workStartInfoView = JobDetailInfoView(title: "근무 시작", description: "123")
    
    private lazy var detailsVStackView = UIStackView(
        arrangedSubviews: [
            deadlineInfoView,
            workPeriodInfoView,
            workStartInfoView
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private let colorButton = UIButton(type: .system).then {
        $0.setBackgroundColor(.calGreen2, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("색상", for: .normal)
        $0.layer.cornerRadius = 13
    }
    
    private lazy var paletteContainerView = UIStackView(
        arrangedSubviews: [
            paletteRow1View,
            paletteRow2View
        ]
    ).then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 6
        $0.isHidden = true
    }
    
    private let paletteRow1View = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 14
    }
    
    private let paletteRow2View = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 14
    }
    
    private let centerButton = CustomButton(title: "내 캘린더에 스크랩 하기", font: .button3)
    
    private let colors: [UIColor] = [
        .calRed,
        .calOrange2,
        .calGreen1,
        .calBlue1,
        .calPurple,
        .calOrange,
        .calYellow,
        .calGreen2,
        .calBlue2,
        .calPink
    ]
    
    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(resource: .icX), for: .normal)
        $0.tintColor = .grey300
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setLayout(alertType)
        self.bindViews(alertType)
        if alertType == .custom {
            switchMode(to: .info)
        }
    }
    
    init(alertType: AlertType) {
        
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomAlertViewController {
    private func setUI() {
        view.backgroundColor = .terningBlack.withAlphaComponent(0.3)
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 20
    }
    
    private func setLayout(_ type: AlertType) {
        switch type {
        case .custom:
            setCustomLayout()
        case .normal:
            setNormalLayout()
        }
    }
}

// MARK: - Methods

extension CustomAlertViewController {
    public func setData(model: ScrapedAndDeadlineModel) {
        guard alertType == .custom else { return } // custom 타입 일때만 사용 가능한 메서드
        
        self.JobImageView.setImage(with: model.companyImage)
        self.mainLabel.text = model.title
        self.dDayLabel.text = model.dDay
        self.deadlineInfoView.setDescriptionText(description: model.deadline)
        self.workPeriodInfoView.setDescriptionText(description: model.workingPeriod)
        self.workStartInfoView.setDescriptionText(description: model.startYearMonth)
        DispatchQueue.main.async {
            self.colorButton.setBackgroundColor(UIColor(hex: model.color), for: .normal)
        }
        self.subLabel.text = "오늘 지원이 마감되는 공고예요!"
        self.centerButton.setTitle(title: "공고 상세 정보 보러가기")
        
        
    }
    
    public func setData2(model: DailyScrapModel, deadline: String) {
        guard alertType == .custom else { return } // custom 타입 일때만 사용 가능한 메서드
        
        self.JobImageView.setImage(with: model.companyImage ?? "")
        self.mainLabel.text = model.title
        self.dDayLabel.text = model.dDay
        self.deadlineInfoView.setDescriptionText(description: deadline)
        self.workPeriodInfoView.setDescriptionText(description: model.workingPeriod ?? "")
        self.workStartInfoView.setDescriptionText(description: "\(model.startYear ?? 0) 년 \(model.startMonth ?? 0) 월 ")
        DispatchQueue.main.async {
            self.colorButton.setBackgroundColor(UIColor(hex: model.color), for: .normal)
        }
        self.subLabel.text = "오늘 지원이 마감되는 공고예요!"
        self.centerButton.setTitle(title: "공고 상세 정보 보러가기")
    }
    
    
    /// 알림창에 들어갈 String 값을 커스텀 해주는 메서드 입니다.
    /// - Parameters:
    ///   - mainLabel: 메인 text
    ///   - subLabel: 서브 text
    ///   - buttonLabel: 중앙 버튼 text
    public func setComponentDatas(mainLabel: String, subLabel: String, buttonLabel: String) {
        guard alertType == .normal else { return }
        
        self.mainLabel.text = mainLabel
        self.subLabel.text = subLabel
        self.centerButton.setTitle(title: buttonLabel)
    }
    
    private func bindViews(_ type: AlertType) {
        
        self.centerButton.rx.tap.subscribe { _ in
            self.centerButtonTapAction?()
        }.disposed(by: disposeBag)
        
        self.closeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: false)
        }.disposed(by: disposeBag)
        
        if type == .custom {
            customBinds()
        }
    }
    
    private func switchMode(to mode: AlertMode) {
        self.currentMode = mode
        let isInfoMode = mode == .info
        
        self.detailsVStackView.isHidden = !isInfoMode
        self.dDayLabel.isHidden = !isInfoMode
        self.palettecollectionView.isHidden = isInfoMode
        let buttonName = isInfoMode ? "공고 상세 정보 보러가기" : "색상 저장하기"
        self.centerButton.setTitle(title: buttonName)
    }
    
    private func handleColorSelection(at index: Int) {
        selectedColorIndexRelay.accept(index)
    }
    
    private func customBinds() {
        self.colorButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            let newMode: AlertMode = self.currentMode == .info ? .color : .info
            self.switchMode(to: newMode)
        }.disposed(by: disposeBag)
        
        self.selectedColorIndexRelay
            .asObservable()
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                
                colorButton.setBackgroundColor(colors[index], for: .normal)
                self.palettecollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setCustomLayout() {
        view.addSubview(alertView)
        
        alertView.addSubviews(
            JobImageView,
            palettecollectionView,
            mainLabel,
            subLabel,
            sepeartorView,
            dDayLabel,
            detailsVStackView,
            colorButton,
            paletteContainerView,
            centerButton,
            closeButton
        )
        
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(421)
        }
        
        palettecollectionView.snp.makeConstraints {
            $0.top.equalTo(sepeartorView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.height.greaterThanOrEqualTo(88)
        }
        
        JobImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(JobImageView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        colorButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(15)
            $0.leading.equalTo(alertView.snp.leading).offset(24)
            $0.width.equalTo(65)
            $0.height.equalTo(26)
        }
        
        sepeartorView.snp.makeConstraints {
            $0.top.equalTo(colorButton.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.equalTo(sepeartorView.snp.bottom).offset(12)
            $0.leading.equalTo(alertView.snp.leading).offset(24)
        }
        
        deadlineInfoView.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        [deadlineInfoView, workPeriodInfoView, workStartInfoView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(18)
            }
        }
        
        detailsVStackView.snp.makeConstraints {
            $0.top.equalTo(dDayLabel.snp.bottom).offset(8)
            $0.leading.equalTo(alertView.snp.leading).offset(24)
        }
        
        paletteContainerView.snp.makeConstraints {
            $0.top.equalTo(sepeartorView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(34)
            $0.height.equalTo(84)
        }
        
        centerButton.snp.makeConstraints {
            $0.top.equalTo(detailsVStackView.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(30)
        }
    }
    
    private func setNormalLayout() {
        view.addSubview(alertView)
        
        alertView.addSubviews(
            alertImageView,
            mainLabel,
            subLabel,
            centerButton,
            closeButton
        )
        
        mainLabel.do { $0.numberOfLines = 1 } // 기본 3줄로 초기화한 속성을 normal일때 한줄로 처리 해줍니다.
        
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(421)
        }
        
        alertImageView.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(279.02)
            $0.height.equalTo(203)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(alertImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        centerButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.width.height.equalTo(30)
        }
    }
}

// MARK: - Custom Methods

extension CustomAlertViewController {
    /// 이미지 변경
    public func setImage(_ image: UIImage, size: CGSize) {
        self.JobImageView.image = image
        self.JobImageView.snp.updateConstraints {
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        }
    }
    
    /// contentsLabel의 텍스트 변경
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.mainLabel.text = title
        return self
    }
    
    /// 중앙 버튼의 텍스트 변경
    @discardableResult
    public func setCenterButtonTitle(_ title: NSAttributedString) -> Self {
        self.centerButton.changeTitle(attributedString: title)
        return self
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
        let isSelected = indexPath.item == selectedColorIndexRelay.value
        cell.configure(color: color, isSelected: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CustomAlertViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item) 번 터치")
        handleColorSelection(at: indexPath.item)
    }
}
