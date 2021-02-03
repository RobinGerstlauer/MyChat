//
//  ContentView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//
import SwiftUI
import CoreData

struct ContentView: View {

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getMyUUID()->String{
        // Set the file path
        let path = getDocumentsDirectory().appendingPathComponent("MyUUID.txt")
        var contents = String()
        do {
            // Get the contents
            contents = try String(contentsOfFile: path.relativeString, encoding: String.Encoding.utf8)
            print(contents)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        return contents
    }
    
    
    init() {
        let filename = getDocumentsDirectory().appendingPathComponent("MyUUID.txt")
        //let fileManager = FileManager.default
        // Check if file exists, given its path

        //if fileManager.fileExists(atPath: filename.absoluteString) {
        
        //}else{
            let str = UUID().uuidString
            do {
                try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print ("Fehler beim erstellen des Files")
            }
        //}
    }
    
    var body: some View {
        //Making a tab view and putting the corresponding views in it
        TabView {
                ContactView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                MyIdView(id: getMyUUID())
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My ID")
                }
            }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
