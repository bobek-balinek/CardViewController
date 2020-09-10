//
//  CardPresentationController.swift
//  CardViewController
//
//  Created by Przemyslaw Bobak on 10/09/2020.
//

import UIKit

final class CardPresentationController: UIPresentationController {
    let dimmingView: UIView = UIView()

    var keyboardIsVisible: Bool = false {
        didSet {
            containerViewWillLayoutSubviews()
        }
    }

    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var contentSize: CGSize = UIScreen.main.bounds.size

    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero

        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        frame.origin.y = containerView!.bounds.height - frame.size.height

        if traitCollection.horizontalSizeClass == .regular {
            frame.origin.y = (containerView!.bounds.height) / 2 - (frame.size.height / 2)
        }

        let offsetX = (containerView!.bounds.width - frame.width) / 2

        return CGRect(x: offsetX, y: frame.origin.y, width: frame.width, height: frame.height)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedViewController.view.layer.cornerRadius = 40
        presentedViewController.view.layer.masksToBounds = true
        contentSize = presentedViewController.preferredContentSize

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDimView))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
        dimmingView.backgroundColor = UIColor.black

        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func containerViewWillLayoutSubviews() {
        contentSize = presentedViewController.preferredContentSize
        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer _: UIContentContainer, withParentContainerSize _: CGSize) -> CGSize {
        return presentedViewController.preferredContentSize
    }

    override func containerViewDidLayoutSubviews() {}

    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView?.bounds ?? .zero
        dimmingView.alpha = 0

        presentedView?.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        containerView?.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.75
            self.presentedView?.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
            self.presentedView?.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }, completion: { context in
            if !context.isCancelled {
                self.dimmingView.removeFromSuperview()
            }
        })
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        contentSize = container.preferredContentSize

        if containerView != nil {
            containerViewWillLayoutSubviews()
        }

        UIView.animate(withDuration: 0.35) {
            self.containerView?.setNeedsLayout()
        }
    }

    // MARK: - Keyboard delegate

    @objc func keyBoardWillShow(notification _: Any) {
        keyboardIsVisible = true
    }

    @objc func keyBoardWillHide(notification _: Any) {
        keyboardIsVisible = false
    }

    @objc func didTapDimView() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
