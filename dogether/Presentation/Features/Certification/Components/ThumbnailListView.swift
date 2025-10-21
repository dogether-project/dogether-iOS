//
//  ThumbnailListView.swift
//  dogether
//
//  Created by seungyooooong on 10/21/25.
//

import UIKit

final class ThumbnailListView: BaseView {
    var delegate: CertificationDelegate? {
        didSet {
            stackView.addTapAction { [weak self] gesture in
                guard let self else { return }
                delegate?.thumbnailTapAction(stackView, gesture)
            }
        }
    }
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private(set) var currentTodos: [TodoEntity]?
    
    override func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [scrollView].forEach { addSubview($0) }
        [stackView].forEach { scrollView.addSubview($0) }
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificationViewDatas {
            if currentTodos != datas.todos {
                currentTodos = datas.todos
                
                datas.todos
                    .enumerated().map {
                        ThumbnailView(
                            imageUrl: $1.certificationMediaUrl,
                            thumbnailStatus: .yet,  // FIXME: 기존 $1.thumbnailStatus
                            isHighlighted: $0 == datas.index
                        )
                    }
                    .forEach {
                        stackView.addArrangedSubview($0)
                    }
            }
        }
    }
}
