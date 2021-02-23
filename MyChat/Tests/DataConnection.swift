//
//  Data.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 03.02.21.
//

import Foundation
import CoreData
import SwiftUI

extension Contact {
  static var contactFetch: NSFetchRequest<Contact> {
    let request: NSFetchRequest<Contact> = Contact.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    return request
  }
}

