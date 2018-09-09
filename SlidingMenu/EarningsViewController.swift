//
//  EarningsViewController.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 26/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit

class EarningsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let visitCoredataManager = CoreDataManager(modelName: "Mapping")
    var dataArray  = NSMutableArray()

    @IBOutlet weak var earningsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()

        // Do any additional setup after loading the view.
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedCampaign  = visitCoredataManager.fetchAllCampaigns("Map", inManagedObjectContext: visitCoredataManager.managedObjectContext)
        for location in selectedCampaign {
            dataArray.add(location)
        }

        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = earningsTable.dequeueReusableCell(withIdentifier:"EarningsTableViewCell") as! EarningsTableViewCell
        
        
        let dataDic = dataArray[indexPath.row]
        cell.nameLable?.text = (dataDic as AnyObject).value(forKey: "name") as? String
        cell.priceLabel.text = String(format:"%.3f miles", (dataDic as AnyObject).value(forKey: "miles") as! Double)
        
        
        let x : Int = (dataDic as AnyObject).value(forKey: "pauseCount") as! Int
        let myString1 = String(x)
        cell.pauseCountLabel.text = String(format:"No of times Paused: %@",myString1)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let myString = formatter.string(from: (dataDic as AnyObject).value(forKey: "timestamp") as! Date) // string purpose I add here
        cell.dateLabel.text = myString


        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
