//
//  ThumbnailView.swift
//  dogether
//
//  Created by seungyooooong on 4/20/25.
//

import UIKit

enum ThumbnailStatus {
    case yet
    case done
}

// FIXME: 추후 BaseImageView로 수정
final class ThumbnailView: BaseView {
    private(set) var thumbnailStatus: ThumbnailStatus
    private(set) var isHighlighted: Bool
    
    init(thumbnailStatus: ThumbnailStatus, isHighlighted: Bool = false) {
        self.thumbnailStatus = thumbnailStatus
        self.isHighlighted = isHighlighted
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // FIXME: 추후 기본 이미지 통일
    private let imageView = UIImageView(image: .embarrassedDosikThumbnail)
    
    private let doneOverlay = {
        let view = UIView()
        view.backgroundColor = .grey800.withAlphaComponent(0.8)
        view.layer.cornerRadius = 12
        return view
    }()
    
    override func configureView() {
        updateUI()
        
        backgroundColor = .grey800
        layer.cornerRadius = 12
        layer.borderWidth = 1
    }
    
    override func configureAction() {
        
    }
    
    override func configureHierarchy() {
        [imageView, doneOverlay].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(54)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        doneOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ThumbnailView {
    func setStatus(status: ThumbnailStatus) {
        self.thumbnailStatus = status
        
        updateUI()
    }
    
    func setIsHighlighted(isHighlighted: Bool) {
        self.isHighlighted = isHighlighted
        
        updateUI()
    }
    
    private func updateUI() {
        doneOverlay.isHidden = thumbnailStatus != .done
        layer.borderColor = isHighlighted ? UIColor.grey0.cgColor : UIColor.clear.cgColor
    }
}
