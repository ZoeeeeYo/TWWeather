//
//  VenuesTableViewController.swift
//  TWWeather
//
//  Created by Zoe on 11/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

enum SortType {
    case Alphabetically
    case Temperature
    case UpdateDate
}

class VenuesTableViewController: UITableViewController {
    let VenuesTableViewCellIdentifier = "VenuesTableViewCell"
    let URL: String = "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
    
    @IBOutlet weak var sortSegControl: UISegmentedControl!
    private var customRefreshController: UIRefreshControl!
    private var venueArray: [Venue] = []
    private var sortType: SortType = .Alphabetically

    override func viewDidLoad() {
        super.viewDidLoad()
        sortType = .Alphabetically
        
        // Refresh control.
        customRefreshController = UIRefreshControl()
        customRefreshController.attributedTitle = NSAttributedString(string: "Drag down to refresh")
        customRefreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = customRefreshController
        loadData()
    }
    
    func refresh() {
        loadData()
    }
    
    func loadData() {
        customRefreshController.beginRefreshing()
        let _ = try? NetworkManager.loadVenuesFromUrl(URL) { venueArray in
            print(venueArray?.count)
            if let venueArray = venueArray {
                self.venueArray = venueArray
            }
            self.tableView.reloadData()
            self.customRefreshController.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return venueArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VenuesTableViewCellIdentifier, forIndexPath: indexPath)
        if let c = cell as? VenuesTableViewCell {
            c.updateCell(venueArray[indexPath.row]);
//            c.populateWith(forumGroups[indexPath.section][indexPath.row], delegate: self)
        }
        return cell
    }
    
    
    @IBAction func sortSegmentPressed (sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
            case 0:
                sortType = .Alphabetically
            case 1:
                sortType = .Temperature
            case 2:
                sortType = .UpdateDate
            default:
                break;
        }
        self.tableView.reloadData()
    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
