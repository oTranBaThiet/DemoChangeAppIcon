//
//  AlternateIconItem.swift
//  ChangeAppIcon
//
//  Created by TranBa Thiet on 5/24/18.
//  Copyright © 2018 TranBa Thiet. All rights reserved.
//

import Foundation

struct AlternateIconItem {
    private(set) var identifier: String?
    var title: String?
    var imageName: String?

    init(identifier: String?, title: String?, imageName: String?) {
        self.identifier = identifier
        self.title = title
        self.imageName = imageName
    }
}
