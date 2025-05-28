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
            
        case .toggle(let isOn, _):
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
            
            toggleAction = { isOn in
                UserManager.shared.updatePushStatus(isEnabled: isOn)
                print("📬 푸시 상태 서버에 업데이트: \(isOn)")

                if isOn {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        DispatchQueue.main.async {
                            if granted {
                                UIApplication.shared.registerForRemoteNotifications()
                            } else {
                                print("❗️ 알림 권한 거부됨 ❗️")
                                toggle.setOn(false, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
        horizontalStickView.isHidden = isLastCellInSection
    }
}

// MARK: - @objc Function

extension MyPageBasicViewCell {
    @objc
    private func toggleChanged(_ sender: UISwitch) {
        let isOn = sender.isOn
        print("🔄 알림 토글 변경됨: \(isOn)")
        
        if isOn {
            // 1. 현재 알림 권한 상태 확인
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .denied {
                        // 2. 알림 권한 꺼져 있음 → 사용자에게 안내
                        let alert = UIAlertController(
                            title: "알림 권한이 꺼져있어요",
                            message: "설정에서 알림 권한을 켜주세요.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                                
                                // 설정 이동 → 스위치 다시 false로 돌려놓기
                                sender.setOn(false, animated: true)
                            }
                        })
                        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
                            sender.setOn(false, animated: true)
                        })
                        
                        if let topVC = UIApplication.shared.topMostViewController {
                            topVC.present(alert, animated: true)
                        }
                    } else {
                        // ✅ 권한 있음 → 서버로 상태 반영
                        self.toggleAction?(true)
                    }
                }
            }
        } else {
            // ✅ 꺼졌을 때 서버로 상태 반영
            toggleAction?(false)
        }
    }
}
