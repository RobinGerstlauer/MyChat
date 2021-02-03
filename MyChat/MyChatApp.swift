//
//  MyChatApp.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI
import Moscapsule


//Standart sachen ****************************************************************************
@main
struct MyChatApp: App {

    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    init() {
        
    }
    
    
    let RandomId : String = "\(UIDevice.current.identifierForVendor!.uuidString)"
    // create MQTT Client Configuration with mandatory prameters
    
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

//******************************************************************************************

