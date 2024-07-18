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
    
    private let rootView = JobDetailView()
    private let viewModel = JobDetailViewModel()
    private let disposeBag = DisposeBag()
    private var jobDetail: JobDetailModel?
    let internshipAnnouncementId = BehaviorSubject<Int>(value: 0)
    
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
        view.addSubview(rootView)
    }
    
    private func setLayout() {
        rootView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension JobDetailViewController {
    private func setDelegate() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
        rootView.navigationBar.leftButtonAction = { [weak self] in
            guard let self = self else { return }
            self.popOrDismissViewController(animated: true)
        }
    }
}

// MARK: - Bind

extension JobDetailViewController {
    private func bindViewModel() {
        let fetchJobDetail = internshipAnnouncementId
            .flatMapLatest { _ in Observable.just(()) }
        
        let input = JobDetailViewModel.Input(internshipAnnouncementId: internshipAnnouncementId, fetchJobDetail: fetchJobDetail)
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.mainInfo
            .drive(onNext: { [weak self] mainInfo in
                self?.rootView.mainInfo = mainInfo
            })
            .disposed(by: disposeBag)
        
        output.companyInfo
            .drive(onNext: { [weak self] companyInfo in
                self?.rootView.companyInfo = companyInfo
            })
            .disposed(by: disposeBag)
        
        output.summaryInfo
            .drive(onNext: { [weak self] summaryInfo in
                self?.rootView.summaryInfo = summaryInfo
            })
            .disposed(by: disposeBag)
        
        output.detailInfo
            .drive(onNext: { [weak self] detailInfo in
                self?.rootView.detailInfo = detailInfo
            })
            .disposed(by: disposeBag)
        
        output.bottomInfo
            .drive(onNext: { [weak self] bottomInfo in
                self?.rootView.setUrl(bottomInfo.url)
                self?.rootView.setScrapped(bottomInfo.scrapId)
                self?.rootView.setScrapCount(bottomInfo.scrapCount)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.mainInfo.asObservable(),
            output.companyInfo.asObservable(),
            output.summaryInfo.asObservable(),
            output.detailInfo.asObservable()
        ).subscribe(onNext: { [weak self] _, _, _, _ in
            self?.rootView.tableView.reloadData()
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
                  let mainInfo = rootView.mainInfo else {
                return UITableViewCell()
            }
            cell.bind(with: mainInfo)
            cell.selectionStyle = .none
            return cell
        case .companyInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyInfoTableViewCell.className, for: indexPath) as? CompanyInfoTableViewCell,
                  let companyInfo = rootView.companyInfo else {
                return UITableViewCell()
            }
            cell.bind(with: companyInfo)
            cell.selectionStyle = .none
            return cell
        case .summaryInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryInfoTableViewCell.className, for: indexPath) as? SummaryInfoTableViewCell,
                  let summaryInfo = rootView.summaryInfo else {
                return UITableViewCell()
            }
            cell.bind(with: summaryInfo)
            cell.selectionStyle = .none
            return cell
        case .detailInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoTableViewCell.className, for: indexPath) as? DetailInfoTableViewCell,
                  let detailInfo = rootView.detailInfo else {
                return UITableViewCell()
            }
            cell.bind(with: detailInfo)
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
