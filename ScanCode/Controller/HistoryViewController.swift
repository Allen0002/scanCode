//
//  HistoryViewController.swift
//  ScanCode
//
//  Created by wu ning on 2019/2/26.
//  Copyright © 2019 allen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataProvider: BarcodeDataProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cellId")
    }
}

extension HistoryViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider?.barcodeArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        if let model = dataProvider?.barcodeArray[indexPath.row]{
            cell.textLabel?.text = "Code:" + model.code + "  Time: \(model.time)"
        }
        return cell
    }
}
