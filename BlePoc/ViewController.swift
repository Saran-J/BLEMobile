//
//  ViewController.swift
//  BlePoc
//
//  Created by KTB_User on 15/12/2563 BE.
//  Copyright © 2563 KTB. All rights reserved.
//

import UIKit
import CoreBluetooth

struct ItemCell {
    let title:String
    let subTitle:String
}

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    @IBOutlet weak var table: UITableView!
    var dataSource:[ItemCell] = []
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            centralManager.scanForPeripherals(withServices: nil, options: nil)

            // Turned on
        }
        else {
            print("Something wrong with BLE")
            // Not on, but can have different issues
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataManufacturerDataKey) as? NSData else {
            return
        }
        
       
        var str1 : String = device.description
        str1 = str1.replacingOccurrences(of: "<", with: "")
        str1 = str1.replacingOccurrences(of: ">", with: "")
        if let value = Int(str1, radix: 16) {
            print("value",value)
        }


        let item = ItemCell(title: peripheral.name ?? "Unknown",
                            subTitle: device.description)

        if let _ = dataSource.first(where: { cell -> Bool in
            return cell.subTitle == item.subTitle
        }) {
            return
        }

        dataSource.append(item)
        self.table.reloadData()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("discoverCharacteristic")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.detailTextLabel?.numberOfLines = 0
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subTitle
        return cell
    }
}
