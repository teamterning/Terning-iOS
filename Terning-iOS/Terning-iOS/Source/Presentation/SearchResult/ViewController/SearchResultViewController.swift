//  SearchResultViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

@frozen
enum SearchResultType: Int, CaseIterable {
    case graphic = 0
    case search = 1
    case noSearch = 2
}

final class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()
    private let sortBySubject = BehaviorSubject<String>(value: "deadlineSoon")
    private let pageSubject = BehaviorSubject<Int>(value: 0)
    private var textFieldKeyword: String?
    
    // MARK: - UI Components
    
    let rootView = SearchResultView()
    
    // MARK: - Init
    
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension SearchResultViewController {
    private func setUI() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setHierarchy() {
        view.addSubview(rootView)
    }
    
    private func setLayout() {
        rootView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Bind

extension SearchResultViewController {
    private func bindViewModel() {
        var firstSearch = true
        
        let keyword = rootView.searchView.textField.rx.text.orEmpty.asObservable()
        
        let searchTrigger = rootView.searchView.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(keyword)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { _ in () }
        
        searchTrigger
            .withLatestFrom(keyword)
            .subscribe(onNext: { keyword in
                print("텍스트 필드 값: \(keyword)")
                if firstSearch {
                    firstSearch = false
                    self.rootView.searchTitleLabel.isHidden = true
                    self.rootView.updateLayout()
                }
            })
            .disposed(by: disposeBag)
        
        let input = SearchResultViewModel.Input(
            keyword: searchTrigger.withLatestFrom(keyword),
            sortBy: sortBySubject.asObservable(),
            page: pageSubject.asObservable(),
            size: Observable.just(10),
            searchTrigger: searchTrigger
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.SearchResult
            .drive(onNext: { [weak self] SearchResult in
                self?.rootView.SearchResult = SearchResult
                self?.rootView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.keyword
            .drive(onNext: { [weak self] keyword in
                self?.textFieldKeyword = keyword
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension SearchResultViewController {
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
        rootView.navigationBar.leftButtonAction = { [weak self] in
            guard let self = self else { return }
            self.popOrDismissViewController(animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchResultType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchResultType(rawValue: section) {
        case .graphic:
            return rootView.SearchResult == nil ? 1 : 0
        case .search:
            return rootView.SearchResult?.isEmpty == false ? (rootView.SearchResult?.count ?? 0) : 0
        case .noSearch:
            return rootView.SearchResult?.isEmpty == true ? 1 : 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SearchResultType(rawValue: indexPath.section) {
        case .graphic:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphicCollectionViewCell.className, for: indexPath) as? GraphicCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
            
        case .search:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCardScrapedCell.className, for: indexPath) as? JobCardScrapedCell, let SearchResult = rootView.SearchResult else {
                return UICollectionViewCell()
            }
            cell.bind(model: SearchResult[indexPath.item], indexPath: indexPath)
            cell.delegate2 = self
            return cell
            
        case .noSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InavailableFilterView.className, for: indexPath) as? InavailableFilterView, let title = self.textFieldKeyword else {
                return UICollectionViewCell()
            }
            cell.bind(title: title)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch SearchResultType(rawValue: indexPath.section) {
        case .search:
            guard let SearchResult = rootView.SearchResult else { return }
            let selectedItem = SearchResult[indexPath.item].internshipAnnouncementId
    
            let jobDetailVC = JobDetailViewController()
            jobDetailVC.internshipAnnouncementId.onNext(selectedItem)
            self.navigationController?.pushViewController(jobDetailVC, animated: true)
        default:
            break
        }
    }
}

extension SearchResultViewController: JobCardScrapedCellProtocol {
    func scrapButtonDidTap(index: Int) {
        guard let searchResults = rootView.SearchResult, !searchResults.isEmpty else {
            print("검색 결과가 비어 있습니다. 요청을 실행하지 않습니다.")
            return
        }
        
        guard index >= 0 && index < searchResults.count else {
            print("잘못된 인덱스입니다.")
            return
        }
        
        print("index", index)
       
        let model = searchResults[index]
        print("model", model)
        let scrapId = model.scrapId
        
        if scrapId == nil {
            let startDateComponents = parseStartDate(model.startYearMonth)
            
            let searchModel = SearchResult(
                internshipAnnouncementId: model.internshipAnnouncementId,
                scrapId: model.scrapId,
                dDay: model.dDay,
                deadline: model.deadline,
                companyImage: model.companyImage,
                title: model.title,
                workingPeriod: model.workingPeriod,
                startYearMonth: model.startYearMonth,
                color: model.color
            )
            
            let alertSheet = CustomAlertViewController(alertType: .custom, customType: .scrap)
            
            
            let alertViewController = NewCustomAlertVC(alertViewType: .scrap)
            alertViewController.setSearchData(model: searchModel)
            
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen
            
            alertViewController.centerButtonDidTapAction = { [weak self] in
                guard let self = self else { return }
                
                let colorName = alertViewController.selectedColorNameRelay
                
                self.scrapAnnouncementWithCompletion(
                    internshipAnnouncementId: model.internshipAnnouncementId,
                    color: colorName.value
                ) { success in
                    if success {
                        self.bindViewModel()
                        self.rootView.collectionView.reloadData()
                        self.showToast(message: "관심 공고가 캘린더에 스크랩되었어요!")
                    }
                    self.dismiss(animated: false)
                }
            }
            self.present(alertSheet, animated: false)
            
        } else {
            let alertSheet = CustomAlertViewController(alertType: .normal)
            alertSheet.setComponentDatas(
                mainLabel: "관심 공고가 캘린더에서 사라져요!",
                subLabel: "스크랩을 취소하시겠어요?",
                buttonLabel: "스크랩 취소하기"
            )
            
            alertSheet.centerButtonTapAction = {
                self.cancelScrapAnnouncement(internshipAnnouncementId: scrapId)
                self.dismiss(animated: false)
             
                self.showToast(message: "관심 공고가 캘린더에서 사라졌어요!")
            }
            
            alertSheet.modalTransitionStyle = .crossDissolve
            alertSheet.modalPresentationStyle = .overFullScreen
            
            self.present(alertSheet, animated: false)
        }
        
    }
    
    private func scrapAnnouncementWithCompletion(internshipAnnouncementId: Int, color: String, completion: @escaping (Bool) -> Void) {
        self.scrapAnnouncement(internshipAnnouncementId: internshipAnnouncementId, color: color)
        completion(true)
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
}

// MARK: - API
    
extension SearchResultViewController {
    private func patchScrapAnnouncement(internshipAnnouncementId: Int?, color: String, cell: JobCardScrapedCell) {
        guard let scrapId = internshipAnnouncementId else { return }
        Providers.scrapsProvider.request(.patchScrap(internshipAnnouncementId: scrapId, color: color)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 수정 성공")
                    self.bindViewModel()
                    self.rootView.collectionView.reloadData()
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
        guard let scrapId = internshipAnnouncementId else { return }
        Providers.scrapsProvider.request(.removeScrap(internshipAnnouncementId: scrapId)) { [weak self] result in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let status = response.statusCode
                if 200..<300 ~= status {
                    print("스크랩 취소 성공")
                    self.bindViewModel()
                    self.rootView.collectionView.reloadData()
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
