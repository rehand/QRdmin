//
//  HistoryViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 28/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableOutlet: UITableView!
    
    var devicesToDisplay = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        
        let allDevices = DeviceRepository().retrieveAllSavedDevices()
        for singleDevice: String in allDevices {
            devicesToDisplay.append(singleDevice)
        }
        
        tableOutlet.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableOutlet.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesToDisplay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell!.textLabel!.text = devicesToDisplay[indexPath.row]
        
        return cell!
    }
    
}

