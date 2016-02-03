//
//  FavoriteViewController.swift
//  QRdmin
//
//  Created by Handler Reinhard on 28/11/15.
//  Copyright © 2015 FH Joanneum. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var devicesToDisplay = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        favoritesTableView.delegate = self
        
        let allDevices = DeviceRepository().retrieveAllFavoriteDevices()
        for singleDevice: Device in allDevices {
            devicesToDisplay.append(singleDevice)
        }
        
        self.favoritesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.favoritesTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesToDisplay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.favoritesTableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel!.text = devicesToDisplay[indexPath.row].name
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}