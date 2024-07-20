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
    
    // MARK: - Properties
    
    private var scarpNum: Int = 0
    
    private let colorIndexMapping: [Int: Int] = [
        0: 0,  // calRed
        1: 2,  // calOrange2
        2: 4,  // calGreen1
        3: 6,  // calBlue1
        4: 8,  // calPurple
        5: 1,  // calOrange
        6: 3,  // calYellow
        7: 5,  // calGreen2
        8: 7,  // calBlue2
        9: 9   // calPink
    ]
    
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
    
    private func parseStartDate(_ startDate: String) -> (year: Int?, month: Int?)  {
        let dateComponents = startDate.components(separatedBy: "년 ")
        guard dateComponents.count == 2 else { return (nil, nil) }
        
        let yearString = dateComponents[0]
        let monthString = dateComponents[1].replacingOccurrences(of: "월", with: "")
        
        let year = Int(yearString.trimmingCharacters(in: .whitespaces))
        let month = Int(monthString.trimmingCharacters(in: .whitespaces))
        
        return (year, month)
    }
    
    private func scrapAnnouncementWithCompletion(internshipAnnouncementId: Int, color: Int, completion: @escaping (Bool) -> Void) {
        self.scrapAnnouncement(internshipAnnouncementId: internshipAnnouncementId, color: color)
        completion(true)
    }
}

// MARK: - @objc func

extension JobDetailViewController {
    @objc
    private func scrapButtonDidTapped() {
        do {
            let currentId = try internshipAnnouncementId.value()
            print(currentId)
            
            if let jobDetail = jobDetail {
                let startDateComponents = parseStartDate(jobDetail.startDate)
                
                if jobDetail.scrapId == nil {
                    let dailyScrapModel = DailyScrapModel(
                        scrapId: jobDetail.scrapId ?? 0,
                        title: jobDetail.title,
                        color: "#ED4E54",
                        internshipAnnouncementId: currentId,
                        dDay: jobDetail.dDay,
                        workingPeriod: jobDetail.workingPeriod,
                        companyImage: jobDetail.companyImage,
                        startYear: startDateComponents.year,
                        startMonth: startDateComponents.month
                    )
                    
                    let alertSheet = CustomAlertViewController(alertType: .custom, customType: .scrap)
                    alertSheet.setData2(model: dailyScrapModel, deadline: jobDetail.deadline)
                    
                    alertSheet.modalTransitionStyle = .crossDissolve
                    alertSheet.modalPresentationStyle = .overFullScreen
                    
                    alertSheet.centerButtonTapAction = { [weak self] in
                        guard let self = self else { return }
                        
                        let colorIndex = alertSheet.selectedColorIndexRelay
                        
                        self.scrapAnnouncementWithCompletion(
                            internshipAnnouncementId: currentId,
                            color: self.colorIndexMapping[colorIndex.value] ?? 0
                        ) { success in
                            if success {
                                JobDetailView().scrapButton.isSelected = true
                                JobDetailView().scrapButton.updateImage()
                                JobDetailView().scrapLabel.text = "\(self.scarpNum + 1)"
                                self.showToast(message: "관심 공고가 캘린더에 스크랩되었어요!")
                            }
                            self.dismiss(animated: false)
                        }
                    }
                    
                    self.present(alertSheet, animated: false)
                } else {
                    // 스크랩 취소
                    let alertSheet = CustomAlertViewController(alertType: .normal)
                    
                    alertSheet.setComponentDatas(
                        mainLabel: "관심 공고가 캘린더에서 사라져요!",
                        subLabel: "스크랩을 취소하시겠어요?",
                        buttonLabel: "스크랩 취소하기"
                    )
                    
                    alertSheet.modalTransitionStyle = .crossDissolve
                    alertSheet.modalPresentationStyle = .overFullScreen
                    
                    alertSheet.centerButtonTapAction = { [weak self] in
                        guard let self = self else { return }
                        self.cancelScrapAnnouncement(scrapId: jobDetail.scrapId ?? -1)
                        self.dismiss(animated: false)
                       
                        JobDetailView().scrapButton.isSelected = false
                        JobDetailView().scrapButton.updateImage()
                        JobDetailView().scrapLabel.text = "\(scarpNum - 1)"
                        
                        self.showToast(message: "관심 공고가 캘린더에서 사라졌어요!")
                    }
                    
                    self.present(alertSheet, animated: false)
                }
            } else {
                print("jobDetail 없음")
            }
        } catch {
            print("Error retrieving currentId: \(error.localizedDescription)")
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
        
        output.jobDetailInfo
            .drive(onNext: { [weak self] jobDetailInfo in
                self?.jobDetail = jobDetailInfo
            })
            .disposed(by: disposeBag)
        
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
                self?.rootView.scrapButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        output.bottomInfo
            .drive(onNext: { [weak self] bottomInfo in
                self?.rootView.setUrl(bottomInfo.url)
                self?.rootView.setScrapped(bottomInfo.scrapId)
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

// MARK: - API
    
extension JobDetailViewController {
    private func patchScrapAnnouncement(scrapId: Int?, color: Int) {
        guard let scrapId = scrapId else { return }
        Providers.scrapsProvider.request(.patchScrap(scrapId: scrapId, color: color)) { [weak self] result in
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
    
    private func cancelScrapAnnouncement(scrapId: Int?) {
        guard let scrapId = scrapId else { return }
        Providers.scrapsProvider.request(.removeScrap(scrapId: scrapId)) { [weak self] result in
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
