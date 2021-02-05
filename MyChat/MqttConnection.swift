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


let DeviceId : String = "\(UIDevice.current.identifierForVendor!.uuidString)"
let mqttConfig = MQTTConfig(clientId: DeviceId, host: "mqtt.keybit.ch", port: 8883, keepAlive: 60)


//let bundlePath = Bundle(for: NSClassFromString("cert.bundle")!)



var mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: false)
class MqttConnection{
   
    @Environment(\.managedObjectContext) private var ViewContext
    
    
    func StartMQTT(contacts: FetchedResults<Contact>,viewContext: NSManagedObjectContext) -> Void {
        moscapsule_init()
        
        
        let bundlePath = Bundle(for: NSClassFromString("cert.bundle")!)
        //let bundlePath = Bundle(for: type(of: self)).bundlePath.appending("cert.Bundle")
        //let certFile = bundlePath.appending("mosquitto.org.crt")
        
        mqttConfig.mqttServerCert = MQTTServerCert(cafile: certFile, capath: nil)

        
    // Receive published message here
        
        mqttConfig.onMessageCallback = { mqttMessage in
            let receivedMessage = mqttMessage.payloadString!
            let receivedTopic = mqttMessage.topic
            let topicInParts = receivedTopic.components(separatedBy: "/")
            print ("recievedMessage: \(receivedMessage)")
            print ("recievedTopic: \(receivedTopic)")
            print ("Topic part 0 \(topicInParts[0])")
            print ("Topic part 1 \(topicInParts[1])")
            for contact in contacts{
                if (contact.foriginId?.uuidString == topicInParts[1]){
                    print("recievedContact : \(contact.name ?? "error")")
                    
                    let newMessage = Message(context: viewContext)
                    newMessage.message = receivedMessage
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
     
    // Connecting to Mqtt server
        mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: true)
       
    }
    
    func subscribeToTopics(){
        
            mqttClient.subscribe("\(MyInfo().getFileContent(fileName: "MyInfo.txt"))/#", qos: 2)
        
    }
    // Check MQTT connection status
    func CheckMQTTConnectionStatus() -> Bool {
        print("MQTT Connection Status  : \(String(describing: mqttClient.isConnected))")
        return (mqttClient.isConnected)
     
    }
    func PublishMessage(message: String ,contactId: String){
        mqttClient.publish(string: "\(message)" , topic: "\(contactId)/\(MyInfo().getFileContent(fileName: "MyInfo.txt"))" , qos: 2, retain: false)
        
    }
    
    func getContactbyForiginId(name : String){
        
    }
}

 
