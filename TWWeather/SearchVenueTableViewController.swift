//
//  SearchVenueTableViewController.swift
//  TWWeather
//
//  Created by Zoe on 18/06/2016.
//  Copyright © 2016 Tingting Wen. All rights reserved.
//

import UIKit

class SearchVenueTableViewController: UITableViewController, UISearchControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    let SearchVenueTableViewCellIdentifier = "SearchVenueTableViewCell"
    let SearchResultToVenueDetailSegueIdentifier = "SearchResultToVenueDetailSegue"
    let SearchBarPlaceholderText = "Enter Suburb Or Country Name"
    
    let searchController = UISearchController(searchResultsController: nil)
    var venueArray: [Venue] = []
    var filteredArray: [Venue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        let backBarButton = UIBarButtonItem.init(image: UIImage.backBarButtonImage,
                                                 style: UIBarButtonItemStyle.Done,
                                                 target: self,
                                                 action: #selector(backButtonPressed(_:)))
        backBarButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBarButton
        
        // Set up search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false;
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self;
        searchController.searchBar.placeholder = SearchBarPlaceholderText;
        searchController.searchBar.sizeToFit()
        
        // Initiat filtered array
        filteredArray = venueArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Mark: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SearchResultToVenueDetailSegueIdentifier {
            if let indexPath = sender as? NSIndexPath,
                detailVC: WeatherDetailViewController = segue.destinationViewController as? WeatherDetailViewController {
                    detailVC.venue = filteredArray[indexPath.row]
            }
        }
    }
    
    
    // Mark: - Helper - Filter Data
    func filterContentForSearchText (searchText: String) {
        filteredArray = venueArray.filter{ ($0.venueName as NSString).localizedCaseInsensitiveContainsString("\(searchText)") ||
            ($0.country.name as NSString).localizedCaseInsensitiveContainsString("\(searchText)")
        }
    }
    
    
    // MARK: - TableView Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if filteredArray.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return 1
        } else {
            let messageLabel = UILabel.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = NSString.SearchTableNoDataMessage
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchVenueTableViewCellIdentifier, forIndexPath: indexPath)
        if indexPath.row < filteredArray.count, let venue: Venue = filteredArray[indexPath.row] {
            cell.textLabel?.text = venue.venueName + ", " + venue.country.name
            cell.textLabel?.textColor = UIColor.darkGrayColor()
        }
        return cell
    }
    
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SearchResultToVenueDetailSegueIdentifier, sender: indexPath)
    }
    
    
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    
    /// MARK: - IBActions
    func backButtonPressed(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
}
