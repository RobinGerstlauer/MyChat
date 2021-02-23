//
//  MqttConnection.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 20.01.21.
//

import Foundation
import Moscapsule
import CoreData
import SwiftUI
import AVFoundation

let host = "keybit.ch"

let DeviceId : String = "\(UIDevice.current.identifierForVendor!.uuidString)"
let mqttConfig = MQTTConfig(clientId: DeviceId, host: host , port: 1883, keepAlive: 60)
var mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: false)



class MqttConnection{
    @Environment(\.managedObjectContext) private var ViewContext
    var encryption = Encription()
    func StartMQTT(contacts: FetchedResults<Contact>,viewContext: NSManagedObjectContext) -> Void {
    
    moscapsule_init()
    

    
    // Receive published message here
    
        mqttConfig.onMessageCallback = { mqttMessage in
            
            let receivedTopic = mqttMessage.topic
            let topicInParts = receivedTopic.components(separatedBy: "/")
            
            print ("Topic part 0 \(topicInParts[0])")
            print ("Topic part 1 \(topicInParts[1])")
            if(topicInParts[1] == "newContact"){
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                let recievedMessage = mqttMessage.payloadString!
                let messageInParts = recievedMessage.components(separatedBy: "/!#")
                let newContact = Contact(context: viewContext)
                newContact.name = messageInParts[1]
                newContact.key = Data(base64Encoded: messageInParts[2])
                newContact.id = UUID()
                newContact.foriginId = messageInParts[0]
                newContact.date = Date()
                newContact.unread = false
                print("id: \(messageInParts[0])")
                //saving the contact
                do{
                    try viewContext.save()
                    print("Contact saved.")
                } catch {
                    print("Error saving contact: \(error.localizedDescription)")
                }
            }else{
                let receivedMessageData = mqttMessage.payload!
                print ("recievedMessage: \(receivedMessageData)")
                for contact in contacts{
                    if (contact.foriginId == topicInParts[1]){
                        print("recievedContact : \(contact.name ?? "error")")
                        let receivedMessage = self.encryption.decryptMessage(contact: contact, encryptedMessage: receivedMessageData)
                        let newMessage = Message(context: viewContext)
                        newMessage.message = "\(receivedMessage)"
                        newMessage.id = UUID()
                        newMessage.date=Date()
                        newMessage.contacts = contact
                        newMessage.isCurrentUser = false
                    
                        contact.unread = true
                        contact.date = Date()
                    
                        do {
                            try viewContext.save()
                
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
                }
            }
            
           
            
        }
        
        if !CheckMQTTConnectionStatus(){
    // Connecting to Mqtt server
            mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: true)
            subscribeToTopics()
        }
    }
    
    func subscribeToTopics(){
        
        mqttClient.subscribe("\(keychain.get("MyId")!)/#", qos: 2)
        
    }
    // Check MQTT connection status
    func CheckMQTTConnectionStatus() -> Bool {
        print("MQTT Connection Status  : \(String(describing: mqttClient.isConnected))")
        return (mqttClient.isConnected)
     
    }
    func PublishMessage(message: String ,contact: Contact){
        let encryptedMessage = encryption.encryptMessage(message: message, contact: contact)
        print (contact.foriginId!)
        mqttClient.publish(encryptedMessage , topic: "\(contact.foriginId!)/\( keychain.get("MyId")!)" , qos: 2, retain: true)
        
    }
    func addNewContact(contact: Contact){
        let data1 = "\(keychain.get("MyId")!)/!#"
        let data2 = "\(keychain.get("Name")!)/!#"
        let data3 =  encryption.getPublicKey().base64EncodedString()
        let string = "\(data1)\(data2)\(data3)"
        mqttClient.publish(string: string, topic: "\(contact.foriginId!)/newContact" , qos: 2, retain: false)
    }
    
}

 
