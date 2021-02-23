//
//  ContactView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//
import CodeScanner
import CoreData
import SwiftUI
import KeychainSwift
struct ContactView: View {
    @State private var showAddContact = false
    @State private var showingAlert = false
    //Get Database
    @Environment(\.managedObjectContext) private var viewContext

    //inizialising a Fetch request
    var contactRequest : FetchRequest<Contact>
    //fetching results
    var contacts : FetchedResults<Contact>{ contactRequest.wrappedValue}
    init() {
        //making fetch Reques
        contactRequest = FetchRequest<Contact>(entity: Contact.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)], predicate: nil)
    }
    
    var keychain = KeychainSwift()
    var con = MqttConnection()
    var encryption = Encription()
    
    var body: some View {
        ZStack{
            NavigationView {
                //Listing Contacts
                List{
                    ForEach(contacts){ Contact in
                        NavigationLink( destination: ChatView(currentContact: Contact)){
                                ContactRow(contact: Contact)
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
                .navigationBarItems(trailing:Button(action: {
                    if(keychain.get("Name") != nil){
                        showAddContact = true
                    }else{
                        showingAlert = true
                    }
                    
                }, label: {
                        Image(systemName:"person.fill.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .padding()
                    }))
                    .sheet(isPresented: $showAddContact) {
                        CodeScannerView(codeTypes: [.qr], simulatedData: "" ,completion: self.handleScan)
                    }
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Missing Name"), message: Text("Please enter your Name First"), dismissButton: .default(Text("Ok")))
                    }
                
            }
            
        }
        .onAppear(){
            print ("ContactView appeared")
            if (keychain.get("MyId") == nil){
                keychain.set(UUID().uuidString, forKey: "MyId")
            }
            encryption.saveEncriptionKeys()
            con.StartMQTT(contacts: contacts, viewContext: viewContext)
        }
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>){
            self.showAddContact = false
            switch result {
            case .success(let code):
                
                let scanInParts = code.components(separatedBy: "/!#")
                
                saveContact(key: Data(base64Encoded: scanInParts[2])!,id: scanInParts[0], name: scanInParts[1] )
                con.StartMQTT(contacts: contacts, viewContext: viewContext)
            case .failure(let error):
                print("Scanning failed: \(error)")
        }
    }
    
    func saveContact(key: Data, id: String, name: String){
        let newContact = Contact(context: viewContext)
        newContact.name = name
        newContact.key = key
        newContact.id = UUID()
        newContact.foriginId = id
        newContact.date = Date()
        newContact.unread = false
        print("id: \(id)")
        //saving the contact
        do {
            try viewContext.save()
            print("Contact saved.")
            con.addNewContact(contact: newContact)
        } catch {
            print("Error saving contact: \(error.localizedDescription)")
        }
    }
    
}
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

