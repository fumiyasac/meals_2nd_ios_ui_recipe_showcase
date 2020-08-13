//
//  PhotoDetailViewController.swift
//  FluidPhotoGalleyLayout
//
//  Created by 酒井文也 on 2020/08/11.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {

    private let dismissPanGesture = UIPanGestureRecognizer()

    private var selectedRectanglePhoto: RectanglePhoto!

    //
    var isInteractivelyDismissing: Bool = false

    //
    weak var transitionController: PhotoDetailInteractiveDismissTransition? = nil
    
    @IBOutlet private weak var imageView: UIImageView!

    func setRectanglePhoto(rectanglePhoto: RectanglePhoto) {
        selectedRectanglePhoto = rectanglePhoto
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = selectedRectanglePhoto.title

        imageView.image = UIImage(named: selectedRectanglePhoto.thumbnailName)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.accessibilityIgnoresInvertColors = true
        
        configureDismissGesture()
    }
    

    // MARK: Drag-to-dismiss





    private func configureDismissGesture() {
        view.addGestureRecognizer(self.dismissPanGesture)
        dismissPanGesture.addTarget(self, action: #selector(dismissPanGestureDidChange(_:)))
    }

    @objc private func dismissPanGestureDidChange(_ gesture: UIPanGestureRecognizer) {
        // Decide whether we're interactively-dismissing, and notify our navigation controller.
        switch gesture.state {
        case .began:
            self.isInteractivelyDismissing = true
            self.navigationController?.popViewController(animated: true)
        case .cancelled, .failed, .ended:
            self.isInteractivelyDismissing = false
        case .changed, .possible:
            break
        @unknown default:
            break
        }

        // We want to update our transition controller, too!
        transitionController?.didPanWith(gestureRecognizer: gesture)
    }
}

// MARK: - PhotoDetailTransitionAnimatorDelegate

extension PhotoDetailViewController: PhotoDetailTransitionAnimatorDelegate {

    //
    func transitionWillStart() {
        imageView.isHidden = true
    }

    //
    func transitionDidEnd() {
        imageView.isHidden = false
    }

    //
    func referenceImage() -> UIImage? {
        return imageView.image
    }

    //
    func imageFrame() -> CGRect? {
         return CGRect.makeRect(aspectRatio: imageView.image!.size, insideRect: imageView.bounds)
    }
}
