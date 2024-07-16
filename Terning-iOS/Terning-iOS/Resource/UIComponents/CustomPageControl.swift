//
//  CustomPageControl.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/16/24.
//

import UIKit

import RxSwift
import RxCocoa

final class CustomPageControl: UIView {
    
    // MARK: - Properties
    
    var numberOfPages: Int = 0 {
        didSet {
            updateDots()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateDots()
        }
    }
    
    var pageIndicatorTintColor: UIColor = .white {
        didSet {
            updateDots()
        }
    }
    
    var currentPageIndicatorTintColor: UIColor = .terningMain {
        didSet {
            updateDots()
        }
    }
    
    var dotTapped = PublishSubject<Int>()
    
    // MARK: - UI Components
    
    private var dots: [UIView] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
}

// MARK: - UI & Layout

extension CustomPageControl {
    private func setUI() {
        updateDots()
    }
    
    private func updateDots() {
        dots.forEach { $0.removeFromSuperview() }
        dots = []
        
        for i in 0..<numberOfPages {
            let dot = UIView()
            dot.backgroundColor = i == currentPage ? currentPageIndicatorTintColor : pageIndicatorTintColor
            dot.layer.cornerRadius = 3
            dot.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dot)
            dots.append(dot)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDotTap(_:)))
            dot.addGestureRecognizer(tapGestureRecognizer)
            dot.isUserInteractionEnabled = true
            
            dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 6).isActive = true
            dot.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            if i == 0 {
                dot.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            } else {
                dot.leadingAnchor.constraint(equalTo: dots[i - 1].trailingAnchor, constant: 10).isActive = true
            }
            
            if i == numberOfPages - 1 {
                dot.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }
        }
    }
}

// MARK: - @objc func

extension CustomPageControl {
    @objc
    private func handleDotTap(_ sender: UITapGestureRecognizer) {
        guard let selectedDot = sender.view, let index = dots.firstIndex(of: selectedDot) else {
            return
        }
        currentPage = index
        dotTapped.onNext(index)
    }
}
