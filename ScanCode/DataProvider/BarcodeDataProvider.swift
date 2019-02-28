//
//  BarcodeDataProvider.swift
//  ScanCode
//
//  Created by wu ning on 2019/2/27.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit

struct BarcodeDataProvider {
    public private(set) var barcodeArray = Array<BarcodeModel>()
    mutating func addBarcodeModel(model:BarcodeModel) -> Array<BarcodeModel> {
        barcodeArray.append(model)
        return barcodeArray
    }
    /// get barcodeModel
    mutating func getModel(_ page: Int, numberOfCount: Int? = 10) -> Array<BarcodeModel>? {
        let count = numberOfCount ?? 10
        guard page * count < barcodeArray.count else {
            print("the data was out of range")
            return nil
        }
        if page * (count + 1) <= barcodeArray.count {
            return Array(barcodeArray[(page * count)...(page * (count + 1))])
        }else{
            return Array(barcodeArray[(page * count)...(barcodeArray.count - 1)])
        }
    }
}
