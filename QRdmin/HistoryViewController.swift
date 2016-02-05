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
        self.reloadData()
        tableOutlet.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.tableOutlet.reloadData()
    }
    
    private func reloadData() {
        devicesToDisplay = [Device]()
        
        let allDevices = DeviceRepository().retrieveAllSavedDevices()
        for singleDevice: Device in allDevices {
            devicesToDisplay.append(singleDevice)
        }
        
        self.tableOutlet.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
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
        goToDetailView(devicesToDisplay[indexPath.row])
    }
    
    func goToDetailView(device: Device){
        let client = DeviceServerClient()
        
        client.retrieve(device.id){
            (device, error) -> Void in
            if error != nil {
                print(error)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("viewDetailDeviceSegue", sender: device)
                })
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewDetailDeviceSegue" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.device = sender as? Device
        }
    }
    
}

