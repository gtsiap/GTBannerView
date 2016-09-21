// Copyright (c) 2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SnapKit

open class BannerView: UIView {
    open var didTapBanner: (() -> ())?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private var imageView: UIImageView?

    private let configuration: BannerViewConfiguration
    private weak var viewController: UIViewController!
    private var heightConstraint: Constraint?
    private var visibilityConstraint: Constraint?

    private lazy var swipeGesture: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipeUp)
        )

        swipe.direction = .up

        return swipe
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapGesture)
        )

        tap.numberOfTapsRequired = 1

        return tap
    }()

    private var targetView: UIView {
        let targetView: UIView

        if configuration.position == .navigationBar {
            targetView = self.viewController.view
        } else {
            targetView = UIApplication.shared
                .windows[0]
        }

        return targetView
    }

    init(
        configuration: BannerViewConfiguration,
        viewController: UIViewController
    ) {
        self.configuration = configuration
        self.viewController = viewController
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("Missing Implementation")
    }

    private func commonInit() {
        configureTitle()
        configureDescription()
        configureImage()
        setupConstraints()

        self.addGestureRecognizer(self.swipeGesture)
        self.addGestureRecognizer(self.tapGesture)
    }

    private func configureTitle() {
        if let titleText = self.configuration.title {
            self.titleLabel.text = titleText
        }

        if let titleFont = self.configuration.titleFont {
            self.titleLabel.font = titleFont
        }

        if let titleColor = self.configuration.titleColor {
            self .titleLabel.textColor = titleColor
        }
    }

    private func configureDescription() {
        if let description = self.configuration.description {
            self.descriptionLabel.text = description
        }


        if let descriptionFont = self.configuration.descriptionFont {
            self.descriptionLabel.font = descriptionFont
        }

        if let descriptionColor = self.configuration.descriptionColor {
            self .descriptionLabel.textColor = descriptionColor
        }
    }

    private func configureImage() {
        if let image = self.configuration.image {
            let imageView = UIImageView(image: image)
            self.imageView = imageView

            if let imageColor = self.configuration.imageColor {
                self.imageView?.tintColor = imageColor
                self.imageView?.image = image
                    .withRenderingMode(.alwaysTemplate)
            } else {
                self.imageView = imageView
            }
        }
    }

    private func setupConstraints() {
        [
            self.titleLabel,
            self.descriptionLabel
        ].forEach() { addSubview($0) }

        if let imageView = self.imageView {
            addSubview(imageView)
            imageView.snp.makeConstraints() { make in
                make.centerY.equalTo(self)
                make.leading.equalTo(self).offset(10)
            }

            imageView.setContentHuggingPriority(1000, for: .horizontal)
        }

        self.titleLabel.snp.makeConstraints() { make in
            let offSet = self.configuration.position == .statusBar ?
                UIApplication.shared.statusBarFrame.height
                : 0
            make.top.equalTo(self).offset(offSet)
        }

        self.descriptionLabel.snp.makeConstraints() { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10).priority(UILayoutPriorityDefaultLow)
            make.bottom.equalTo(self).offset(-10)
        }

        [self.titleLabel, self.descriptionLabel].forEach() {
            $0.snp.makeConstraints() { make in
                make.trailing.equalTo(self).offset(-10)

                if let imageView = self.imageView {
                    make.leading.equalTo(imageView.snp.trailing).offset(10)
                } else {
                    make.leading.equalTo(self).offset(10)
                }
            }
        } // end forEach
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        guard let _ = self.superview else { return }

        self.translatesAutoresizingMaskIntoConstraints = false

        self.snp.makeConstraints() { make in
            make.leading.trailing.equalTo(self.targetView)
            if configuration.position == .navigationBar {
                make.top.equalTo(self.viewController.topLayoutGuide.snp.bottom)//.snp.topLayoutGuideBottom)
                self.visibilityConstraint = make.bottom.equalTo(self.snp.top).constraint
            } else {
                self.visibilityConstraint = make.top.equalTo(self.targetView)
                    .offset(-self.targetView.frame.height / 2).constraint
            }
        }

        self.setContentCompressionResistancePriority(1000, for: .vertical)
    }

    public func show() {
        self.targetView.layoutIfNeeded()

        if self.configuration.position == .navigationBar {
            self.visibilityConstraint?.deactivate()
        } else {
            self.visibilityConstraint?.update(offset: 0)
        }

        UIView.animate(withDuration: self.configuration.duration, animations: {
            self.targetView.layoutIfNeeded()
        }) 
    }

    public func hide() {
        self.targetView.layoutIfNeeded()
        if self.configuration.position == .navigationBar {
            self.visibilityConstraint?.activate()
        } else {
            self.visibilityConstraint?
                .update(offset: -self.targetView.frame.height / 2)
        }

        UIView.animate(withDuration: self.configuration.duration,
        animations: {
            self.targetView.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        }) 
    }

    @objc private func didSwipeUp() {
        hide()
    }

    @objc private func didTapGesture() {
        hide()
        self.didTapBanner?()
    }
}
