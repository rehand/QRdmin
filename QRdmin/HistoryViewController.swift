//
//  HistoryViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 28/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableOutlet: UITableView!
    
    var devicesToDisplay = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOutlet.delegate = self
        
        title = "The List"
        
        let allDevices = DeviceRepository().retrieveAllSavedDevices()
        for singleDevice: Device in allDevices {
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
        cell!.textLabel!.text = devicesToDisplay[indexPath.row].name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog(devicesToDisplay[indexPath.row].description)
        //goToDetailView(devicesToDisplay[indexPath.row])
    }
    
    func goToDetailView(device: Device){
        let destination = DetailViewController()
        destination.device = device
        navigationController?.pushViewController(destination, animated: true)
    }

    
}

