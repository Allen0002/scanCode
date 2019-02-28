//
//  ScanPaneImageView.swift
//  ScanCode
//
//  Created by wu ning on 2019/2/26.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit

class ScanPaneImageView: UIImageView {
    // interface
    /// start to scan barcode
    func playScanAnimation() {
        self.addSubview(self.scanLine)
        scanLine.layer.add(scanAnimation(), forKey: "scan")
    }
    
    func stopScanAnimation() {
        scanLine.layer.removeAnimation(forKey: "scan")
    }
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    /// private API
    private lazy var scanLine: UIImageView = {
        let scanLine = UIImageView()
        scanLine.frame = CGRect(x: 0, y: 50, width: self.bounds.width, height: 3)
        scanLine.image = UIImage(named: "QRCode_ScanLine")
        return scanLine
    }()
    
    private func scanAnimation() -> CABasicAnimation{
        let startPoint = CGPoint(x: scanLine.center.x , y: 1)
        let endPoint = CGPoint(x: scanLine.center.x, y: self.bounds.size.height - 2)
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = 3
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        return translation
    }
    
    override func awakeFromNib() {
        self.image = UIImage(named: "QRCode_ScanBox")
    }
}
