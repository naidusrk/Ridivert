//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case campaigns = 0
    case ride
    case earnings
    case referrals
    case help
    case settings

}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Campaigns","On Going Ride", "Earnings","Referrals","Help","Settings"]
    var campgainViewController: UIViewController!
    var rideViewController: UIViewController!
    var earningsViewController: UIViewController!
    var referralViewController: UIViewController!
    var helpViewController: UIViewController!
    var settingsViewController: UIViewController!

    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //testing git
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "CampaignViewController") as! CampaignViewController
        self.campgainViewController = UINavigationController(rootViewController: swiftViewController)
        
    
        let footerNib = UINib.init(nibName: "CustomFooter", bundle: Bundle.main)
        self.tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: "CustomFooter")
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        let userProfileName = UserDefaults.standard.object(forKey: "profilename")

        self.imageHeaderView.profileName.text = userProfileName as! String
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .campaigns:
            self.slideMenuController()?.changeMainViewController(self.campgainViewController, close: true)
        case .ride:
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let swiftViewController = storyboard.instantiateViewController(withIdentifier: "RideViewController") as! RideViewController
             let rideViewControllerRoot = storyboard.instantiateViewController(withIdentifier: "RideViewController") as! RideViewController
            self.rideViewController = UINavigationController(rootViewController: rideViewControllerRoot)
            self.slideMenuController()?.changeMainViewController(self.rideViewController, close: true)
            
       
        case .earnings:
            self.slideMenuController()?.changeMainViewController(self.earningsViewController, close: true)
            
        case .referrals:
            self.slideMenuController()?.changeMainViewController(self.referralViewController, close: true)
            
        case .help:
            self.slideMenuController()?.changeMainViewController(self.helpViewController, close: true)
            
        case .settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
       
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return 100
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFooter") as! CustomFooter
            footerView.bottomButton.setTitle("SignOut", for: UIControlState.normal)
            footerView.bottomButton.addTarget(self, action: #selector(self.logoutButton(_:)), for: .touchUpInside) //<- use `#selector(...)`
            return footerView
       
        
    }
    
    @objc func logoutButton(_ sender: UIButton){ //<- needs `@objc`
        print("\(sender)")
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:"isLoggedIn")
        prefs.removeObject(forKey:"profilename")
        prefs.removeObject(forKey:"profileimage")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginScreen()

        
        
        
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .campaigns, .ride, .earnings, .referrals, .help,.settings:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
    
    
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .campaigns, .ride, .earnings, .referrals, .help,.settings:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
