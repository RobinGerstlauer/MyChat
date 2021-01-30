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
let mqttConfig = MQTTConfig(clientId: DeviceId, host: "194.36.145.14", port: 1883, keepAlive: 60)
var mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: false)




struct MqttConnection : View{
    @Environment(\.managedObjectContext) private var viewContext

   
    
    
    var body: some View {
        Text("moin")
    }
    
    
    
    func saveMessage(){
        do {
            try viewContext.save()
    
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func StartMQTT(contacts: FetchedResults<Contact>) -> Void {
        
        print("\(UIDevice.current.identifierForVendor!.uuidString)")
        
        moscapsule_init()
     
    // Receive published message here
        mqttConfig.onMessageCallback = { mqttMessage in
            let con = MqttConnection()
            let receivedMessage = mqttMessage.payloadString!
            let receivedTopic = mqttMessage.topic
            var receivedContact : Contact = Contact()
            for contact in contacts{
                if (contact.foriginId == receivedTopic){
                receivedContact = contact
                }
            }
            
            print("recievedContact : \(receivedContact.name ?? "error")")
            print ("recievedMessage: \(receivedMessage)")
            print ("recievedTopic: \(receivedTopic)")
            let newMessage = Message(context: viewContext)
            newMessage.message = receivedMessage
            newMessage.id = UUID()
            newMessage.date=Date()
            newMessage.contacts = receivedContact
            newMessage.isCurrentUser=false
            receivedContact.date = Date()
            con.saveMessage()
            
        }
     
    // Connecting to Mqtt server
        mqttClient = MQTT.newConnection(mqttConfig, connectImmediately: true)
        subscribeToTopic()
    }
    //Subscribing to Topics
    func subscribeToTopic() -> Void {
        let topic = "\(DeviceId)"
            
            mqttClient.subscribe(topic, qos: 2)
        
    }
    // Check MQTT connection status
    func CheckMQTTConnectionStatus() -> Bool {
        print("MQTT Connection Status  : \(String(describing: mqttClient.isConnected))")
        return (mqttClient.isConnected)
     
    }
    func PublishMessage(message: String ,contactId: String){
        mqttClient.publish(string: "\(message)" , topic: "\(DeviceId)" , qos: 2, retain: false)
        //mqttClient.publish(string: "\(message)" , topic: "\(contactId)/\(myID)" , qos: 2, retain: false)
    }
    
    func getContactbyForiginId(name : String){
        
    }
}

 
