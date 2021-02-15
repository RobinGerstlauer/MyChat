//
//  AddContactView.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI
import CodeScanner

struct AddContactView: View {
    //Getting Database(ManagedObjectContext)
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
  
    @State var name = ""
    
    @State private var isShowingScanner = false
    
    var body: some View {
        //making form
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                
                Button(action: {
                    if(self.name != ""){
                        self.isShowingScanner = true
                    }
                }) {
                    HStack{
                        Spacer()
                        Text("Scan Id")
                        Image(systemName: "qrcode.viewfinder")
                        Spacer()
                    }
                }
            
                .sheet(isPresented: $isShowingScanner){
                    CodeScannerView(codeTypes: [.qr], simulatedData: "528EFDB1-E9B6-469E-9CDC-2F4BB0944E8C/!#DyYunJPQktcVQqFzbyOy/yuayQY3Rso2L0d4Rdy8+CI=",completion: self.handleScan)
                    
                }
                    
                
            }
            .navigationTitle("Add Contact")
        }
        
    }
    func saveContact(key: Data, id: String){
        let newContact = Contact(context: viewContext)
        newContact.name = self.name
        newContact.key = key
        newContact.id = UUID()
        newContact.foriginId = id
        newContact.date = Date()
        print("id: \(id)")
        //saving the contact
        do {
            try viewContext.save()
            print("Contact saved.")
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving contact: \(error.localizedDescription)")
        }
    }
func handleScan(result: Result<String,CodeScannerView.ScanError>){
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            
            let scanInParts = code.components(separatedBy: "/!#")
            
            saveContact(key: Data(base64Encoded: scanInParts[1])!,id: scanInParts[0])
            
        case .failure(let error):
            print("Scanning failed: \(error)")
        }
    }
}
struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView()
    }
}
