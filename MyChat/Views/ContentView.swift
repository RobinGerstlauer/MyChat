//
//  ContentView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @State var showingAlert = false
    
    var body: some View {
        //Making a tab view and putting the corresponding views in it
        
        TabView {
                ContactView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                MyIdView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My ID")
                }
            }
        
        
    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
