//
//  CertificationImageView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit

final class CertificationImageView: BaseImageView {
    private let certificationContent: String?
    private let certificator: String?
    
    init(image: UIImage?, certificationContent: String? = nil, certificator: String? = nil) {
        self.certificationContent = certificationContent
        self.certificator = certificator
        
        super.init(image: image)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let gradientView = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.87).cgColor,
            UIColor.black.withAlphaComponent(0.37).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [-0.2, 0.6]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.cornerRadius = 12
        
        let view = UIView()
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    private let certificationContentLabel = {
        let label = UILabel()
        label.textColor = .grey100
        label.numberOfLines = 0
        return label
    }()
    
    private let certificatorLabel = {
        let label = UILabel()
        label.textColor = .grey100
        label.font = Fonts.head2B
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layer.sublayers?.first?.frame = gradientView.bounds
    }
    
    override func configureView() {
        contentMode = .scaleAspectFit
        backgroundColor = .grey900
        layer.cornerRadius = 12
        layer.borderColor = UIColor.grey700.cgColor
        layer.borderWidth = 1
        
        certificationContentLabel.attributedText = NSAttributedString(
            string: certificationContent ?? "",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
        )
        certificatorLabel.text = certificator
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        [gradientView, certificationContentLabel, certificatorLabel].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        certificationContentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            if certificator == nil {
                $0.bottom.equalToSuperview().inset(16)
            } else {
                $0.bottom.equalTo(certificatorLabel.snp.top).inset(4)
            }
        }
        
        certificatorLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(certificator == nil ? 0 : 28)
        }
    }
}
