////
////  CertificationListCollectionViewCell.swift
////  dogether
////
////  Created by 박지은 on 2/18/25.
////
//
//import UIKit
//import SnapKit
//
//class CertificationListCollectionViewCell: BaseCollectionViewCell, ReusableProtocol {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    required init?(coder: NSCoder) { fatalError() }
//    
//    private let imageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    private var statusButton = {
//        let button = UIButton()
//        button.backgroundColor = .orange
//        return button
//    }()
//    
//    override func configureView() { }
//    
//    override func configureAction() { }
//    
//    override func configureHierarchy() {
//        [imageView, statusButton].forEach {
//            contentView.addSubview($0)
//        }
//    }
//    
//    override func configureConstraints() {
//        imageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        statusButton.snp.makeConstraints {
//            $0.leading.bottom.equalToSuperview().inset(12)
//        }
//    }
//    
//    func configure(imageName: UIImage, button: UIButton) {
//        imageView.image = imageName
//        
//        // 기존 버튼 제거
//        statusButton.removeFromSuperview()
//        
//        // 새로운 버튼을 statusButton으로 교체
//        statusButton = button
//        
//        contentView.addSubview(statusButton)
//        
//        statusButton.snp.makeConstraints {
//            $0.leading.bottom.equalToSuperview().inset(12)
//        }
//    }
//}
