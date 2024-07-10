//
//  CustomProgressView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/9/24.
//

import UIKit

import SnapKit

final class CustomProgressView: UIView {
    
    // MARK: - Properties
    
    private var circleSize: CGFloat
    private var lineLength: CGFloat
    private var totalSteps: Int
    
    // MARK: - UI Components
    
    private var circleViews: [UIView] = []
    private var labelViews: [UILabel] = []
    private var lineViews: [UIView] = []
    
    // MARK: - Init
    
    init(
        currentStep: Int,
        totalSteps: Int,
        circleSize: CGFloat,
        lineLength: CGFloat
    ) {
        
        self.circleSize = circleSize
        self.lineLength = lineLength
        self.totalSteps = totalSteps
        
        super.init(frame: .zero)
        
        self.setUI()
        self.setLayout()
        self.setStep(currentStep: currentStep)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomProgressView {
    private func setUI() {
        for step in 1...totalSteps {
            let circleView = UIView().then {
                $0.layer.cornerRadius = circleSize / 2
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.grey200.cgColor
                $0.backgroundColor = .grey300
            }
            let labelView = UILabel().then {
                $0.text = "\(step)"
                $0.textColor = .white
                $0.textAlignment = .center
                $0.font = .button3
            }
            
            addSubviews(
                circleView,
                labelView
            )
            
            circleViews.append(circleView)
            labelViews.append(labelView)
            
            if step < totalSteps {
                let lineView = UIView().then {
                    $0.backgroundColor = .grey400
                }
                addSubview(lineView)
                lineViews.append(lineView)
            }
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(circleSize)
        }
        
        guard circleViews.count == totalSteps else { return }
        
        for index in 0..<totalSteps {
            let circleView = circleViews[index]
            let labelView = labelViews[index]
            
            circleView.snp.makeConstraints {
                $0.width.height.equalTo(circleSize)
                $0.centerY.equalToSuperview()
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(circleViews[index - 1].snp.trailing).offset(lineLength)
                }
            }
            
            labelView.snp.makeConstraints {
                $0.edges.equalTo(circleView)
            }
            
            if index < lineViews.count {
                let lineView = lineViews[index]
                lineView.snp.makeConstraints {
                    $0.height.equalTo(1)
                    $0.centerY.equalToSuperview()
                    $0.leading.equalTo(circleView.snp.trailing)
                    $0.trailing.equalTo(circleViews[index + 1].snp.leading)
                }
            }
        }
        
        circleViews.last?.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
    }
    
    
    // MARK: - Methods
    
    /// 현재 step만큼 색상 변경
    func setStep(currentStep: Int) {
        for (index, circleView) in circleViews.enumerated() {
            circleView.backgroundColor = index < currentStep ? .terningMain : .grey300
            circleView.layer.borderColor = index < currentStep ? UIColor.calRed.cgColor : UIColor.grey200.cgColor
        }
        
        for (index, lineView) in lineViews.enumerated() {
            lineView.backgroundColor = index < currentStep - 1 ? .terningMain : .grey400
        }
    }
}
