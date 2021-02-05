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
    @State var id = ""
    @State private var isShowingScanner = false
    
    var body: some View {
        //making form
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                
                Button(action: {
                    self.isShowingScanner = true
                }) {
                    HStack{
                        Spacer()
                        Text("Scan Id")
                        Image(systemName: "qrcode.viewfinder")
                        Spacer()
                    }
                }
            
                .sheet(isPresented: $isShowingScanner){
                    CodeScannerView(codeTypes: [.qr], simulatedData: "8AF7FB18-B756-4EBB-A1EB-F5233EF3DB33",completion: self.handleScan)
                    
                }
                    
                
            }
            .navigationTitle("Add Contact")
        }
        
    }
    func saveContact(){
        let newContact = Contact(context: viewContext)
        newContact.name = self.name
        newContact.key = "2"
        newContact.id = UUID()
        newContact.foriginId = UUID(uuidString: id)
        newContact.date = Date()
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
            id = code
            saveContact()
            
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
