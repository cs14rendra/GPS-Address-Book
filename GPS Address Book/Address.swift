//
//  AddressBook.swift
//  GPS Address Book
//
//  Created by surendra kumar on 7/2/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift


class Address : Object {
   dynamic var name    : String    = ""
   dynamic var details : String    = ""
   dynamic var lat     : Double    = 0.0
   dynamic var lon     : Double    = 0.0
   
}
