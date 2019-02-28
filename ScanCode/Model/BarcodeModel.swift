//
//  BarcodeModel.swift
//  ScanCode
//
//  Created by wu ning on 2019/2/26.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit

struct BarcodeModel {
    var time:Date
    var code:String
    init(_ time:Date, code:String) {
        self.time = time
        self.code = code
    }
}
