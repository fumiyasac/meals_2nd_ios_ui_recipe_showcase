//
//  GalleryViewController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/10.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class GalleryViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - StoryboardInstantiatable

extension GalleryViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return "Gallery"
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
