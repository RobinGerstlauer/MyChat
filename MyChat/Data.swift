//
//  Data.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 03.02.21.
//

import Foundation
import CoreData
import SwiftUI

class DataConnection{
    @Environment(\.managedObjectContext) private var viewContext
    
    
}
/*
let contactRequest = FetchRequest<Contact>(entity: Contact.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)], predicate: nil)

var contacts = FetchedResults<Contact>{ contactRequest.wrappedValue}
 */
