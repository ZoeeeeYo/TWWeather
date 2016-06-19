//
//  VenuesTableViewController.swift
//  TWWeather
//
//  Created by Tingting Wen on 11/06/2016.
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
    let VenuesTableViewCellSegue: String = "VenuesTableViewCellSegue"
    let ToSearchSegue: String = "ToSearchBarControllerSegue"
    let AllPickerRowTitle = "All"
    let Ago = " ago"
    let DragDownToRefresh = "Drag down to refresh"
    let GoButtonTitle = "Go"
    let CancelButtonTitle = "Cancel"
    
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
        
        // Config segmented control
        sortSegControl.tintColor = UIColor.themeColour
        
        // Config refresh controller
        customRefreshController = UIRefreshControl()
        let lastUpdateDate = PersistencyManager.getLastUpdatedDate()
        var message = ""
        if let date = lastUpdateDate {
            message = NSString.LastUpdatedLabelName + date.getElapsedInterval() + Ago
        } else {
            message = DragDownToRefresh
        }
        customRefreshController.attributedTitle = NSAttributedString(string: message)
        customRefreshController.addTarget(self, action: #selector(VenuesTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(customRefreshController)
        
        // Navigation items
        
        let searchBarButton = UIBarButtonItem.init(image: UIImage.searchBarButtonImage,
                                                   style: UIBarButtonItemStyle.Done,
                                                   target: self,
                                                   action: #selector(searchButtonPressed(_:)))
        let filterBarButton = UIBarButtonItem.init(image: UIImage.filterBarButtonImage,
                                                   style: UIBarButtonItemStyle.Done,
                                                   target: self,
                                                   action: #selector(filterButtonPressed(_:)))
        searchBarButton.tintColor = UIColor.whiteColor()
        filterBarButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItems = [searchBarButton, filterBarButton]
        
        // Load data
        loadData()
        
        // Set up picker
        filterPickerView.hidden = true
        filterPickerView.dataSource = self
        filterPickerView.delegate = self
        filterPickerView.backgroundColor = UIColor.weatherDetailBackgroundColour
        filterPickerView.layer.borderColor = UIColor.weatherDetailBackgroundColour.CGColor
        filterPickerView.layer.borderWidth = 1
        
        // Set up picker tool bar
        toolBar.hidden = true
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = false
        toolBar.tintColor = UIColor.themeColour
        toolBar.layer.borderColor = UIColor.pickerTopBarColour.CGColor
        toolBar.barTintColor = UIColor.pickerTopBarColour
        toolBar.sizeToFit()
        let goButton = UIBarButtonItem(title: GoButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VenuesTableViewController.didPressGoButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: CancelButtonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VenuesTableViewController.togglePicker))
        toolBar.setItems([cancelButton, spaceButton, goButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        view.addSubview(filterPickerView)
        view.addSubview(toolBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenWidth = view.frame.size.width
        filterPickerView.frame = CGRectMake(0, view.frame.size.height - 200, screenWidth, 200)
        toolBar.frame = CGRectMake(0, view.frame.size.height - 250, screenWidth, 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == VenuesTableViewCellSegue {
            if let indexPath = sender as? NSIndexPath,
                detailVC: WeatherDetailViewController = segue.destinationViewController as? WeatherDetailViewController {
                detailVC.venue = filteredVenueArray[indexPath.row]
            }
        } else if segue.identifier == ToSearchSegue {
            if let searchVenueVC: SearchVenueTableViewController = segue.destinationViewController as? SearchVenueTableViewController {
                sortAllDataByAlphabet()
                searchVenueVC.venueArray = venueArray
            }
        }
    }
    
    ///MARK: - Load data
    func refresh() {
        loadData()
    }
    
    func loadData() {
        customRefreshController.beginRefreshing()
        let _ = try? NetworkManager.loadVenuesFromUrl(NSString.RequestUrl) { [unowned self] venueArray in
            if let venueArray = venueArray {
                self.venueArray = venueArray
            }
            self.customRefreshController.endRefreshing()
            PersistencyManager.storeLastUpdatedDate(NSDate())
            self.processPickerData()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.filterTableData()
            }
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

    // MARK: - TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if filteredVenueArray.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
            return 1
        } else {
            let messageLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
            messageLabel.text = NSString.VenueTableNoDataMessage
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            if messageLabel.hidden {
                messageLabel.hidden = false
            }
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
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
        if indexPath.row < filteredVenueArray.count, let c = cell as? VenuesTableViewCell {
                c.updateCell(filteredVenueArray[indexPath.row]);
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(VenuesTableViewCellSegue, sender: indexPath)
    }
    
    // MARK: - PickerView Data Source
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
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width/2
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    
    // MARK: - PickerView Delegate
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
    

    // MARK: - IBActions
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

    func filterButtonPressed (sender: UIBarButtonItem) {
        togglePicker()
    }
    
    func searchButtonPressed (sender: UIBarButtonItem) {
        performSegueWithIdentifier(ToSearchSegue, sender: self)
    }
    

    // MARK: Helpers for data sort
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
    
    private func sortAllDataByAlphabet() {
        venueArray.sortInPlace { (a, b) -> Bool in
            if a.country.name == b.country.name {
                return a.venueName < b.venueName
            }
            return a.country.name < b.country.name
        }
    }
}
