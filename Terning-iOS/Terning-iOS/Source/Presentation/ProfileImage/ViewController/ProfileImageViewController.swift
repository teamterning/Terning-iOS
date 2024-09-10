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
    
    private var initialSelectedImageString: String
    
    var onImageSelected: ((Int) -> Void)?
    
    let profileImages: [UIImage] = [
        .profileBasic,
        .profileLucky,
        .profileSmart,
        .profileGlass,
        .profileCalendar,
        .profilePassion
    ]
    
    // MARK: - UI Components
    
    let rootView = ProfileImageView()
    
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
        self.view = rootView
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
            initialSelectedImageString: initialSelectedImageString
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.initialIndex
            .subscribe(onNext: { [weak self] initialIndex in
                print("initialIndex:", initialIndex)
                let initialIndexPath = IndexPath(item: initialIndex, section: 0)
                self?.rootView.collectionView.selectItem(at: initialIndexPath, animated: false, scrollPosition: [])

            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension ProfileImageViewController {
    private func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.className)
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
        
        if let previousSelectedCell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell {
            previousSelectedCell.isSelected = false
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCell {
            cell.isSelected = true
        }
        
        onImageSelected?(indexPath.item)
        
        self.presentingViewController?.removeModalBackgroundView()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 28) / 3
        return CGSize(width: width, height: width)
    }
}
