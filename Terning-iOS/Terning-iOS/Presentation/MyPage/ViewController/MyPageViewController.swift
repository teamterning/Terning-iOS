//
//  MyPageViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

struct SectionData {
    let title: String
    let items: [SectionItem]
}

@frozen
public enum SectionItem {
    case userInfoViewModel(UserProfileInfoModel)
    case cellViewModel(MyPageBasicCellModel)
    case emptyCell
}

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var sections: [SectionData] = []
    
    private let fixProfileTapObservable = PublishSubject<Void>()
    private let logoutTapObservable = PublishSubject<Void>()
    private let withdrawTapObservable = PublishSubject<Void>()
    
    private var viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    
    private var myPageView = MyPageView()
    
    // MARK: - Init
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDelegate()
        setPushPermissionObserver()
        bindViewModel()
        myPageView.registerCells()
    }
}

// MARK: - UI & Layout

extension MyPageViewController {
    private func setUI() {
        view.backgroundColor = .back
        view.addSubview(myPageView)
    }
    
    private func setLayout() {
        myPageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind

extension MyPageViewController {
    func bindViewModel() {
        let itemSelected = myPageView.tableView.rx.itemSelected
            .map { [weak self] indexPath -> SectionItem? in
                guard let self = self else { return nil }
                return self.sections[indexPath.section].items[indexPath.row]
            }
            .compactMap { $0 }
            .asObservable()
        
        let input = MyPageViewModel.Input(
            fixProfileTap: fixProfileTapObservable.asObservable(),
            logoutTap: logoutTapObservable.asObserver(),
            withdrawTap: withdrawTapObservable.asObserver(),
            itemSelected: itemSelected
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.sections
            .drive(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.sections = sections
                self.myPageView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.navigateToProfileEdit
            .drive(onNext: { [weak self] userInfo in
                guard let self = self else { return }
                let convertedUserInfo = UserProfileInfoModel(
                    name: userInfo.name,
                    profileImage: userInfo.profileImage,
                    authType: userInfo.authType
                )
                self.navigateToProfileEdit(userInfo: convertedUserInfo)
            })
            .disposed(by: disposeBag)

        output.showLogoutAlert
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.logoutButtonDidTap()
            })
            .disposed(by: disposeBag)
        
        output.showWithdrawAlert
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.withdrawButtonDidTap()
            })
            .disposed(by: disposeBag)
        
        output.cellTapped
            .drive(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .nonAction:
                    break
                case .showNotice:
                    self.showNotice()
                case .sendFeedback:
                    self.sendFeedback()
                case .showTermsOfUse:
                    self.showTermsOfUse()
                case .showPrivacyPolicy:
                    self.showPrivacyPolicy()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Push Notification

    private func setPushPermissionObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePushPermissionChange),
            name: .didChangePushPermission,
            object: nil
        )
    }
    
    @objc
    private func handlePushPermissionChange(_ notification: Notification) {
        let isAuthorized = notification.userInfo?["isAuthorized"] as? Bool ?? false
        
        let isPushAllowedInApp = viewModel.userInfoRelay.value.pushStatus == "ENABLED"
        let isFullyEnabled = isAuthorized && isPushAllowedInApp // ✅ 둘 다 true여야 진짜 ON

        var updatedSections = sections
        
        if let index = updatedSections.firstIndex(where: { $0.title == "알림 설정" }) {
            updatedSections[index] = SectionData(
                title: "알림 설정",
                items: [
                    .cellViewModel(
                        MyPageBasicCellModel(
                            image: .icPushAlarm,
                            title: "푸시 알림",
                            accessoryType: .toggle(isOn: isFullyEnabled, action: nil)
                        )
                    )
                ]
            )
            
            self.sections = updatedSections
            myPageView.tableView.reloadSections(IndexSet(integer: index), with: .fade)
        }
    }
}

// MARK: - Methods

extension MyPageViewController {
    private func accountOptionBottomSheet(viewType: AccountOption) {
        let viewModel: AccountOptionViewModelType
        if viewType == .logout {
            viewModel = LogoutViewModel()
        } else {
            viewModel = WithdrawViewModel()
        }
        
        let contentVC = AccountOptionViewController(viewModel: viewModel)
        
        presentCustomBottomSheet(contentVC)
    }
    
    private func navigateToProfileEdit(userInfo: UserProfileInfoModel) {
        let profileVC = ProfileViewController(
            viewType: .fix,
            viewModel: ProfileFixViewModel(userInfo: userInfo)
        )
        profileVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func showNotice() {
        track(eventName: .clickMypageNotice)
        let urlString = "https://abundant-quiver-13f.notion.site/iOS-2324f4c5ff03441d99ff0157b2f15424?pvs=4"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func sendFeedback() {
        track(eventName: .clickMypageComment)
        let urlString = "https://docs.google.com/forms/d/e/1FAIpQLSeYwkK70ThHAZnUum0Qm_coO5ijmqxZaoCJ0k2erXWmtt_eSg/viewform"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showTermsOfUse() {
        let urlString = "https://abundant-quiver-13f.notion.site/69109213e7db4873be6b9600f2f5163a?pvs=4"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showPrivacyPolicy() {
        let urlString = "https://abundant-quiver-13f.notion.site/130cf1915fe7471e9aaf29cab306be3b?pvs=4"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - objc Functions

extension MyPageViewController {
    @objc
    func logoutButtonDidTap() {
        accountOptionBottomSheet(viewType: .logout)
    }
    
    @objc
    func withdrawButtonDidTap() {
        accountOptionBottomSheet(viewType: .withdraw)
    }
    
    @objc
    private func dismissAccountOption() {
        self.dismiss(animated: true) { [weak self] in
            self?.removeModalBackgroundView()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    private func setDelegate() {
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        
        switch item {
        case .userInfoViewModel(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyPageProfileViewCell.className,
                for: indexPath
            ) as? MyPageProfileViewCell else {
                return UITableViewCell()
            }
            cell.bind(with: viewModel)
            
            cell.fixProfileTapSubject
                .subscribe(onNext: { [weak self] in
                    self?.fixProfileTapObservable.onNext(())
                    print("fixProfileTapObservable 이벤트 전달") 
                })
                .disposed(by: cell.disposeBag)
            
            return cell
            
        case .cellViewModel(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyPageBasicViewCell.className,
                for: indexPath
            ) as? MyPageBasicViewCell else {
                return UITableViewCell()
            }
            let isLastCellInSection = indexPath.row == sections[indexPath.section].items.count - 1
            cell.backgroundColor = .white
            cell.bind(with: viewModel, isLastCellInSection: isLastCellInSection)
            return cell
            
        case .emptyCell:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyPageAccountOptionViewCell.className,
                for: indexPath
            ) as? MyPageAccountOptionViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = .clear
            
            cell.logoutTapSubject
                .subscribe(onNext: { [weak self] in
                    self?.logoutTapObservable.onNext(())
                })
                .disposed(by: cell.disposeBag)
            
            cell.withdrawTapSubject
                .subscribe(onNext: { [weak self] in
                    self?.withdrawTapObservable.onNext(())
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containsCellViewModel = sections[section].items.contains { item in
            if case .cellViewModel = item {
                return true
            }
            return false
        }
        
        guard containsCellViewModel else {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = LabelFactory.build(
            font: .body6,
            textColor: .grey400
        )
        
        titleLabel.text = sections[section].title
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16.adjusted)
            $0.bottom.equalToSuperview()
        }
        
        let cornerRadius: CGFloat = 15.0
        headerView.layer.cornerRadius = cornerRadius
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.layer.masksToBounds = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 15.0
        let corners: CACornerMask
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            corners = []
        }
        
        cell.layer.cornerRadius = cornerRadius
        cell.layer.maskedCorners = corners
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section].items[indexPath.row]
        
        switch item {
        case .userInfoViewModel:
            return 120.adjustedH
        case .cellViewModel:
            return 65.adjustedH
        case .emptyCell:
            return 12.adjustedH
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let containsCellViewModel = sections[section].items.contains { item in
            if case .cellViewModel = item {
                return true
            }
            return false
        }
        
        return containsCellViewModel ? 30.adjustedH : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let lastSectionIndex = tableView.numberOfSections - 1
        
        switch section {
        case 0:
            return 8.0.adjustedH
        case lastSectionIndex - 1:
            return 16.0.adjustedH
        case lastSectionIndex:
            return 100.0.adjustedH
        default:
            return 20.0.adjustedH
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension MyPageViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        removeModalBackgroundView()
    }
}
