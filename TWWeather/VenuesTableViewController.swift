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
    let VenuesTableViewCellSegue: String = "VenuesTableViewCellSegue"
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == VenuesTableViewCellSegue {
            if let indexPath = sender as? NSIndexPath, detailVC:WeatherDetailViewController = segue.destinationViewController as? WeatherDetailViewController {
                detailVC.venue = venueArray[indexPath.row]
            }
        }
    }
    
    ///MARK: - Load data
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

    /// MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VenuesTableViewCellIdentifier, forIndexPath: indexPath)
        if let c = cell as? VenuesTableViewCell {
            c.updateCell(venueArray[indexPath.row]);
        }
        return cell
    }
    
    /// MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(VenuesTableViewCellSegue, sender: indexPath)
    }
    
    @IBAction func sortSegmentPressed (sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
            case 0:
                sortType = .Alphabetically
            case 1:
                sortType = .Temperature
                sortByTemperature()
            case 2:
                sortType = .UpdateDate
                sortByDate()
            default:
                break;
        }
        self.tableView.reloadData()
    }

    /// MARK: Helpers for data sort
    private func sortByTemperature() {
        venueArray.sortInPlace { (a, b) -> Bool in
            return a.temperature > b.temperature
        }
    }
    
    private func sortByDate() {
        venueArray.sortInPlace { (a, b) -> Bool in
            if let _ = a.lastUpdated where b.lastUpdated == nil {
                return true
            }
            if let _ = b.lastUpdated where a.lastUpdated == nil {
                return false
            }
            if let aLast = a.lastUpdated, bLast = b.lastUpdated {
                return aLast.compare(bLast) == NSComparisonResult.OrderedDescending
            }
            return true
        }
    }
}
