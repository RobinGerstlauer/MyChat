//
//  MyIDView.swift
//  ChatAppV1
//
//  Created by Robin Gerstlauer on 08.12.20.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()
//Function to Scale up a Generated code
func generateQRCode(from string: String) -> UIImage {
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")
    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}

struct MyIdView: View {
    var id : String
    
    var body: some View {
        VStack{
            Spacer()
            Text("My ID")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            Image(uiImage: generateQRCode(from: "In here will be your PGP key"))
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
        MyIdView(id: UUID().uuidString)
            .preferredColorScheme(.light)
    }
}
