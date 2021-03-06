//
//  DatabaseConection.swift
import CoreData
import Foundation
import SwiftUI


struct getContact:View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var contactRequest : FetchRequest<Contact>
    //fetching results
    var contacts : FetchedResults<Contact>{contactRequest.wrappedValue}
    
    init() {
        //making fetch Request
        contactRequest = FetchRequest<Contact>(entity: Contact.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)], predicate: nil)
      
    }
    var body: some View{
        Text("moin")
    }
    
    func getContacts()->FetchedResults<Contact>{
    
        return self.contacts
    }
}
