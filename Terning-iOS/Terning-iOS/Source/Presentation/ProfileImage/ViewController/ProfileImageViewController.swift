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
    private var initialSelectedImageString: String
    
    var onImageSelected: ((String) -> Void)?
    
    let profileImages: [UIImage] = [
        .profileBasic,
        .profileLucky,
        .profileSmart,
        .profileGlass,
        .profileCalendar,
        .profilePassion
    ]
    
    // MARK: - UI Components
    
    let profileImageView = ProfileImageView()
    
    // MARK: - Init
    
    init(viewModel: ProfileImageViewModel, initialSelectedImageString: String) {
        self.viewModel = viewModel
        self.initialSelectedImageString = initialSelectedImageString
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = profileImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        bindViewModel()
    }
}

// MARK: - UI & Layout

extension ProfileImageViewController {
    private func setUI() {
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
    }
}

// MARK: - Bind

extension ProfileImageViewController {
    private func bindViewModel() {
        let input = ProfileImageViewModel.Input(
            selectedIndex: selectedIndex.asObservable(),
            initialSelectedImageString: initialSelectedImageString
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.initialIndex
            .subscribe(onNext: { [weak self] initialIndex in
                print("initialIndex:", initialIndex)
                let initialIndexPath = IndexPath(item: initialIndex, section: 0)
                self?.profileImageView.collectionView.selectItem(at: initialIndexPath, animated: false, scrollPosition: [])

            })
            .disposed(by: disposeBag)
        
        output.selectedImageString
            .subscribe(onNext: { [weak self] imageString in
                self?.onImageSelected?(imageString)
            })
            .disposed(by: disposeBag)
        
        output.dismissModal
            .drive(onNext: { [weak self] in
                self?.presentingViewController?.removeModalBackgroundView()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension ProfileImageViewController {
    private func setDelegate() {
        profileImageView.collectionView.delegate = self
        profileImageView.collectionView.dataSource = self
        
        profileImageView.collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.className)
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
            }
        }

        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell {
            cell.isSelected = true
        }
        selectedIndex.onNext(indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 28) / 3
        return CGSize(width: width, height: width)
    }
}
