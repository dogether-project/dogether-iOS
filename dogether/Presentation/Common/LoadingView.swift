//
//  LoadingView.swift
//  dogether
//
//  Created by yujaehong on 4/8/25.
//

import UIKit

final class LoadingView: UIView {

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        isUserInteractionEnabled = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        print("LoadingView: 인디케이터 시작됨!")
    }

    deinit {
        print("LoadingView: 인디케이터 꺼짐!")
    }
}
