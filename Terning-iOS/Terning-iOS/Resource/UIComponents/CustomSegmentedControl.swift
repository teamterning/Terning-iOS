//
//  CustomSegmentedControl.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/17/24.
//

import UIKit

import SnapKit
import Then

struct UnderbarInfo {
    var height: CGFloat
    var highlightColor: UIColor
    var backgroundColor: UIColor
}

final class CustomSegmentedControl: UISegmentedControl {
    
    // MARK: - Properties
    
    private lazy var underbar: UIView = makeUnderbar()
    private var underbarInfo: UnderbarInfo
    private var isFirstSettingDone = false
    private var underline: Bool
    
    // MARK: - Init
    
    init(items: [Any]?, underbarInfo info: UnderbarInfo, underline: Bool = true) {
        self.underbarInfo = info
        self.underline = underline
        super.init(items: items)
        setUI()
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isFirstSettingDone {
            isFirstSettingDone.toggle()
            if underline {
                setUnderbarMovableBackgroundLayer()
            }
            layer.masksToBounds = false
        }
        updateUnderbarPosition()
    }
}

// MARK: - UI & Layout

private extension CustomSegmentedControl {
    private func setUI() {
        removeBorders()
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: underbarInfo.backgroundColor,
            .font: UIFont.title4
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: underbarInfo.highlightColor,
            .font: UIFont.title4
        ]
        
        setTitleTextAttributes(normalTextAttributes, for: .normal)
        setTitleTextAttributes(selectedTextAttributes, for: .selected)
        selectedSegmentTintColor = .clear
    }
    
    private func setUnderbarMovableBackgroundLayer() {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = .init(
            x: 0,
            y: bounds.height,
            width: bounds.width,
            height: 1
        )
        backgroundLayer.backgroundColor = underbarInfo.backgroundColor.cgColor
        layer.addSublayer(backgroundLayer)
    }
    
    private func makeUnderbar() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = underbarInfo.highlightColor
        addSubview(view)
        return view
    }
    
    private func updateUnderbarPosition() {
        let selectedSegmentFrame = frameForSegment(at: selectedSegmentIndex)
        let textWidth = calculateTextWidth(for: selectedSegmentIndex)
        
        UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseOut, animations: {
            self.underbar.frame = CGRect(
                x: selectedSegmentFrame.origin.x + (selectedSegmentFrame.width - textWidth) / 2,
                y: self.bounds.height - self.underbarInfo.height,
                width: textWidth,
                height: self.underbarInfo.height
            )
        })
    }
    
    private func removeBorders() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}

// MARK: - Methods

extension CustomSegmentedControl {
    private func frameForSegment(at index: Int) -> CGRect {
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        return CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: bounds.height)
    }
    
    private func calculateTextWidth(for index: Int) -> CGFloat {
        guard let title = titleForSegment(at: index),
              let font = titleTextAttributes(for: .normal)?[.font] as? UIFont else { return 0 }
        
        let size = (title as NSString).size(withAttributes: [.font: font])
        return size.width
    }
}
