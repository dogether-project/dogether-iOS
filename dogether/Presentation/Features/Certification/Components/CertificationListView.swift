//
//  CertificationListView.swift
//  dogether
//
//  Created by seungyooooong on 10/22/25.
//

import UIKit

final class CertificationListView: BaseView {
    var delegate: CertificationDelegate? {
        didSet {
            stackView.addTapAction { [weak self] gesture in
                guard let self else { return }
                delegate?.certificationTapAction(scrollView, stackView, gesture)
            }
        }
    }
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private(set) var currentTodos: [TodoEntity]?
    
    override func configureView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
    
        stackView.axis = .horizontal
        stackView.spacing = 32
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
                
                layoutIfNeeded()
                
                datas.todos
                    .map {
                        if let mediaUrl = $0.certificationMediaUrl {
                            CertificationImageView(imageUrl: mediaUrl, certificationContent: $0.certificationContent)
                        } else {
                            CertificationImageView(
                                image: .embarrassedDosik.imageWithPadding(
                                    insets: UIEdgeInsets(top: 41 * 4, left: 62 * 4, bottom: 83 * 4, right: 62 * 4), backgroundColor: .grey800
                                ),
                                certificationContent: "아직 열심히 진행중이에요"
                            )
                        }
                    }
                    .forEach {
                        stackView.addArrangedSubview($0)
                    }
                
                stackView.snp.makeConstraints {
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.width.equalTo(frame.width * CGFloat(datas.todos.count) - 32)
                    $0.height.equalToSuperview()
                }
            }
        }
    }
}
