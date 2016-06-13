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

class VenuesTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let VenuesTableViewCellIdentifier = "VenuesTableViewCell"
    let URL: String = "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
    let VenuesTableViewCellSegue: String = "VenuesTableViewCellSegue"
    let AllPickerRowTitle = "All"
    
    @IBOutlet weak var sortSegControl: UISegmentedControl!
    var filterPickerView: UIPickerView = UIPickerView()
    private var customRefreshController: UIRefreshControl!
    private var venueArray: [Venue] = []
    private var countryNameArray: [String] = []
    private var weatherConditionArray: [String] = []
    private var sortType: SortType = .Alphabetically
    private var selectedCountry: String = ""
    private var selectedWeatherCondition: String = ""
    private var screenWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        sortType = .Alphabetically
        
        // Refresh control
        customRefreshController = UIRefreshControl()
        customRefreshController.attributedTitle = NSAttributedString(string: "Drag down to refresh")
        customRefreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = customRefreshController
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        screenWidth = view.frame.size.width
        
        // Set up picker
        self.filterPickerView.hidden = true
        self.filterPickerView.dataSource = self
        self.filterPickerView.delegate = self
        self.filterPickerView.frame = CGRectMake(0, view.frame.size.height - 350, screenWidth, 350)
        self.filterPickerView.backgroundColor = UIColor.whiteColor()
        self.filterPickerView.layer.borderColor = UIColor.whiteColor().CGColor
        self.filterPickerView.layer.borderWidth = 1
        view.addSubview(filterPickerView)
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
    
    /// MARK: - Picker view data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return countryNameArray.count
        } else {
            return weatherConditionArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            if row > 0 {
                return countryNameArray[row - 1] as String
            } else {
                return AllPickerRowTitle
            }
        } else {
            if row > 0 {
                return weatherConditionArray[row - 1] as String
            } else {
                return AllPickerRowTitle
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row > 0 {
                selectedCountry = countryNameArray[row - 1] as String
            } else {
                selectedCountry = ""
            }
        } else {
            if row > 0 {
                selectedWeatherCondition = weatherConditionArray[row - 1] as String
            } else {
                selectedWeatherCondition = ""
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth/2
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    
    ///MARK: - IBActions
    
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
    
    @IBAction func filterButtonPressed (sender: UIBarButtonItem) {
        
        if filterPickerView.hidden == true {
            filterPickerView.hidden = false
        } else {
            filterPickerView.hidden = true
        }
        
        
        
//        let actionSheetController: UIAlertController = UIAlertController(title: "Filtered By", message: "", preferredStyle: .ActionSheet)
//        
//        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
//        }
//        actionSheetController.addAction(cancelAction)
//        let byCountry: UIAlertAction = UIAlertAction(title: "Country", style: .Default) { action -> Void in
//            //Code for launching the camera goes here
//        }
//        actionSheetController.addAction(byCountry)
//        
//        let byWeather: UIAlertAction = UIAlertAction(title: "Weather", style: .Default) { action -> Void in
//            //Code for picking from camera roll goes here
//        }
//        actionSheetController.addAction(byWeather)
//        
//        //Present the AlertController
//        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
        
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
