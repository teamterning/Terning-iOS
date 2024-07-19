//
//  NewHomeViewController.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/19/24.
//

import Foundation

import UIKit
import Then

enum HomaMainSection: Int, CaseIterable {
    case TodayDeadlineUserInfo
    case TodayDeadline
    case FilterInfo
    
    var numberOfItemsInSection: Int {
        switch self {
        case .TodayDeadlineUserInfo, .FilterInfo:
            return 1
        case .TodayDeadline:
            return 0
        }
    }
}

final class NewHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let providers = Providers.homeProvider
    
    var TodayDeadlineLists: [ScrapedAndDeadlineModel] = [] {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    // MARK: - UIComponents
    
    private let rootView = NewHomeView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setRegister()
        fetchTodayDeadlineDatas()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func setRegister() {
        rootView.collectionView.register(ScrapInfoHeaderCell.self, forCellWithReuseIdentifier: ScrapInfoHeaderCell.className)
        rootView.collectionView.register(NonScrapInfoCell.self, forCellWithReuseIdentifier: NonScrapInfoCell.className)
        rootView.collectionView.register(IsScrapInfoViewCell.self, forCellWithReuseIdentifier: IsScrapInfoViewCell.className)
        rootView.collectionView.register(FilterInfoCell.self, forCellWithReuseIdentifier: FilterInfoCell.className)
    }
    
}

extension NewHomeViewController: UICollectionViewDelegate {
    
}

extension NewHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomaMainSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomaMainSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .TodayDeadlineUserInfo, .FilterInfo:
            return section.numberOfItemsInSection
        case .TodayDeadline:
            return TodayDeadlineLists.isEmpty ? 1 : TodayDeadlineLists.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomaMainSection(rawValue: indexPath.section) else {
            fatalError("Section 오류")
        }
        
        switch section {
        case .TodayDeadlineUserInfo:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: ScrapInfoHeaderCell.className, for: indexPath) as? ScrapInfoHeaderCell else { return UICollectionViewCell() }
            return cell
            
        case .TodayDeadline:
            if TodayDeadlineLists.isEmpty {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: NonScrapInfoCell.className, for: indexPath) as? NonScrapInfoCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: IsScrapInfoViewCell.className, for: indexPath) as? IsScrapInfoViewCell else { return UICollectionViewCell() }
                cell.bindData(model: TodayDeadlineLists[indexPath.item])
                return cell
            }
        case .FilterInfo:
            guard let cell = rootView.collectionView.dequeueReusableCell(withReuseIdentifier: FilterInfoCell.className, for: indexPath) as? FilterInfoCell else { return UICollectionViewCell() }
            return cell
        }
    }
}

extension NewHomeViewController {
    private func fetchTodayDeadlineDatas() {
        providers.request(.getHomeToday) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<[ScrapedAndDeadlineModel]>.self)
                        guard let data = responseDto.result else { return }
                        
                        self.TodayDeadlineLists = data
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}
