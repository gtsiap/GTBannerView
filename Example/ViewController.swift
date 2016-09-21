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
import GTBannerView

class ViewController: UIViewController {

    var bannerView: BannerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let b1 = createButton(
            "Show Banner for Navigation Bar",
            action: "showBannerForNavigationBar"
        )

        b1.snp.makeConstraints() { make in
            make.center.equalTo(self.view)
        }

        let b2 = createButton(
            "Hide Banner for Navigation Bar",
            action: "hideBannerForNavigationBar"
        )

        b2.snp.makeConstraints() { make in
            make.top.equalTo(b1.snp.bottom).offset(10)
            make.centerX.equalTo(b1)
        }

        let b3 = createButton(
            "Show Banner for Status Bar",
            action: "showBannerForStatusBar"
        )

        b3.snp.makeConstraints() { make in
            make.top.equalTo(b2.snp.bottom).offset(10)
            make.centerX.equalTo(b1)
        }

        let b4 = createButton(
            "Hide Banner for Status Bar",
            action: "hideBannerForStatusBar"
        )

        b4.snp.makeConstraints() { make in
            make.top.equalTo(b3.snp.bottom).offset(10)
            make.centerX.equalTo(b1)
        }
    }

    private func createButton(_ title: String, action: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: UIControlState())
        button.addTarget(self, action: Selector(action), for: .touchUpInside)

        self.view.addSubview(button)

        return button
    }

    @objc private func showBannerForNavigationBar() {

        var bannerConfig = BannerViewConfiguration()
        bannerConfig.title = "Network Notification"
        bannerConfig.titleColor = UIColor.white
        bannerConfig.description = "Your device isn't connected to a Network"
        bannerConfig.descriptionColor = UIColor.white
        bannerConfig.image = UIImage(named: "info")

        self.bannerView = self.showBannerView(bannerConfig)

        self.bannerView?.didTapBanner = {
            print("Did Tap Banner")
        }
    }

    @objc private func hideBannerForNavigationBar() {
        self.bannerView?.hide()
    }

    @objc private func showBannerForStatusBar() {
        var bannerConfig = BannerViewConfiguration()
        bannerConfig.title = "New Message"
        bannerConfig.titleColor = UIColor.black
        bannerConfig.description = "You have a new message"
        bannerConfig.descriptionColor = UIColor.black
        bannerConfig.image = UIImage(named: "info")
        bannerConfig.position = .statusBar
        bannerConfig.imageColor = UIColor.black

        self.bannerView = self.showBannerView(
            bannerConfig,
            backgroundColor: UIColor.yellow
        )
    }

    @objc private func hideBannerForStatusBar() {
        self.bannerView?.hide()
    }
}

