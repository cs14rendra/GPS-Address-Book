//
//  AddressBookDB.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/2/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import RealmSwift

class AddressBookDB{
    public static let sharedInstance = AddressBookDB()
    
    
    
    func storeAddress(address : Address){
        
       // try! FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            let realm = try Realm()
            try realm.write {
                //realm.deleteAll()
                realm.add(address)
                print("DATA SAVED")
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func fetchAddress(completion : @escaping (_ result :Results<Address>) -> ()){
        // check for nil value at time fetching 
        var value : Results<Address>? = nil
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                value = realm.objects(Address.self)
                completion(value!)
            }catch{
                completion(value!)
                print(error.localizedDescription)
            }
        }
       
    }
}
