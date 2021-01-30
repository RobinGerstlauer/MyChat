//
//  ChatView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI
import CoreData
import Moscapsule

struct ChatView: View {
    //Atribut declaration
    var currentContact : Contact
    
    var con = MqttConnection()
    @State private var text = ""
    
    //Get database
    @Environment(\.managedObjectContext) private var viewContext
    
    var messageRequest: FetchRequest<Message>
    //fetching Data
    var messages : FetchedResults<Message>{messageRequest.wrappedValue}
 
    init(currentContact: Contact) {
        //Forwarding CurrentContact
        self.currentContact = currentContact
        //Creating fetch statement
        self.messageRequest = FetchRequest<Message>(
            entity: Message.entity(),
            sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)],
            predicate: NSPredicate(format: "contacts == %@", currentContact)
        )
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
       
    }
    
    //Commiting a Message
    func commitMessage(){
        if (text != ""){
            //creating new Message
            let newMessage = Message(context: viewContext)
            newMessage.message = self.text
            newMessage.id = UUID()
            newMessage.date=Date()
            newMessage.contacts=currentContact
            newMessage.isCurrentUser=true
            currentContact.date = Date()
            //Try to save the Messages
            con.PublishMessage(message: text, contactId: currentContact.foriginId!)
            do {
                try viewContext.save()
                print("Message saved.")
                text=""
        
            } catch {
                print(error.localizedDescription)
            }
        }
    }
  
    
    var body: some View {
        VStack{
            //Listing all Messages
            List(messages) { Message in
                MessageRow(message:Message)
                    .scaleEffect(x: 1, y: -1, anchor: .center)
            }
            .scaleEffect(x: 1, y: -1, anchor: .center)
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //Setting Title
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("\(currentContact.name!)").font(.headline)
                    }
                }
            }
            //Text input and send button
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                TextField( "Message",
                        text: $text,
                        onEditingChanged: { _ in print("") },
                        onCommit: {commitMessage()}
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                Button(action: {
                    commitMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                }
                .padding()
            }
        }
        
    }
    
}


