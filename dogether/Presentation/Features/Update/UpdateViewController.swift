//
//  UpdateViewController.swift
//  dogether
//
//  Created by 승용 on 7/31/25.
//

final class UpdateViewController: BaseViewController {
    private let updatePage = UpdatePage()
    
    override func viewDidLoad() {
        pages = [updatePage]
        
        super.viewDidLoad()
    }
}
