//
//  MyIDView.swift
//  ChatAppV1
//
//  Created by Robin Gerstlauer on 08.12.20.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import KeychainSwift
let keychain = KeychainSwift()
let context = CIContext()
let filter = CIFilter.qrCodeGenerator()
//Function to Scale up a Generated code


struct MyIdView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var name = ""
    
    var body: some View {
        
        NavigationView{
        VStack{
            
            Spacer()
            if(name != ""){
                let data1 = "\(keychain.get("MyId")!)/!#"
                let data3 = Encription().getPublicKey().base64EncodedString()
                if (colorScheme == .dark){
                    Image(uiImage: generateQRCode(from: "\(data1)\(name)/!#\(data3)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .colorInvert()
                }else{
                    Image(uiImage: generateQRCode(from: "\(data1)\(name)/!#\(data3)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                }
                
            }
            Spacer()
            Section(header: Text("Name")) {
                HStack(){
                    Spacer()
                    TextField("Name", text: $name, onCommit: {
                        UIApplication.shared.endEditing()
                    })
                    Spacer()
                }
                Button(action: {
                    if(self.name != ""){
                        keychain.set(name, forKey: "Name")
                        
                    }
                }) {
                    HStack{
                        Spacer()
                        Text("save")
                        Spacer()
                    }
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
        
        }.onAppear(){
            if ( keychain.get("Name") != nil){
                name = keychain.get("Name")!
            }
        }
        .padding()
        .navigationTitle("My Information")
        }
    }
    func generateQRCode(from string: String) -> UIImage {
        
        let data = string.data(using: String.Encoding.ascii)
       
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MyIDView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdView()
            .preferredColorScheme(.light)
    }
    
}
