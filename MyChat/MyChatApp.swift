//
//  MyChatApp.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI



@main
struct MyChatApp: App {

    
    
    @Environment(\.managedObjectContext) private var viewContext
   
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(){
                    
                    
                    
                }
        }
        
        
    }
    
    
}


