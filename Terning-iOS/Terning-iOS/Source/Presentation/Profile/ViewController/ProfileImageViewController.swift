//
//  ProfileImageViewController.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/17/24.
//

import UIKit

import RxSwift

import SnapKit

final class ProfileImageViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ProfileImageViewModel
    private let disposeBag = DisposeBag()
    var selectedIndex = BehaviorSubject<Int>(value: 0)
    private var initialSelectedIndex: Int
    
    // MARK: - UI Components
    let profileImageView = ProfileImageView()
    let profileImages: [UIImage] = [
        .profile0,
        .profile1,
        .profile2,
        .profile3,
        .profile4,
        .profile5
    ]
    
    // MARK: - Init
    init(viewModel: ProfileImageViewModel, initialSelectedIndex: Int) {
        self.viewModel = viewModel
        self.initialSelectedIndex = initialSelectedIndex
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
extension ProfileImageViewController {
    private func setUI() {
        DispatchQueue.main.async {
            let initialIndexPath = IndexPath(item: self.initialSelectedIndex, section: 0)
            self.collectionView(self.profileImageView.collectionView, didSelectItemAt: initialIndexPath)
            self.profileImageView.collectionView.selectItem(at: initialIndexPath, animated: false, scrollPosition: [])
        }
        profileImageView.collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.className)
    }
    
    private func setHierarchy() {
        view.addSubview(profileImageView)
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension ProfileImageViewController {
    private func bindViewModel() {
        let saveButtonTapped = profileImageView.saveButton.rx.tap.asObservable()
        
        let input = ProfileImageViewModel.Input(
            saveButtonTapped: saveButtonTapped,
            selectedIndex: selectedIndex.asObservable()
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.savedIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                print("Selected index: \(index)")
                self.selectedIndex.onNext(index)
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods
extension ProfileImageViewController {
    private func setDelegate() {
        profileImageView.collectionView.delegate = self
        profileImageView.collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.className, for: indexPath) as? ProfileImageCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = profileImages[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = try? selectedIndex.value() {
            let previousIndexPath = IndexPath(item: previousIndex, section: 0)
            collectionView.deselectItem(at: previousIndexPath, animated: true)
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ProfileImageCell {
                previousCell.isSelected = false
                previousCell.setStyle()
            }
        }

        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell {
            cell.isSelected = true
        }
        selectedIndex.onNext(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell {
            cell.isSelected = false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - (18.66 * 2)) / 3
        return CGSize(width: width, height: width)
    }
}
