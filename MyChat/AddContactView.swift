//
//  AddContactView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI

struct AddContactView: View {
    //Getting Database(ManagedObjectContext)
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
  
    @State var name = ""
    @State var key = ""
    
    var body: some View {
        //making form
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Id")) {
                    TextField("Id", text: $key)
                }
                Button(action: {
                //Creating new contact
                    let newContact = Contact(context: viewContext)
                    newContact.name = self.name
                    newContact.key = "2"
                    newContact.id = UUID()
                    newContact.foriginId=self.key
                    newContact.date = Date()
                    //saving the contact
                    do {
                        try viewContext.save()
                        print("Contact saved.")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }) {
                    Text("Add Contact")
                }
            }
            .navigationTitle("Add Contact")
        }
    }
}
struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView()
    }
}
