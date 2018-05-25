//
//  AlternateIconTableViewCell.swift
//  ChangeAppIcon
//
//  Created by TranBa Thiet on 5/24/18.
//  Copyright © 2018 TranBa Thiet. All rights reserved.
//

import UIKit

class AlternateIconTableViewCell: UITableViewCell {

    private let kImageMarginLeft: CGFloat = 20
    private let kImageSize: CGFloat = 60

    //override
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 2
        textLabel?.minimumScaleFactor = 0.2
        textLabel?.adjustsFontSizeToFitWidth = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //override
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: kImageMarginLeft, y: (bounds.height - kImageSize) / 2, width: kImageSize, height: kImageSize)
        textLabel?.frame = CGRect(x: (kImageMarginLeft * 2) + kImageSize , y: (bounds.height - kImageSize) / 2, width: kImageSize * 2, height: kImageSize)
        imageView?.updateCornerRadiusForAppIcon()
    }

    func updateCell(alternateIconItem: AlternateIconItem) {
        if let imageName = alternateIconItem.imageName {
            imageView?.image = UIImage(named: imageName)
        }
        textLabel?.text = alternateIconItem.title
    }
}

extension UIImageView {
    func updateCornerRadiusForAppIcon() {
        layer.masksToBounds = true
        let size = self.frame.width
        layer.cornerRadius = size * 9 / 40
    }
}
