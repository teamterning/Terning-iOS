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
    case companyInfo = 0
    case mainInfo = 1
    case summaryInfo = 2
    case conditionInfo = 3
    case detailInfo = 4
}

final class JobDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var scarpNum: Int = 0
    
    // MARK: - UI Components
    
    private let rootView = JobDetailView()
    private let viewModel = JobDetailViewModel()
    private let disposeBag = DisposeBag()
    private var jobDetail: JobDetailModel?
    let internshipAnnouncementId = BehaviorRelay<Int>(value: 0)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setLayout()
        setDelegate()
        setButtonAction()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension JobDetailViewController {
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
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
    
    private func setButtonAction() {
        self.rootView.scrapButton.addTarget(self, action: #selector(scrapButtonDidTapped), for: .touchUpInside)
    }
    
    private func parseStartDate(_ startDate: String) -> (year: Int?, month: Int?) {
        let dateComponents = startDate.components(separatedBy: "년 ")
        guard dateComponents.count == 2 else { return (nil, nil) }
        
        let yearString = dateComponents[0]
        let monthString = dateComponents[1].replacingOccurrences(of: "월", with: "")
        
        let year = Int(yearString.trimmingCharacters(in: .whitespaces))
        let month = Int(monthString.trimmingCharacters(in: .whitespaces))
        
        return (year, month)
    }
    
    private func scrapAnnouncementWithCompletion(internshipAnnouncementId: Int, color: String, completion: @escaping (Bool) -> Void) {
        self.scrapAnnouncement(internshipAnnouncementId: internshipAnnouncementId, color: color)
        completion(true)
    }
}

// MARK: - @objc func

extension JobDetailViewController {
    @objc
    private func scrapButtonDidTapped() {
        
    }
}

    // MARK: - Bind
    
extension JobDetailViewController {
    private func bindViewModel() {
        let fetchJobDetail = internshipAnnouncementId
            .flatMapLatest { _ in Observable.just(()) }
        
        let input = JobDetailViewModel.Input(internshipAnnouncementId: internshipAnnouncementId, fetchJobDetail: fetchJobDetail)
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.jobDetailInfo
            .drive(onNext: { [weak self] jobDetailInfo in
                self?.jobDetail = jobDetailInfo
            })
            .disposed(by: disposeBag)
        
        output.companyInfo
            .drive(onNext: { [weak self] companyInfo in
                self?.rootView.companyInfo = companyInfo
            })
            .disposed(by: disposeBag)
        
        output.mainInfo
            .drive(onNext: { [weak self] mainInfo in
                self?.rootView.mainInfo = mainInfo
            })
            .disposed(by: disposeBag)
        
        output.summaryInfo
            .drive(onNext: { [weak self] summaryInfo in
                self?.rootView.summaryInfo = summaryInfo
            })
            .disposed(by: disposeBag)
        
        output.conditionInfo
            .drive(onNext: { [weak self] conditionInfo in
                self?.rootView.conditionInfo = conditionInfo
            })
            .disposed(by: disposeBag)
        
        output.detailInfo
            .drive(onNext: { [weak self] detailInfo in
                self?.rootView.detailInfo = detailInfo
                self?.rootView.scrapButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        output.bottomInfo
            .drive(onNext: { [weak self] bottomInfo in
                self?.rootView.setUrl(bottomInfo.url)
                self?.rootView.setScrapped(bottomInfo.isScrapped)
                self?.scarpNum = bottomInfo.scrapCount
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
        case .companyInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyInfoTableViewCell.className, for: indexPath) as? CompanyInfoTableViewCell,
                  let companyInfo = rootView.companyInfo else {
                return UITableViewCell()
            }
            cell.bind(with: companyInfo)
            cell.selectionStyle = .none
            return cell
        case .mainInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainInfoTableViewCell.className, for: indexPath) as? MainInfoTableViewCell,
                  let mainInfo = rootView.mainInfo else {
                return UITableViewCell()
            }
            cell.bind(with: mainInfo)
            cell.selectionStyle = .none
            return cell
        case .summaryInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryInfoTableViewCell.className, for: indexPath) as? SummaryInfoTableViewCell,
                  let summaryInfo = rootView.summaryInfo else {
                return UITableViewCell()
            }
            cell.bind(with: summaryInfo.items)
            cell.selectionStyle = .none
            return cell
        case .conditionInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryInfoTableViewCell.className, for: indexPath) as? SummaryInfoTableViewCell,
                  let conditionInfo = rootView.conditionInfo else {
                return UITableViewCell()
            }
            cell.bind(with: conditionInfo.items)
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
        case .summaryInfo, .conditionInfo, .detailInfo:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: JobDetailTableViewHeaderView.className) as? JobDetailTableViewHeaderView else {
                return nil
            }
            
            let title: String
            switch sectionType {
            case .summaryInfo:
                title = "공고 요약"
            case .conditionInfo:
                title = "자격 요건"
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

// MARK: - API
    
extension JobDetailViewController {
    private func patchScrapAnnouncement(internshipAnnouncementId: Int?, color: String) {
        guard let intershipAnnouncementId = internshipAnnouncementId else { return }
        Providers.scrapsProvider.request(.patchScrap(internshipAnnouncementId: intershipAnnouncementId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 수정 성공")
                    bindViewModel()
                    JobDetailView().tableView.reloadData()
                } else {
                    print("400 error")
                    self.showToast(message: "네트워크 오류")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 오류")
            }
        }
    }
    
    private func cancelScrapAnnouncement(internshipAnnouncementId: Int?) {
        guard let intershipAnnouncementId = internshipAnnouncementId else { return }
        Providers.scrapsProvider.request(.removeScrap(internshipAnnouncementId: intershipAnnouncementId)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 취소 성공")
                    bindViewModel()
                    JobDetailView().tableView.reloadData()
                } else {
                    print("400 error")
                    self.showToast(message: "네트워크 오류")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 오류")
            }
        }
    }
}
