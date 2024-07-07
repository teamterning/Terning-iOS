//
//  CustomAlertViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/7/24.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

import SnapKit
import Then

enum AlertMode {
    case info
    case color
}

final class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var centerButtonTapAction: (() -> Void)?
    
    private var disposeBag = DisposeBag()
    private var currentMode: AlertMode = .info
    
    private let selectedColorIndexRelay = BehaviorRelay<Int>(value: 0)
    
    // MARK: - UI Components
    
    private let alertView = UIView()
    
    private lazy var PalettecollectionView: UICollectionView = {
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
        $0.image = UIImage(resource: .icHome)
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.makeBorder(width: 1, color: .terningMain)
    }
    
    private let titleLabel = LabelFactory.build(
        text: "[한양대학교 컬렉티브임팩트센터] /코이카 영프로페셔널(YP) 모집합니다",
        font: .title4,
        textColor: .grey500
    ).then {
        $0.numberOfLines = 3
    }
    
    private let infoView = LabelFactory.build(
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
        self.setLayout()
        self.bindViews()
        switchMode(to: .info)
    }
}

// MARK: - UI & Layout

extension CustomAlertViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12
    }
    
    private func setLayout() {
        view.addSubview(alertView)
        
        alertView.addSubviews(
            JobImageView,
            PalettecollectionView,
            titleLabel,
            infoView,
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
        
        PalettecollectionView.snp.makeConstraints {
            $0.top.equalTo(sepeartorView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.height.greaterThanOrEqualTo(88)
        }
        
        JobImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(JobImageView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        colorButton.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(15)
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
}

// MARK: - Methods

extension CustomAlertViewController {
    public func setData(model: JobDetailModel) {
        self.JobImageView.setImage(with: model.companyImage)
        self.titleLabel.text = model.title
        self.dDayLabel.text = model.dDay
        self.deadlineInfoView.setDescriptionText(description: model.deadline)
        self.workPeriodInfoView.setDescriptionText(description: model.workingPeriod)
        self.workStartInfoView.setDescriptionText(description: model.startDate)
    }
    
    private func bindViews() {
        self.centerButton.rx.tap.subscribe { _ in
            self.centerButtonTapAction?()
        }.disposed(by: disposeBag)
        
        self.colorButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            let newMode: AlertMode = self.currentMode == .info ? .color : .info
            self.switchMode(to: newMode)
        }.disposed(by: disposeBag)
        
        self.closeButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: false)
        }.disposed(by: disposeBag)
        
        self.selectedColorIndexRelay
            .asObservable()
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                
                colorButton.setBackgroundColor(colors[index], for: .normal)
                self.PalettecollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func switchMode(to mode: AlertMode) {
        self.currentMode = mode
        let isInfoMode = mode == .info
        
        self.detailsVStackView.isHidden = !isInfoMode
        self.dDayLabel.isHidden = !isInfoMode
        self.PalettecollectionView.isHidden = isInfoMode
    }
    
    private func handleColorSelection(at index: Int) {
        selectedColorIndexRelay.accept(index)
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
        self.titleLabel.text = title
        return self
    }
    
    /// 중앙 버튼의 텍스트 변경
    @discardableResult
    public func setLeftButtonTitle(_ title: NSAttributedString) -> Self {
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