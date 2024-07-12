//
//  JobDetailViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

@frozen
enum JobDetailInfoType: Int, CaseIterable {
    case mainInfo = 0
    case companyInfo = 1
    case summaryInfo = 2
    case detailInfo = 3
}

final class JobDetailViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let jobDetailView = JobDetailView()
    private let viewModel = JobDetailViewModel()
    private let disposeBag = DisposeBag()
    private var jobDetail: JobDetailModel?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        setDelegate()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension JobDetailViewController {
    private func setUI() {
        view.addSubview(jobDetailView)
    }
    
    private func setLayout() {
        jobDetailView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension JobDetailViewController {
    private func setDelegate() {
        jobDetailView.tableView.dataSource = self
        jobDetailView.tableView.delegate = self
    }
}

// MARK: - Bind

extension JobDetailViewController {
    private func bindViewModel() {
        let input = JobDetailViewModel.Input(fetchJobDetail: Observable.just(()))
        
        let output = viewModel.transform(input)
        
        output.mainInfo
            .drive(onNext: { [weak self] mainInfo in
                self?.jobDetailView.mainInfo = mainInfo
            })
            .disposed(by: disposeBag)
        
        output.companyInfo
            .drive(onNext: { [weak self] companyInfo in
                self?.jobDetailView.companyInfo = companyInfo
            })
            .disposed(by: disposeBag)
        
        output.summaryInfo
            .drive(onNext: { [weak self] summaryInfo in
                self?.jobDetailView.summaryInfo = summaryInfo
            })
            .disposed(by: disposeBag)
        
        output.detailInfo
            .drive(onNext: { [weak self] detailInfo in
                self?.jobDetailView.detailInfo = detailInfo
            })
            .disposed(by: disposeBag)
        
        output.bottomInfo
            .drive(onNext: { [weak self] bottomInfo in
                self?.jobDetailView.setUrl(bottomInfo.url)
                self?.jobDetailView.setScrapped(bottomInfo.isScrap)
                self?.jobDetailView.setScrapCount(bottomInfo.scrapCount)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.mainInfo.asObservable(),
            output.companyInfo.asObservable(),
            output.summaryInfo.asObservable(),
            output.detailInfo.asObservable()
        ).subscribe(onNext: { [weak self] _, _, _, _ in
            self?.jobDetailView.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension JobDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return JobDetailInfoType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = JobDetailInfoType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case .mainInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainInfoTableViewCell.className, for: indexPath) as? MainInfoTableViewCell,
                  let mainInfo = jobDetailView.mainInfo else {
                return UITableViewCell()
            }
            cell.configure(with: mainInfo)
            cell.selectionStyle = .none
            return cell
        case .companyInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyInfoTableViewCell.className, for: indexPath) as? CompanyInfoTableViewCell,
                  let companyInfo = jobDetailView.companyInfo else {
                return UITableViewCell()
            }
            cell.configure(with: companyInfo)
            cell.selectionStyle = .none
            return cell
        case .summaryInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryInfoTableViewCell.className, for: indexPath) as? SummaryInfoTableViewCell,
                  let summaryInfo = jobDetailView.summaryInfo else {
                return UITableViewCell()
            }
            cell.configure(with: summaryInfo)
            cell.selectionStyle = .none
            return cell
        case .detailInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoTableViewCell.className, for: indexPath) as? DetailInfoTableViewCell,
                  let detailInfo = jobDetailView.detailInfo else {
                return UITableViewCell()
            }
            cell.configure(with: detailInfo)
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension JobDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = JobDetailInfoType(rawValue: section) else { return nil }
        
        switch sectionType {
        case .companyInfo, .summaryInfo, .detailInfo:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: JobDetailTableViewHeaderView.className) as? JobDetailTableViewHeaderView else {
                return nil
            }
            
            let title: String
            switch sectionType {
            case .companyInfo:
                title = "기업 정보"
            case .summaryInfo:
                title = "공고 요약"
            case .detailInfo:
                title = "상세 정보"
            default:
                return nil
            }
            headerView.setTitle(title)
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
}
