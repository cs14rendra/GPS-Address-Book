//
//  SecondViewController.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/2/17.
//  Copyright © 2017 weza. All rights reserved.
//

import UIKit
import RealmSwift

class BookViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet var tableView: UITableView!
    let ResultsearchController  = UISearchController(searchResultsController: nil)
    
    var addressBook : [Address]?
    var filteredDddressBook = [Address]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 0.95)
        
        ResultsearchController.searchResultsUpdater = self
        definesPresentationContext = true
        ResultsearchController.dimsBackgroundDuringPresentation = false
        ResultsearchController.searchBar.placeholder = "Search"
        ResultsearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        tableView.tableHeaderView = ResultsearchController.searchBar
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getValue()
       
        
    }

    func getValue(){
        AddressBookDB.sharedInstance.fetchAddress { (result) in
            self.addressBook = Array(result)
            
            if let _ = self.addressBook{
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                }
            }
        
      
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapDetails" {
            if let index = tableView.indexPathForSelectedRow{
                let dst = segue.destination as! BookDetailsViewController
                if self.ResultsearchController.isActive{
                    dst.lat = filteredDddressBook[index.row].lat
                    dst.lon = filteredDddressBook[index.row].lon
                    dst.titleName = filteredDddressBook[index.row].name
                }else{
                    dst.lat = addressBook?[index.row].lat
                    dst.lon = addressBook?[index.row].lon
                    dst.titleName = addressBook?[index.row].name
                }
                
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //searchController.searchBar.text!.lowercased()
        filterSearchMethod(searchController.searchBar.text!)
       
        
    }
    
    func filterSearchMethod(_ searchText:String){
        
        filteredDddressBook =  addressBook!.filter{
            address in
            return address.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension BookViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if self.ResultsearchController.isActive{
            return filteredDddressBook.count
        }
        
        if let add = addressBook {
            count = add.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookTableViewCell
        if self.ResultsearchController.isActive{
            cell.placeName.text = self.filteredDddressBook[indexPath.row].name
            cell.details.text = self.filteredDddressBook[indexPath.row].details
        }else{
        cell.placeName.text = self.addressBook?[indexPath.row].name
        cell.details.text = self.addressBook?[indexPath.row].details
        }
        
        return cell
    }
}

extension BookViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            print("delet")
            do{
            let realm = try Realm()
            let obj = self.addressBook?[indexPath.row]
            try realm.write {
                realm.delete(obj!)
            }
                self.addressBook?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .top)
            }catch{
                print(error.localizedDescription)
            }
        }
        
        let share = UITableViewRowAction(style: .destructive, title: "share") { (action, indexPath) in
            self.share(index : indexPath)
        }
        share.backgroundColor = UIColor(red: 49/255, green: 27/255, blue: 146/255, alpha: 0.90)
        return [delete,share]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            addressBook?.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .top)
    }
    
    func share(index : IndexPath) {
        let name = self.addressBook![index.row].name
        let acivity1 = "\(name) location is : "
       let activity2 = "http://maps.apple.com/?ll=\(self.addressBook![index.row].lat),\(self.addressBook![index.row].lon)&z=17&q=\(name)"
        //let activity2 = "htdtp://maps.apple.com/?ll=28,70&z=20&q=dest"
        let activity = UIActivityViewController(activityItems: [acivity1,activity2], applicationActivities: nil)
        
        
        activity.popoverPresentationController?.sourceView = self.view
        
        present(activity, animated: true, completion: nil)
        
    }
    
}



