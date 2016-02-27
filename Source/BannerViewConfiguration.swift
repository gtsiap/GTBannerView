//
//  BannerViewConfiguration.swift
//  GTBannerView
//
//  Created by Giorgos Tsiapaliokas on 27/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public struct BannerViewConfiguration {
    public var duration: Double = 0.5
    public var position: BannerViewPosition = .NavigationBar

    public var title: String?
    public var titleFont: UIFont?
    public var titleColor: UIColor?

    public var description: String?
    public var descriptionFont: UIFont?
    public var descriptionColor: UIColor?

    public var image: UIImage?
    public var imageColor: UIColor?

    public init() {}
}
