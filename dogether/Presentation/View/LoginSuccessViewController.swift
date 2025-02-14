//
//  LoginSuccessViewController.swift
//  dogether
//
//  Created by 박지은 on 2/11/25.
//

//import UIKit
//import SnapKit
//
//final class LoginSuccessViewController: BaseViewController {
//    
//    private lazy var logo = {
//        let logo = UIImageView()
//        logo.image = .logo
//        return logo
//    }()
//    
//    private let loginSuccessLabel = {
//        let label = UILabel()
//        label.text = "회원가입 완료!"
//        label.font = Fonts.head1B
//        label.textColor = .grey900
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    override func configureHierarchy() {
//        [logo, loginSuccessLabel].forEach { view.addSubview($0) }
//    }
//    
//    override func configureConstraints() {
//        logo.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(272)
//        }
//        
//        loginSuccessLabel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(logo.snp.bottom).offset(32)
//        }
//    }
//}
