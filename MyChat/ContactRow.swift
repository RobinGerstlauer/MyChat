//
//  ContactRow.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI
import Foundation

struct ContactRow: View {
    var Contact : Contact
    
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    init(Contact:Contact) {
        //forwarde Contact
        self.Contact=Contact
        //Set format on formatter
        dateFormatter.dateFormat = "DD.MM.YY"
        if (dateFormatter.string(from: Contact.date ?? Date()) == dateFormatter.string(from: Date())){
            dateFormatter.dateFormat = "hh:mm"
        }
    }
    var body: some View {
        //Making the Row
        VStack(alignment: .leading){
            Text("\(Contact.name!)")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            HStack(){
                Spacer()
                Text(dateFormatter.string(from: Contact.date ?? Date()))
                .font(.subheadline)
            }
        }
    }
}


