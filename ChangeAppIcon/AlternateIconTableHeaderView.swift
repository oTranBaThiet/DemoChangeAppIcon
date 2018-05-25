//
//  AlternateIconTableHeaderView.swift
//  ChangeAppIcon
//
//  Created by TranBa Thiet on 5/24/18.
//  Copyright © 2018 TranBa Thiet. All rights reserved.
//

import UIKit

class AlternateIconTableHeaderView: UIView {

    private let kHeaderIconMarginTopAndBottom: CGFloat = 15
    private let kHeaderIconMarginLeft: CGFloat = 20
    private let kHeaderComponentItemMargin: CGFloat = 15
    private let kHeaderIconSize: CGFloat = 60

    private var iconView: UIImageView!
    private var currentIconLabel: UILabel!

    init(alternateIconItem: AlternateIconItem, frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        createSubViews()
        updateIconByIconItem(alternateIconItem: alternateIconItem)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubViews() {
        iconView = UIImageView()
        addSubview(iconView)
        currentIconLabel = UILabel()
        currentIconLabel.font = UIFont.boldSystemFont(ofSize: 17)
        currentIconLabel.numberOfLines = 1
        currentIconLabel.minimumScaleFactor = 0.2
        currentIconLabel.adjustsFontSizeToFitWidth = true
        currentIconLabel.text = "Current Icon"
        addSubview(currentIconLabel)
    }

    //override
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: kHeaderIconMarginLeft, y: kHeaderIconMarginTopAndBottom, width: kHeaderIconSize, height: kHeaderIconSize)
        iconView.updateCornerRadiusForAppIcon()
        currentIconLabel.frame = CGRect(x: iconView.frame.maxX + kHeaderComponentItemMargin,
                                        y: iconView.frame.minY + 15,
                                        width: bounds.width - kHeaderComponentItemMargin * 2 - iconView.frame.maxX,
                                        height: currentIconLabel.font.lineHeight)
    }

    func updateIconByIconItem(alternateIconItem: AlternateIconItem) {
        if let imageName = alternateIconItem.imageName {
            iconView.image = UIImage(named: imageName)
        }
    }

}
