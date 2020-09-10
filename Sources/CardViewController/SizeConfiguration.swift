//
//  SizeConfiguration.swift
//  CardViewController
//
//  Created by Przemyslaw Bobak on 10/09/2020.
//

import UIKit

public struct SizeConfiguration {
    public let minimum: CGSize
    public let maximum: CGSize?
    public let buttonSpacing: CGFloat
    public let viewPadding: UIEdgeInsets

    public static let `default`: SizeConfiguration = SizeConfiguration(
        minimum: CGSize(width: 375, height: 375),
        maximum: nil,
        buttonSpacing: 10,
        viewPadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    )
}
