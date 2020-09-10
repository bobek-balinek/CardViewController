//
//  CardPresentationTransition.swift
//  CardViewController
//
//  Created by Przemyslaw Bobak on 10/09/2020.
//

import UIKit

final class CardPresentationTransition: NSObject {}

extension CardPresentationTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            fatalError("Could not get context views")
        }

        let centre = toView.center
        toView.alpha = 0
        toView.center = CGPoint(x: centre.x, y: toView.bounds.size.height)

        transitionContext.containerView.addSubview(toView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 4,
            options: .curveEaseInOut,
            animations: {
                toView.alpha = 1
                toView.center = centre
            }, completion: { _ in
                let success = !transitionContext.transitionWasCancelled

                transitionContext.completeTransition(success)
            }
        )
    }
}
