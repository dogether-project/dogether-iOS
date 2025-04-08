//
//  UIViewControllerExt.swift
//  dogether
//
//  Created by yujaehong on 4/8/25.
//

import UIKit

private var loadingViewTag = 9999

extension UIViewController {
    func showLoadingView() {
        guard view.viewWithTag(loadingViewTag) == nil else { return }

        let loadingView = LoadingView(frame: view.bounds)
        loadingView.tag = loadingViewTag
        view.addSubview(loadingView)
    }

    func hideLoadingView() {
        view.viewWithTag(loadingViewTag)?.removeFromSuperview()
    }
}
