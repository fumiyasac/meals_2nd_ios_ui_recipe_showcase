//
//  GalleryNavigationController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

/// Adds support for custom navigation transitions
public class GalleryNavigationController: UINavigationController {
    fileprivate var currentAnimationTransition: UIViewControllerAnimatedTransitioning? = nil

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    /// The tab bar should be hidden if a PhotoDetailVC is anywhere in the stack.
    public var shouldTabBarBeHidden: Bool {
        let photoDetailInNavStack = self.viewControllers.contains(where: { (vc) -> Bool in
            return vc.isKind(of: PhotoDetailViewController.self)
        })

        let isPoppingFromPhotoDetail =
            (self.currentAnimationTransition?.isKind(of: PhotoDetailPopTransition.self) ?? false)

        if isPoppingFromPhotoDetail {
            return false
        } else {
            return photoDetailInNavStack
        }
    }
}

extension GalleryNavigationController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {

        let result: UIViewControllerAnimatedTransitioning?
        if
            let photoDetailVC = toVC as? PhotoDetailViewController,
            operation == .push
        {
            result = PhotoDetailPushTransition(fromDelegate: fromVC, toPhotoDetailVC: photoDetailVC)
        } else if
            let photoDetailVC = fromVC as? PhotoDetailViewController,
            operation == .pop
        {
            if photoDetailVC.isInteractivelyDismissing {
                result = PhotoDetailInteractiveDismissTransition(fromDelegate: photoDetailVC, toDelegate: toVC)
            } else {
                result = PhotoDetailPopTransition(toDelegate: toVC, fromPhotoDetailVC: photoDetailVC)
            }
        } else {
            result = nil
        }
        self.currentAnimationTransition = result
        return result
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return self.currentAnimationTransition as? UIViewControllerInteractiveTransitioning
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        self.currentAnimationTransition = nil
    }
}

