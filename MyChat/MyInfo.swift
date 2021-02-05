//
//  MyInfo.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 03.02.21.
//

import Foundation

struct MyInfo {
    
    func makeUUIDFile(){
       
        
        let fileName = "MyInfo"
        var documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        var fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        if !checkIfFileExists(fileName: "MyInfo.txt") {
            let contents = UUID().uuidString
            
            documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
            
            print("filepath:\(fileURL)")
            do{
                try contents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }catch let error as NSError {
                print("epic Fail: \(error)")
            }
        }
       
        
    }
    func getFileContent(fileName: String)->String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(fileName)"){
            let filePath = pathComponent.path
            do {
                // Get the contents
                let contents = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
                print("myUUID: \(contents)")
                return contents as String
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        
        print ("Error: Somthing went wrong")
        return "Error: Somthing went wrong"
    }
    
    func checkIfFileExists(fileName: String)->Bool{
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(fileName)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("File Available")
                return true
            } else {
                print("FILE PATH NOT AVAILABLE")
                return false
            }
        }
        print ("File not available")
        return false
    }
    
}