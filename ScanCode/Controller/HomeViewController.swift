//
//  ViewController.swift
//  ScanCode
//
//  Created by Allen on 2019/2/27.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var dataProvider = BarcodeDataProvider()
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToHistory" {
            let historyController = segue.destination as! HistoryViewController
            historyController.dataProvider = dataProvider
        }
        if segue.identifier == "HomeToScan" {
            let scanController = segue.destination as! ScanViewController
            scanController.delegate = self
        }
    }
    
    private func updateUI(model: BarcodeModel){
        resultLabel.text = "Code is: \(model.code)"
    }
}

extension HomeViewController:ScanViewControllerDelegate{
    func completeGetBarcode(_ model: BarcodeModel, vc: ScanViewController) {
        vc.navigationController?.popViewController(animated: true)
        self.updateUI(model: model)
        _ = dataProvider.addBarcodeModel(model: model)
    }
}
