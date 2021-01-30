//
//  MessageRow.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI

struct MessageRow: View {
    var message : Message
    //Making the message row
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            //alignig it right if it is sent by you
            if message.isCurrentUser {
                        Spacer()
            }
            Text("\(message.message!)")
            .padding(10)
            .foregroundColor(message.isCurrentUser ? Color.white : Color.black)
            //set color if it is sent from you to blue
            .background(message.isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
        }
    }
}
