//
//  SearchResultViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//
//
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
    
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()
    private let sortBySubject = BehaviorSubject<String>(value: "deadlineSoon")
    private let pageSubject = BehaviorSubject<Int>(value: 0)
    private var textFieldKeyword: String?
    
    // MARK: - UI Components
    
    let searchResultView = SearchResultView()
    
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
        
        setHierarchy()
        setLayout()
        setDelegate()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension SearchResultViewController {
    private func setHierarchy() {
        view.addSubview(searchResultView)
    }
    
    private func setLayout() {
        searchResultView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind

extension SearchResultViewController {
    private func bindViewModel() {
        var firstSearch = true
        
        let keyword = searchResultView.searchView.textField.rx.text.orEmpty.asObservable()
        
        let searchTrigger = searchResultView.searchView.textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(keyword)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { _ in () }
        
        searchTrigger
            .withLatestFrom(keyword)
            .subscribe(onNext: { keyword in
                print("텍스트 필드 값: \(keyword)")
                if firstSearch {
                    firstSearch = false
                    self.searchResultView.searchTitleLabel.isHidden = true
                    self.searchResultView.updateLayout()
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
        
        output.jobCards
            .drive(onNext: { [weak self] jobCardModel in
                self?.searchResultView.jobCardModel = jobCardModel
                self?.searchResultView.collectionView.reloadData()
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
        searchResultView.collectionView.delegate = self
        searchResultView.collectionView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchResultType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchResultType(rawValue: section) {
        case .graphic:
            return searchResultView.jobCardModel == nil ? 1 : 0
        case .search:
            return searchResultView.jobCardModel?.isEmpty == false ? (searchResultView.jobCardModel?.count ?? 0) : 0
        case .noSearch:
            return searchResultView.jobCardModel?.isEmpty == true ? 1 : 0
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCardScrapedCell.className, for: indexPath) as? JobCardScrapedCell, let jobCards = searchResultView.jobCardModel else {
                return UICollectionViewCell()
            }
            cell.bindData(model: jobCards[indexPath.item])
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
