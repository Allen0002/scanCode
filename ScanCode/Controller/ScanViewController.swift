//
//  ScanViewController.swift
//  ScanCode
//
//  Created by wu ning on 2019/2/27.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit

protocol ScanViewControllerDelegate:NSObjectProtocol {
    func completeGetBarcode(_ model: BarcodeModel,vc:ScanViewController)
}

class ScanViewController: UIViewController {
    
    weak var delegate: ScanViewControllerDelegate?
    
    @IBOutlet weak var scanView: ScanPaneImageView!
    lazy var scanManager:ScanManager = {
        let scan = ScanManager(self.view.layer,rectOfScan: scanView.frame)
        scan.delegate = self
        return scan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanView.playScanAnimation()
        self.scanManager.startScan()
    }
}

extension ScanViewController: ScanManagerDelegate{
    func metadataOutput(_ model: BarcodeModel, error: ScanError?) {
        if let err = error {
            print("ScanViewController ERROR: \(err)")
        }else{
            self.delegate?.completeGetBarcode(model, vc: self)
        }
    }
}
