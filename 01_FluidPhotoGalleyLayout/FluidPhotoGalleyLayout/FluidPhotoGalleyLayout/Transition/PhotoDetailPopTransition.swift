//
//  PhotoDetailPopTransition.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/12.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class PhotoDetailPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let toDelegate: PhotoDetailTransitionAnimatorDelegate
    private let photoDetailVC: PhotoDetailViewController

    /// The snapshotView that is animating between the two view controllers.
    private let transitionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.accessibilityIgnoresInvertColors = true
        return imageView
    }()

    /// If toDelegate isn't PhotoDetailTransitionAnimatorDelegate, returns nil.
    
    init?(toDelegate: Any, fromPhotoDetailVC photoDetailVC: PhotoDetailViewController) {

        guard let toDelegate = toDelegate as? PhotoDetailTransitionAnimatorDelegate else {
            return nil
        }
        self.toDelegate = toDelegate
        self.photoDetailVC = photoDetailVC
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.38
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        let fromReferenceFrame = photoDetailVC.imageFrame()!

        let transitionImage = photoDetailVC.referenceImage()
        transitionImageView.image = transitionImage
        transitionImageView.frame = photoDetailVC.imageFrame()!

        [toView, fromView]
            .compactMap { $0 }
            .forEach { containerView.addSubview($0) }
        containerView.addSubview(transitionImageView)

        self.photoDetailVC.transitionWillStart()
        self.toDelegate.transitionWillStart()

        let duration = self.transitionDuration(using: transitionContext)
        let spring: CGFloat = 0.9
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: spring) {
            fromView?.alpha = 0
        }
        animator.addCompletion { (position) in
            assert(position == .end)

            self.transitionImageView.removeFromSuperview()
            self.transitionImageView.image = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.toDelegate.transitionDidEnd()
            self.photoDetailVC.transitionDidEnd()
        }
        animator.startAnimation()

        // HACK: By delaying 0.005s, I get a layout-refresh on the toViewController,
        // which means its collectionview has updated its layout,
        // and our toDelegate?.imageFrame() is accurate, even if
        // the device has rotated. :scream_cat:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            animator.addAnimations {
                let toReferenceFrame = self.toDelegate.imageFrame() ??
                    PhotoDetailPopTransition.defaultOffscreenFrameForDismissal(
                        transitionImageSize: fromReferenceFrame.size,
                        screenHeight: containerView.bounds.height
                )
                self.transitionImageView.frame = toReferenceFrame
            }
        }
    }

    /// If we need a "dummy reference frame", let's throw the image off the bottom of the screen.
    /// Photos.app transitions to CGRect.zero, though I think that's ugly.
    static func defaultOffscreenFrameForDismissal(transitionImageSize: CGSize, screenHeight: CGFloat) -> CGRect {
        return CGRect(x: 0, y: screenHeight, width: transitionImageSize.width, height: transitionImageSize.height)
    }
}
