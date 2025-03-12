//
//  MyPageBasicViewCell.swift
//  Terning-iOS
//
//  Created by 정민지 on 9/7/24.
//

import UIKit

import SnapKit

@frozen
public enum AccessoryType {
    case none
    case disclosureIndicator
    case label(text: String)
    case toggle(isOn: Bool, action: ((Bool) -> Void)?)
}

final class MyPageBasicViewCell: UITableViewCell {
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let titleLabel = LabelFactory.build(
        font: .body5,
        textAlignment: .left
    )
    
    private var accessoryImageView: UIImageView?
    private var accessoryLabel: UILabel?
    private var toggleSwitch: UISwitch?
    private var toggleAction: ((Bool) -> Void)?
    
    private let horizontalStickView = UIView().then {
        $0.backgroundColor = .grey150
    }
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyPageBasicViewCell {
    private func setUI() {
        contentView.addSubviews(
            profileImageView,
            titleLabel,
            horizontalStickView
        )
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjusted)
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        horizontalStickView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(19.5.adjusted)
            $0.trailing.equalToSuperview().inset(12.5.adjusted)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Methods

extension MyPageBasicViewCell {
    func bind(with viewModel: MyPageBasicCellModel, isLastCellInSection: Bool) {
        profileImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        
        accessoryImageView?.removeFromSuperview()
        accessoryLabel?.removeFromSuperview()
        toggleSwitch?.removeFromSuperview()
        
        accessoryImageView = nil
        accessoryLabel = nil
        toggleSwitch = nil
        
        switch viewModel.accessoryType {
        case .none:
            break
            
        case .disclosureIndicator:
            let imageView = UIImageView().then {
                $0.image = .icFrontArrow
            }
            contentView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(9.adjusted)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(20.adjusted)
                $0.height.equalTo(20.adjusted)
            }
            accessoryImageView = imageView
            
        case .label(let text):
            let label = LabelFactory.build(
                font: .body6,
                textColor: .grey350,
                textAlignment: .right
            )
            label.text = text
            contentView.addSubview(label)
            label.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16.adjusted)
                $0.centerY.equalToSuperview()
            }
            accessoryLabel = label
            
        case .toggle(let isOn, let action):
            let toggle = UISwitch().then {
                $0.isOn = isOn
                $0.onTintColor = .terningMain
                $0.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
            }
            contentView.addSubview(toggle)
            toggle.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16.adjusted)
                $0.centerY.equalToSuperview()
            }
            toggleSwitch = toggle
            toggleAction = action
        }
        horizontalStickView.isHidden = isLastCellInSection
    }
}

// MARK: - @objc Function

extension MyPageBasicViewCell {
    @objc
    private func toggleChanged(_ sender: UISwitch) {
        toggleAction?(sender.isOn)
    }
}
