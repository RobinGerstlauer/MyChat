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
            let receivedMessageData = mqttMessage.payload!
            let receivedTopic = mqttMessage.topic
            let topicInParts = receivedTopic.components(separatedBy: "/")
            print ("recievedMessage: \(receivedMessageData)")
            print ("Topic part 0 \(topicInParts[0])")
            print ("Topic part 1 \(topicInParts[1])")
            
            
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
                    
                    contact.date = Date()
                    do {
                        try viewContext.save()
                
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
            
           
            
        }
        mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: false)
        if !CheckMQTTConnectionStatus(){
    // Connecting to Mqtt server
            mqttClient.connectTo(host: host, port: 1883, keepAlive: 60)
            subscribeToTopics()
        }
    }
    
    func subscribeToTopics(){
        
            mqttClient.subscribe("\(MyInfo().getContents(fileName: "MyInfo"))/#", qos: 2)
        
    }
    // Check MQTT connection status
    func CheckMQTTConnectionStatus() -> Bool {
        print("MQTT Connection Status  : \(String(describing: mqttClient.isConnected))")
        return (mqttClient.isConnected)
     
    }
    func PublishMessage(message: String ,contact: Contact){
        let encryptedMessage = encryption.encryptMessage(message: message, contact: contact)
        print (contact.foriginId!)
        mqttClient.publish(encryptedMessage , topic: "\(contact.foriginId!)/\(MyInfo().getContents(fileName: "MyInfo"))" , qos: 2, retain: false)
        
    }
    
}

 
