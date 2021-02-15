//
//  MyIDView.swift
//  ChatAppV1
//
//  Created by Robin Gerstlauer on 08.12.20.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
let info = MyInfo()
let context = CIContext()
let filter = CIFilter.qrCodeGenerator()
//Function to Scale up a Generated code
func generateQRCode(from string: String) -> UIImage {
    print (string)
    let data = string.data(using: String.Encoding.ascii)
   
    filter.setValue(data, forKey: "inputMessage")
    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
var data = "\(info.getContents(fileName: "MyInfo"))/!#"
var data2 = Encription().getPublicKey().base64EncodedString()
var string = "\(data)\(data2)"

struct MyIdView: View {
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("My ID")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            Image(uiImage: generateQRCode(from: string))
                .interpolation(.none)
                
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Spacer()
        
        }
    }
}

struct MyIDView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdView()
            .preferredColorScheme(.light)
    }
}
