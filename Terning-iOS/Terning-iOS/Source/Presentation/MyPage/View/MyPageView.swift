//
//  MyPageView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import SnapKit

final class MyPageView: UIView {
    
    // MARK: - UI Components
    
    let tableView = UITableView()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .back
        self.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.delaysContentTouches = false

    }
    
    private func setLayout() {
        tableView.snp.makeConstraints {
            $0.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24.adjusted)
        }
    }

    func registerCells() {
        tableView.register(MyPageProfileViewCell.self, forCellReuseIdentifier: MyPageProfileViewCell.className)
        tableView.register(MyPageBasicViewCell.self, forCellReuseIdentifier: MyPageBasicViewCell.className)
        tableView.register(MyPageAccountOptionViewCell.self, forCellReuseIdentifier: MyPageAccountOptionViewCell.className)
    }
}
