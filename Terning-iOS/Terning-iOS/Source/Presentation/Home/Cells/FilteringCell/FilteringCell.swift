////
////  FilteringCell.swift
////  Terning-iOS
////
////  Created by 김민성 on 7/10/24.
////
//
//import UIKit
//
//import SnapKit
//import Then
//
//protocol FilteringButtonTappedProtocol {
//    func filteringButtonTapped()
//}
//
//class FilteringCell: UICollectionViewCell {
//    
//    // MARK: - Properties
//    
//    var delegate: FilteringButtonTappedProtocol?
//    
//    // MARK: - UIComponents
//    
//    lazy var filterButton = FilterButton()
//    
//    var grade = LabelFactory.build(
//        text: "3학년",
//        font: .detail2,
//        textColor: .black
//    )
//        
//    var period = LabelFactory.build(
//        text: "1~3개월",
//        font: .detail2,
//        textColor: .black
//    )
//    
//    var month = LabelFactory.build(
//        text: "2024년 1월",
//        font: .detail2,
//        textColor: .black
//    )
//    
//    let verticalBar1 = UIImageView().then {
//        $0.image = UIImage(resource: .icVerticalBar)
//    }
//    
//    let verticalBar2 = UIImageView().then {
//        $0.image = UIImage(resource: .icVerticalBar)
//    }
//    
//    lazy var FilteringStack = UIStackView(arrangedSubviews: [filterButton, grade, verticalBar1, period, verticalBar2, month]).then {
//        $0.axis = .horizontal
//        $0.spacing = 20
//        $0.distribution = .fillProportionally
//        $0.alignment = .center
//    }
//    
//    // MARK: - LifeCycles
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setHierarchy()
//        setLayout()
//        setAddTarget()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//// MARK: - UI & Layout
//
//extension FilteringCell {
//    func setHierarchy() {
//        contentView.addSubview(
//            FilteringStack
//        )
//    }
//    
//    func setLayout() {
//        FilteringStack.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(50)
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview()
//        }
//
//        filterButton.snp.makeConstraints {
//            $0.height.equalTo(28)
//            $0.width.equalTo(75)
//        }
//
//        verticalBar1.snp.makeConstraints {
//            $0.height.equalTo(20)
//            $0.width.equalTo(2)
//        }
//        
//        verticalBar2.snp.makeConstraints {
//            $0.height.equalTo(20)
//            $0.width.equalTo(2)
//        }
//    }
//    
//    func setAddTarget() {
//        filterButton.addTarget(self, action: #selector(filteringButtonDidTap), for: .touchUpInside)
//    }
//    
//    // MARK: - objc Function
//    
//    @objc
//    func filteringButtonDidTap() {
//        print("tap")
//        delegate?.filteringButtonTapped()
//    }
//}
