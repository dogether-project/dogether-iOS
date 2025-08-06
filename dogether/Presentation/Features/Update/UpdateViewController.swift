//
//  UpdateViewController.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

final class UpdateViewController: BaseViewController {
    private let updatePage = UpdatePage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() { }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [updatePage].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        updatePage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindViewModel() { }
}
