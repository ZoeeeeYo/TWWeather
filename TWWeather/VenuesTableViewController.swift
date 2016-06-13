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

class VenuesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let VenuesTableViewCellIdentifier = "VenuesTableViewCell"
    let URL: String = "http://dnu5embx6omws.cloudfront.net/venues/weather.json"
    let VenuesTableViewCellSegue: String = "VenuesTableViewCellSegue"
    let AllPickerRowTitle = "All"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegControl: UISegmentedControl!
    
    var filterPickerView: UIPickerView = UIPickerView()
    var toolBar: UIToolbar  = UIToolbar()
    private var customRefreshController: UIRefreshControl!
    private var venueArray: [Venue] = []
    private var filteredVenueArray: [Venue] = []
    private var sortType: SortType = .Alphabetically
    private var sortedCountryArray: [Country] = []
    private var sortedWeatherConditionArray: [WeatherCondition] = []
    private var selectedCountry: Country?
    private var selectedWeatherCondition: WeatherCondition?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Refresh control
        customRefreshController = UIRefreshControl()
        customRefreshController.attributedTitle = NSAttributedString(string: "Drag down to refresh")
        customRefreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(customRefreshController)
        loadData()
        
        // Set up picker
        filterPickerView.hidden = true
        filterPickerView.dataSource = self
        filterPickerView.delegate = self
        filterPickerView.backgroundColor = UIColor.whiteColor()
        filterPickerView.layer.borderColor = UIColor.whiteColor().CGColor
        filterPickerView.layer.borderWidth = 1
        
        toolBar.hidden = true
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = false
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let goButton = UIBarButtonItem(title: "Go", style: UIBarButtonItemStyle.Plain, target: self, action: "didPressGoButton")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "togglePicker")
        toolBar.setItems([cancelButton, spaceButton, goButton], animated: false)
        toolBar.userInteractionEnabled = true
        view.addSubview(filterPickerView)
        view.addSubview(toolBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenWidth = view.frame.size.width
        filterPickerView.frame = CGRectMake(0, view.frame.size.height - 300, screenWidth, 300)
        toolBar.frame = CGRectMake(0, view.frame.size.height - 350, screenWidth, 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == VenuesTableViewCellSegue {
            if let indexPath = sender as? NSIndexPath, detailVC:WeatherDetailViewController = segue.destinationViewController as? WeatherDetailViewController {
                detailVC.venue = filteredVenueArray[indexPath.row]
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
//            self.tableView.reloadData()
            self.customRefreshController.endRefreshing()
            self.processPickerData()
            self.filterTableData()
        }
    }
    
    /// MARK: - Process picker data
    func processPickerData() {
        var countrySet: Set<Country> = Set()
        var weatherConditionSet: Set<WeatherCondition> = Set()
        
        venueArray.forEach({
            countrySet.insert($0.country)
            
            if let weatherCondition = $0.weatherCondition {
                weatherConditionSet.insert(weatherCondition)
            }
        })
        sortedCountryArray = countrySet.sort { $0.name < $1.name }
        sortedWeatherConditionArray = weatherConditionSet.sort { $0.rawValue < $1.rawValue}
        filterPickerView.reloadAllComponents()
    }
    
    
    /// MARK: - Filter
    func didPressGoButton() {
        filterTableData()
        togglePicker()
    }
    
    func filterTableData() {
        filteredVenueArray = venueArray.filter({
            var filter = true
            if let selectedCountry = selectedCountry {
                filter = $0.country == selectedCountry
            }
            if filter, let selectedWeatherCondition = selectedWeatherCondition {
                filter = $0.weatherCondition == selectedWeatherCondition
            }
            return filter
        })
        sortFilteredVenueArray()
        tableView.reloadData()
    }
    
    func togglePicker() {
        if filterPickerView.hidden {
            filterPickerView.hidden = false
            toolBar.hidden = false
        } else {
            filterPickerView.hidden = true
            toolBar.hidden = true
        }
        filterPickerView.setNeedsLayout()
    }

    /// MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if filteredVenueArray.count > 0 {
            return 1
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVenueArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VenuesTableViewCellIdentifier, forIndexPath: indexPath)
        if let c = cell as? VenuesTableViewCell {
            c.updateCell(filteredVenueArray[indexPath.row]);
        }
        return cell
    }
    
    /// MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(VenuesTableViewCellSegue, sender: indexPath)
    }
    
    /// MARK: - Picker view data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return sortedCountryArray.count
        } else {
            return sortedWeatherConditionArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row > 0 {
                return sortedCountryArray[row - 1].name
            } else {
                return AllPickerRowTitle
            }
        } else {
            if row > 0 {
                return sortedWeatherConditionArray[row - 1].rawValue
            } else {
                return AllPickerRowTitle
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row > 0 {
                selectedCountry = sortedCountryArray[row - 1]
            } else {
                selectedCountry = nil
            }
        } else {
            if row > 0 {
                selectedWeatherCondition = sortedWeatherConditionArray[row - 1]
            } else {
                selectedWeatherCondition = nil
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width/2
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    
    ///MARK: - IBActions
    @IBAction func sortSegmentPressed(sender: AnyObject) {
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
        sortFilteredVenueArray()
        self.tableView.reloadData()
    }

    @IBAction func filterButtonPressed (sender: UIBarButtonItem) {
        togglePicker()
    }
    

    /// MARK: Helpers for data sort
    private func sortFilteredVenueArray() {
        if sortType == .Alphabetically {
            sortByAlphabet()
        } else if sortType == .Temperature {
            sortByTemperature()
        } else {
            sortByDate()
        }
    }
    
    private func sortByAlphabet() {
        filteredVenueArray.sortInPlace { (a, b) -> Bool in
            return a.venueName < b.venueName
        }
    }
    
    private func sortByTemperature() {
        filteredVenueArray.sortInPlace { (a, b) -> Bool in
            return a.temperature > b.temperature
        }
    }
    
    private func sortByDate() {
        filteredVenueArray.sortInPlace { (a, b) -> Bool in
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
