//
//  UpdateAlertViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 3/18/25.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

final class UpdateAlertViewController: UIViewController {
    
    // MARK: - UpdateViewType
    
    enum UpdateViewType {
        case normal
        case force
        case serviceEnd
    }
    
    // MARK: - Properties

    private let updateViewType: UpdateViewType
    let disposeBag = DisposeBag()

    // MARK: - UIComponents

    private let alertView = UIView()
    private let updateTitle: String
    private let updateDescription: String
    private let serviceEndDate: String?
    private let leftButtonTitle: String
    private let rightButtonTitle: String

    private let titleLabel = LabelFactory.build(
        font: .title2
    )

    private let discriptionLabel = LabelFactory.build(
        font: .body4,
        textColor: .grey400,
        lineSpacing: 1.5,
        characterSpacing: -0.002
    ).then {
        $0.numberOfLines = 0
    }

    // 서비스 종료일 표시용 컨테이너
    private let dateContainerView = UIView().then {
        $0.backgroundColor = .grey100
        $0.layer.cornerRadius = 8
    }

    private let dateTopLabel = LabelFactory.build(
        text: "서비스 종료 예정일",
        font: .body6,
        textColor: .terningBlack
    )

    private let dateLabel = LabelFactory.build(
        font: .detail4,
        textColor: .grey500
    )

    fileprivate let centerButton = TerningCustomButton(title: "업데이트 하러 가기", font: .button3, radius: 8)
    fileprivate lazy var leftButton = TerningCustomButton(title: leftButtonTitle, font: .button3, radius: 8)
    fileprivate lazy var rightButton = TerningCustomButton(title: rightButtonTitle, font: .button3, radius: 8)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setHierarchy(updateViewType)
        setLayout(updateViewType)
    }
    
    // MARK: - Init

    init(updateViewType: UpdateViewType,
         title: String = "",
         discription: String = "",
         serviceEndDate: String? = nil,
         leftButtonTitle: String = "다음에 하기",
         rightButtonTitle: String = "업데이트 하기") {
        self.updateViewType = updateViewType
        self.updateTitle = title
        self.updateDescription = discription
        self.serviceEndDate = serviceEndDate
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .terningBlack.withAlphaComponent(0.3)

        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }

        titleLabel.do {
            $0.text = updateTitle
        }

        discriptionLabel.do {
            $0.text = updateDescription
        }

        if let serviceEndDate = serviceEndDate {
            dateLabel.text = serviceEndDate
        }
    }
    
    private func setHierarchy(_ type: UpdateViewType) {

        view.addSubview(alertView)
        alertView.addSubviews(titleLabel, discriptionLabel)

        switch type {
        case .normal:
            leftButton.setAppearance(
                normalBackgroundColor: .grey150,
                pressedBackgroundColor: .grey200,
                textNormal: .grey350
            )

            alertView.addSubviews(leftButton, rightButton)
        case .force:
            alertView.addSubview(centerButton)
        case .serviceEnd:
            leftButton.setAppearance(
                normalBackgroundColor: .grey150,
                pressedBackgroundColor: .grey200,
                textNormal: .grey350
            )

            alertView.addSubviews(dateContainerView, leftButton, rightButton)
            dateContainerView.addSubviews(dateTopLabel, dateLabel)
        }
    }
    
    private func setLayout(_ type: UpdateViewType) {
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(type == .serviceEnd ? 324.adjustedH : 199.adjustedH)
            $0.width.equalTo(320.adjusted)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alertView.snp.top).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
        }

        discriptionLabel.snp.makeConstraints {
            $0.top.equalTo(type == .serviceEnd ? titleLabel.snp.bottom : alertView.snp.top).offset(type == .serviceEnd ? 20.adjustedH : 32.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(type == .serviceEnd ? 22.adjusted : 52.adjusted)
            if type != .serviceEnd {
                $0.center.equalToSuperview()
            }
        }

        switch type {
        case .normal:
            leftButton.snp.makeConstraints {
                $0.top.equalTo(alertView.snp.top).offset(147.adjustedH)
                $0.leading.equalTo(alertView.snp.leading).offset(16.adjusted)
                $0.width.equalTo(140.adjusted)
                $0.height.equalTo(40.adjustedH)
            }

            rightButton.snp.makeConstraints {
                $0.top.equalTo(alertView.snp.top).offset(147.adjustedH)
                $0.leading.equalTo(leftButton.snp.trailing).offset(8.adjusted)
                $0.width.equalTo(140.adjusted)
                $0.height.equalTo(40.adjustedH)
            }

        case .force:
            centerButton.snp.makeConstraints {
                $0.top.equalTo(alertView.snp.top).offset(147.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(288.adjusted)
                $0.height.equalTo(40.adjustedH)
            }

        case .serviceEnd:
            dateContainerView.snp.makeConstraints {
                $0.top.equalTo(discriptionLabel.snp.bottom).offset(26.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(45.adjusted)
                $0.height.equalTo(68.adjustedH)
            }

            dateTopLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16.adjustedH)
                $0.centerX.equalToSuperview()
            }

            dateLabel.snp.makeConstraints {
                $0.top.equalTo(dateTopLabel.snp.bottom).offset(4.adjustedH)
                $0.centerX.equalToSuperview()
            }

            leftButton.snp.makeConstraints {
                $0.bottom.equalTo(alertView.snp.bottom).offset(-16.adjustedH)
                $0.leading.equalTo(alertView.snp.leading).offset(16.adjusted)
                $0.width.equalTo(140.adjusted)
                $0.height.equalTo(40.adjustedH)
            }

            rightButton.snp.makeConstraints {
                $0.bottom.equalTo(alertView.snp.bottom).offset(-16.adjustedH)
                $0.leading.equalTo(leftButton.snp.trailing).offset(8.adjusted)
                $0.width.equalTo(140.adjusted)
                $0.height.equalTo(40.adjustedH)
            }
        }
    }
}

extension Reactive where Base: UpdateAlertViewController {
    var centerButtonTap: Observable<Void> {
        return base.centerButton.rx.tap.asObservable()
    }
    
    var leftButtonTap: Observable<Void> {
        return base.leftButton.rx.tap.asObservable()
    }
    
    var rightButtonTap: Observable<Void> {
        return base.rightButton.rx.tap.asObservable()
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    
    let title = "터닝 서비스 종료 안내"
    let description = """
    그동안 터닝을 사랑해주신 모든 분들께
    진심으로 감사의 말씀을 드립니다.
    '터닝'은 11월 25일부로 서비스가 종료될 예정이며,
    자세한 사항은 공지 내용을 확인해주세요.
    """
    let serviceEndDate = "2025년 11월 25일"
    
    UpdateAlertViewController(
        updateViewType: .serviceEnd,
        title: title,
        discription: description,
        serviceEndDate: serviceEndDate,
        leftButtonTitle: "닫기",
        rightButtonTitle: "자세히 보기"
    )
}
#endif
