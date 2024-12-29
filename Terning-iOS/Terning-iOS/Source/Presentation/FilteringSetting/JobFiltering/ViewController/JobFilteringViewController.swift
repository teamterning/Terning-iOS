//
//  JobFilteringViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 12/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class JobFilteringViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: JobFilteringViewModel
    private let disposeBag = DisposeBag()
    var filteringState = BehaviorRelay<Bool>(value: false)
    
    // MARK: - UIComponents
    
    private lazy var collectionView: UICollectionView = {
        let layout = CompositionalLayout.jobFilterLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .white
        }
    }()
    
    // MARK: - Init
    
    init(viewModel: JobFilteringViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setRegister()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension JobFilteringViewController {
    private func setHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func setRegister() {
        collectionView.register(JobCategoryCell.self, forCellWithReuseIdentifier: JobCategoryCell.className)
    }
}

// MARK: - Bind

extension JobFilteringViewController {
    private func bindViewModel() {
        let input = JobFilteringViewModel.Input(
            jobSelected: collectionView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.jobTypes
            .drive(collectionView.rx.items(cellIdentifier: JobCategoryCell.className, cellType: JobCategoryCell.self)) { _, jobType, cell in
                cell.bind(with: jobType.displayName, image: jobType.image ?? .default)
            }
            .disposed(by: disposeBag)
        
        output.isFilterApplied
            .drive(filteringState)
            .disposed(by: disposeBag)
        
        output.selectedJobType
            .drive(onNext: { [weak self] selectedJob in
                guard let self = self else { return }
                if let selectedJob = selectedJob,
                   let index = JobType.allCases.firstIndex(of: selectedJob) {
                    let indexPath = IndexPath(item: index, section: 0)
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
                } else {
                    self.collectionView.indexPathsForSelectedItems?.forEach {
                        self.collectionView.deselectItem(at: $0, animated: false)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
