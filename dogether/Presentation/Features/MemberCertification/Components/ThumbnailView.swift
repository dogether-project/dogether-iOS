//
//  ThumbnailView.swift
//  dogether
//
//  Created by seungyooooong on 4/20/25.
//

import UIKit

final class ThumbnailView: BaseView {
    private(set) var thumbnailStatus: ThumbnailStatus
    
    init(thumbnailStatus: ThumbnailStatus) {
        self.thumbnailStatus = thumbnailStatus
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let imageView = UIImageView(image: .embarrassedDosik)
    
    override func configureView() {
        layer.cornerRadius = 12
        backgroundColor = .grey800
    }
    
    override func configureAction() {
        
    }
    
    override func configureHierarchy() {
        [imageView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}

enum ThumbnailStatus {
    case done
    case current
    case pending
}
