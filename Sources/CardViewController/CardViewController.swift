//
//  CardViewController.swift
//  CardViewController
//
//  Created by Przemyslaw Bobak on 10/09/2020.
//

import UIKit

open class CardViewController: UIViewController, UIViewControllerTransitioningDelegate {
    public typealias ActionHandler = () -> Void

    open var containerView: UIView = UIView()
    open var headerView: UIView = UIView()
    open var footerView: UIView = UIView()
    open var footerActionsStackView: UIStackView = UIStackView()
    open var closeButton = UIButton()
    open var titleLabel = UILabel()

    public convenience init(size: SizeConfiguration) {
        self.init()

        self.sizeConfiguration = size
        transitioningDelegate = self
        modalPresentationStyle = .custom
        preferredContentSize = size.minimum
    }

    private var sizeConfiguration: SizeConfiguration = .default
    private var actions: [Int: ActionHandler] = [:]

    open override func viewDidLoad() {
        super.viewDidLoad()

        setUpLabelsAndConstraints()
    }

    open func embed(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.didMove(toParent: self)

        // Emebed the viewController
        containerView.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }

    open func setTitle(_ text: String?, color: UIColor) {
        titleLabel.text = text
        titleLabel.textColor = color
    }

    // MARK: - UIViewControllerTransitioningDelegate

    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }

    open func animationController(forPresented viewController: UIViewController, presenting: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentationTransition()
    }

    // MARK: - Layout

    open func setPrimaryAction(_ title: String, _ action: @escaping ActionHandler) {
        let index: Int = 0
        self.actions.updateValue(action, forKey: index)
        guard let existingBtn = footerActionsStackView.arrangedSubviews.first(where: { $0.tag == index }) as? UIButton else {
            let btn = UIButton(type: .system)
            btn.tag = index
            btn.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
            footerActionsStackView.addArrangedSubview(btn)
            btn.setTitle(title, for: .normal)
            btn.backgroundColor = btn.tintColor
            btn.setTitleColor(titleLabel.textColor, for: .normal)
            btn.setTitleColor(titleLabel.textColor.withAlphaComponent(0.4), for: .highlighted)
            btn.layer.cornerRadius = 20
            btn.layer.masksToBounds = true
            return
        }

        existingBtn.setTitle(title, for: .normal)
    }

    open func setSecondaryAction(_ title: String, _ action: @escaping ActionHandler) {
        let index: Int = 1
        self.actions.updateValue(action, forKey: index)
        guard let existingBtn = footerActionsStackView.arrangedSubviews.first(where: { $0.tag == index }) as? UIButton else {
            let btn = UIButton(type: .system)
            btn.tag = index
            btn.setTitle(title, for: .normal)
            btn.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
            footerActionsStackView.addArrangedSubview(btn)
            btn.layer.cornerRadius = 20
            btn.layer.masksToBounds = true
            return
        }

        existingBtn.setTitle(title, for: .normal)
    }

    @objc func didPressButton(_ sender: UIButton) {
        actions[sender.tag]?()
    }

    @objc func didPressClose() {
        dismiss(animated: true, completion: nil)
    }

    private func setUpLabelsAndConstraints() {
        transitioningDelegate = self
        modalPresentationStyle = .custom

        view.addSubview(containerView)
        view.addSubview(headerView)
        headerView.addSubview(closeButton)
        headerView.addSubview(titleLabel)
        view.addSubview(footerView)
        footerView.addSubview(footerActionsStackView)

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textAlignment = .center

        containerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerActionsStackView.translatesAutoresizingMaskIntoConstraints = false

        footerActionsStackView.axis = .vertical
        footerActionsStackView.distribution = .fillProportionally
        footerActionsStackView.spacing = sizeConfiguration.buttonSpacing

        headerView.layoutMargins = sizeConfiguration.viewPadding
        footerView.layoutMargins = sizeConfiguration.viewPadding

        if #available(iOS 13.0, *) {
            closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        } else {
            closeButton.setTitle("Close", for: .normal)
        }
        closeButton.addTarget(self, action: #selector(didPressClose), for: .touchUpInside)

        containerView.setContentHuggingPriority(.init(rawValue: 251), for: .vertical)
        headerView.setContentHuggingPriority(.init(rawValue: 250), for: .vertical)
        footerView.setContentHuggingPriority(.init(rawValue: 250), for: .vertical)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            titleLabel.firstBaselineAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor, constant: 20),
            headerView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerActionsStackView.topAnchor.constraint(equalTo: footerView.layoutMarginsGuide.topAnchor),
            footerActionsStackView.bottomAnchor.constraint(equalTo: footerView.layoutMarginsGuide.bottomAnchor),
            footerActionsStackView.leadingAnchor.constraint(equalTo: footerView.layoutMarginsGuide.leadingAnchor),
            footerActionsStackView.trailingAnchor.constraint(equalTo: footerView.layoutMarginsGuide.trailingAnchor),
        ])

        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true

        footerActionsStackView.arrangedSubviews.forEach { btn in
            btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
}
