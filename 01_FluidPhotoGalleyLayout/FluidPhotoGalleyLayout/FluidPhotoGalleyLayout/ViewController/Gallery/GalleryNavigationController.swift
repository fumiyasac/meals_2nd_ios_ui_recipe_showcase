//
//  GalleryNavigationController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: カスタムトランジションが考慮されたUINavigationControllerを拡張したクラス

final class GalleryNavigationController: UINavigationController {

    // MARK: - Property

    private var currentAnimationTransition: UIViewControllerAnimatedTransitioning? = nil

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
}

 // MARK: - GalleryNavigationController

extension GalleryNavigationController: UINavigationControllerDelegate {

    //
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var result: UIViewControllerAnimatedTransitioning? = nil

        //
        switch operation {
        case .push:

            //
            if let photoDetailVC = toVC as? PhotoDetailViewController {
                result = PhotoDetailPushTransition(fromDelegate: fromVC, toPhotoDetailVC: photoDetailVC)
            }
        case .pop:

            //
            if let photoDetailVC = fromVC as? PhotoDetailViewController {
                if photoDetailVC.isInteractivelyDismissing {
                    result = PhotoDetailInteractiveDismissTransition(fromDelegate: photoDetailVC, toDelegate: toVC)
                } else {
                    result = PhotoDetailPopTransition(toDelegate: toVC, fromPhotoDetailVC: photoDetailVC)
                }
            }
        default:
            break
        }

        //
        currentAnimationTransition = result

        return result
    }

    //
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return currentAnimationTransition as? UIViewControllerInteractiveTransitioning
    }

    //
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentAnimationTransition = nil
    }
}

