//
//  PhotoDetailTransitionAnimatorDelegate.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

/// A way that view controllers can provide information about the photo-detail transition animation.
public protocol PhotoDetailTransitionAnimatorDelegate: class {

    /// Called just-before the transition animation begins. Use this to prepare your VC for the transition.
    func transitionWillStart()

    /// Called right-after the transition animation ends. Use this to clean up your VC after the transition.
    func transitionDidEnd()

    /// The animator needs a UIImageView for the transition;
    /// eg the Photo Detail screen should provide a snapshotView of its image,
    /// and a collectionView should do the same for its image views.
    func referenceImage() -> UIImage?

    /// The frame for the imageView provided in `referenceImageView(for:)`
    func imageFrame() -> CGRect?
}
