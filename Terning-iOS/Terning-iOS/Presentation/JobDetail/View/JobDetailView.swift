//
//  JobDetailView.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class JobDetailView: UIView {
    
    // MARK: - Properties
    
    private var internshipAnnouncementId: Int?
    var mainInfo: MainInfoModel?
    var companyInfo: CompanyInfoModel?
    var summaryInfo: SummaryInfoModel?
    var conditionInfo: ConditionInfoModel?
    var detailInfo: DetailInfoModel?
    private var url: String?
    
    // MARK: - UI Components
    
    let navigationBar = CustomNavigationBar(type: .centerTitleWithLeftButton)
    
    let shareButton = UIButton(type: .custom).then {
        $0.setImage(.icShare, for: .normal)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowOffset = CGSize(width: 0, height: -4)
        $0.layer.shadowRadius = 2
        $0.layer.masksToBounds = false
    }
    
    var scrapLabel = LabelFactory.build(
        text: "1004회",
        font: .detail3,
        textColor: .grey400,
        lineSpacing: 1.2,
        characterSpacing: 0.002
    )
    
    let scrapButton = UIButton(type: .custom).then {
        $0.setImage(.icScrap, for: .normal)
        $0.setImage(.icScrap, for: [.normal, .highlighted])
        $0.setImage(.icScrapFill, for: .selected)
        $0.setImage(.icScrapFill, for: [.selected, .highlighted])
    }
    
    var goSiteButton = TerningCustomButton(title: "지원 사이트로 이동하기", font: .button2, radius: 10)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension JobDetailView {
    private func setUI() {
        navigationBar.setTitle("공고 상세 정보")
        
        tableView.register(CompanyInfoTableViewCell.self, forCellReuseIdentifier: CompanyInfoTableViewCell.className)
        tableView.register(MainInfoTableViewCell.self, forCellReuseIdentifier: MainInfoTableViewCell.className)
        tableView.register(SummaryInfoTableViewCell.self, forCellReuseIdentifier: SummaryInfoTableViewCell.className)
        tableView.register(DetailInfoTableViewCell.self, forCellReuseIdentifier: DetailInfoTableViewCell.className)
        tableView.register(JobDetailTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: JobDetailTableViewHeaderView.className)
        tableView.backgroundColor = .white
    }
    
    private func setLayout() {
        self.addSubviews(navigationBar, tableView, bottomView)
        
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        navigationBar.addSubview(shareButton)
        
        shareButton.snp.makeConstraints {
            $0.trailing.equalTo(navigationBar.snp.trailing).inset(18)
            $0.centerY.equalTo(navigationBar.snp.centerY)
            $0.height.width.equalTo(32)
        }
        
        bottomView.addSubviews(scrapLabel, scrapButton, goSiteButton)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(68)
        }
        
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        scrapLabel.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.bottom).inset(9)
            $0.leading.equalTo(bottomView.snp.leading).inset(21)
            $0.width.equalTo(45)
        }
        
        scrapButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).inset(16)
            $0.centerX.equalTo(scrapLabel.snp.centerX)
        }
        
        goSiteButton.snp.makeConstraints {
            $0.top.equalTo(bottomView.snp.top).inset(10)
            $0.leading.equalTo(scrapLabel.snp.trailing).offset(12)
            $0.trailing.equalTo(bottomView.snp.trailing).inset(20)
            $0.height.equalTo(48)
        }
    }
}

// MARK: - Public Methods

extension JobDetailView {
    func setUrl(_ url: String?) {
        self.url = url
    }
    
    func setScrapped(_ isScrapped: Bool) {
        scrapButton.isSelected = isScrapped
    }
    
    func setScrapCount(_ count: Int) {
        scrapLabel.text = "\(count)회"
    }
}
