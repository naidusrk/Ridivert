//
//  CampaignViewController.swift
//  Ridevert
//
//  Created by savaram, Ramakrishna on 26/07/2018.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit
import MBProgressHUD

class CampaignViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet  var tableView: UITableView!
    var dataArray  = NSMutableArray()
    var selectedCampaign = NSDictionary ()
    
    var mainContens = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10", "data11", "data12", "data13", "data14", "data15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        loadData()
        self.navigationItem.title = "Campaigns"
        self.tableView.registerCellNib(DataTableViewCell.self)
    }
    
    func loadData()
    
    {
        
        
        let url = URL(string: "https://project1-cbb37.firebaseio.com/campaign.json?auth=N4ON5oaqd5PFw5sx5JZUMwa1oqh5MJ0eiOa49bsZ")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                
                
                

               let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
              //  let dic = json as! [String:Any]
                for item in json
                {
                    var objectData:Dictionary = (json[item.key] as? Dictionary<String, Any>)!
                    
                    
                    objectData["campaignId"] = item.key
                    self.dataArray.add(objectData)

                   
                }


                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)


                }
                    

              

                print(self.dataArray ?? "")
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    
    func buttonCornerRadius( selectedButton : UIButton, backGroundHexcolor :String , borderColor : String, textColor : String, borderWidth :  CGFloat,  cornerRadius :  CGFloat , opacity : Float,
                             isEnabled: Bool) -> UIButton {
        
        
        let backGroundColor = hexStringToUIColor(hex: backGroundHexcolor)
        selectedButton.backgroundColor = backGroundColor
        
        let borderColor = hexStringToUIColor(hex: borderColor)
        selectedButton.layer.borderColor = borderColor.cgColor
        selectedButton.layer.borderWidth = borderWidth
        selectedButton.layer.cornerRadius = cornerRadius
        selectedButton.layer.opacity = opacity
        if isEnabled {
            selectedButton.isHighlighted  = true
            selectedButton.isEnabled     = true
            
        }
        else
        {
            selectedButton.isHighlighted  = false
            selectedButton.isEnabled     = false
            
        }
        selectedButton.setTitleColor(hexStringToUIColor(hex: textColor), for: .normal)
        selectedButton.setTitleColor(hexStringToUIColor(hex: textColor), for: .highlighted)
        selectedButton.setTitleColor(hexStringToUIColor(hex: textColor), for: .selected)
        
        // selectedButton.titleLabel?.textColor =  UIColor.red
        return selectedButton
        
        
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
  
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension CampaignViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        
        //        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        //        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        //        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
    func showAlert(string:String)
    {
        let aStr = String(format: "%@%@", string, "Campaign Selected")
        let alertController = UIAlertController(title: "Ridivert", message: aStr, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Select", style: .default) { (action:UIAlertAction) in
            self.showRideView()
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    func showRideView()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rideViewControllerRoot:RideViewController = storyboard.instantiateViewController(withIdentifier: "RideViewController") as! RideViewController
        rideViewControllerRoot.selectedDataDic = selectedCampaign

        
        let rideViewController = UINavigationController(rootViewController: rideViewControllerRoot)
        self.slideMenuController()?.changeMainViewController(rideViewController, close: true)
    }
}

extension CampaignViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
        
        let dataDic = dataArray[indexPath.row] as! NSDictionary
        
        cell.titleLable?.text = dataDic["name"] as? String
        cell.descriptionLabel?.text = dataDic["description"] as? String
        let priceStr = String(format: "%@%@", "$",(dataDic["limit"] as? String)!)
        cell.selectCampaignBtn.addTarget(self, action: #selector(selectedCampaign(sender:)), for: .touchUpInside)
        cell.selectCampaignBtn.tag = indexPath.row
        cell.priceLabel?.text = priceStr
        cell.selectCampaignBtn.layer.borderWidth = 1
        cell.selectCampaignBtn.layer.cornerRadius = 12
        cell.selectCampaignBtn.layer.opacity = 1
        
        
       // let data = DataTableViewCellData(imageUrl: "dummy", text: mainContens[indexPath.row])
        //cell.setData(data)
        return cell
    }
    
    @objc func selectedCampaign(sender: UIButton){

        
        selectedCampaign = dataArray[sender.tag] as! NSDictionary
        
        showAlert(string:(selectedCampaign["name"] as? String)!)
        
       
    }

}

extension CampaignViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
        
       
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

