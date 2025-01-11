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
    private var itemSpacing: CGFloat = 24
    private var underline: Bool
    private var items: [String]
    
    // MARK: - Init
    
    init(items: [String], underbarInfo info: UnderbarInfo, itemSpacing: CGFloat = 24, underline: Bool = true) {
        self.items = items
        self.underbarInfo = info
        self.itemSpacing = itemSpacing
        self.underline = underline
        
        super.init(items: items)
        setUI()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isFirstSettingDone {
            isFirstSettingDone.toggle()
            setupItemBackgrounds()
            if underline {
                setUnderbarMovableBackgroundLayer()
            }
            layer.masksToBounds = false
        }
        
        updateLabelColors()
        updateUnderbarPosition()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var xOffset: CGFloat = 0
        
        for index in 0..<numberOfSegments {
            let textWidth = calculateTextWidth(for: index)
            let segmentWidth = textWidth
            let segmentFrame = CGRect(x: xOffset, y: 0, width: segmentWidth, height: bounds.height)
            
            if segmentFrame.contains(point) {
                self.selectedSegmentIndex = index
                sendActions(for: .valueChanged)
                return self
            }
            xOffset += (segmentWidth + itemSpacing)
        }
        return nil
    }
}

// MARK: - UI & Layout

private extension CustomSegmentedControl {
    private func setUI() {
        removeBorders()
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.title4
        ]
        setTitleTextAttributes(normalTextAttributes, for: .normal)
        selectedSegmentTintColor = .clear
        selectedSegmentIndex = 0
    }
    
    private func setAddTarget() {
        addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
    
    private func setupItemBackgrounds() {
        for index in 0..<numberOfSegments {
            let frame = frameForSegment(at: index)
            addBackgroundView(for: frame, at: index)
        }
    }
    
    private func makeUnderbar() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = underbarInfo.highlightColor
        addSubview(view)
        return view
    }

    private func removeBorders() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
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
    
    private func updateUnderbarPosition() {
        let selectedSegmentFrame = frameForSegment(at: selectedSegmentIndex)
        let textWidth = calculateTextWidth(for: selectedSegmentIndex)
        
        underbar.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.17, delay: 0, options: .curveLinear, animations: {
            self.underbar.frame = CGRect(
                x: selectedSegmentFrame.origin.x + (selectedSegmentFrame.width - textWidth) / 2,
                y: self.bounds.height - self.underbarInfo.height,
                width: selectedSegmentFrame.width,
                height: self.underbarInfo.height
            )
            self.layoutIfNeeded()
        })
    }
    
    private func updateLabelColors() {
        for index in 0..<numberOfSegments {
            if let backgroundView = subviews.first(where: { $0.tag == 999 + index }),
               let label = backgroundView.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.textColor = (selectedSegmentIndex == index) ? .terningMain : .grey300
            }
        }
    }
}

// MARK: - Methods

extension CustomSegmentedControl {
    private func frameForSegment(at index: Int) -> CGRect {
        let xOffset = (0..<index).reduce(0) { result, idx in
            result + calculateTextWidth(for: idx) + itemSpacing
        }
        let itemWidth = calculateTextWidth(for: index)
        return CGRect(x: xOffset, y: 0, width: itemWidth, height: bounds.height)
    }

    private func addBackgroundView(for frame: CGRect, at index: Int) {
        subviews.filter { $0.tag == 999 + index }.forEach { $0.removeFromSuperview() }
        
        let textWidth = calculateTextWidth(for: index)
        let segmentFrame = frameForSegment(at: index)
        
        let backgroundFrame = CGRect(
            x: segmentFrame.origin.x + (segmentFrame.width - textWidth) / 2,
            y: 0,
            width: textWidth,
            height: bounds.height
        )
        let backgroundView = UIView(frame: backgroundFrame)
        backgroundView.tag = 999 + index
        
        let label = UILabel(frame: backgroundView.bounds)
        label.text = titleForSegment(at: index)
        label.textColor = (index == selectedSegmentIndex) ? .terningMain : .grey300
        label.font = UIFont.title4
        label.textAlignment = .center
        label.tag = 1000 + index

        backgroundView.addSubview(label)
        insertSubview(backgroundView, at: 0)
    }

    private func calculateTextWidth(for index: Int) -> CGFloat {
        guard let title = titleForSegment(at: index),
              let font = titleTextAttributes(for: .normal)?[.font] as? UIFont else { return 0 }
        
        let size = (title as NSString).size(withAttributes: [.font: font])
        return size.width
    }
}

// MARK: - @objc func

extension CustomSegmentedControl {
    @objc
    private func segmentValueChanged() {
        updateLabelColors()
    }
}
