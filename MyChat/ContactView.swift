//
//  ContactView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI

struct ContactView: View {
    @State var showAddContact = false
    //Get Database
    @Environment(\.managedObjectContext) private var viewContext

    //inizialising a Fetch request
    var contactRequest : FetchRequest<Contact>
    //fetching results
    var contacts : FetchedResults<Contact>{ contactRequest.wrappedValue}
    init() {
        //making fetch Request
        contactRequest = FetchRequest<Contact>(entity: Contact.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)], predicate: nil)
    }
    

    var con = MqttConnection()
    var info = MyInfo()
    
    var body: some View {
        ZStack{
            NavigationView {
                //Listing Contacts
                List{
                    ForEach(contacts){ Contact in
                        NavigationLink( destination: ChatView(currentContact: Contact)){
                                ContactRow(Contact: Contact)
                        }
                    }
                    .onDelete { indexSet in
                            for index in indexSet {
                                viewContext.delete(contacts[index])
                            }
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Contacts")
                //Buttton to add Contacts
                .navigationBarItems(trailing:Button(action: {showAddContact = true}, label: {
                        Image(systemName:"person.fill.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 300)
                            .padding()
                    }))
                    .sheet(isPresented: $showAddContact) {
                        AddContactView()
                    }
                
            }
        }
        .onAppear(){
            print ("ContactView appeared")
           
            if !con.CheckMQTTConnectionStatus(){
                con.StartMQTT(contacts: contacts, viewContext: viewContext)
                con.subscribeToTopics()
            }
            info.makeUUIDFile()
            
        }
    }
    
}
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

