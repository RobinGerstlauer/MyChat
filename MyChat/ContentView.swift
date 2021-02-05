//
//  ContentView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//
import SwiftUI
import CoreData

struct ContentView: View {

    
    
    var body: some View {
        //Making a tab view and putting the corresponding views in it
        
        TabView {
                ContactView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                MyIdView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My ID")
                }
            }.edgesIgnoringSafeArea(.all)
        .onAppear(){
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
