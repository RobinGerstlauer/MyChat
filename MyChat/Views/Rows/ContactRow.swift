//
//  ContactRow.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 09.01.21.
//

import SwiftUI
import Foundation

struct ContactRow: View {
    var contact : Contact

    // Create Date Formatter
    let dateFormatter = DateFormatter()
    init(contact:Contact) {
        //forwarde Contact
        self.contact=contact
        //Set format on formatter
        dateFormatter.dateFormat = "dd.MM.YY"
        if (dateFormatter.string(from: contact.date ?? Date()) == dateFormatter.string(from: Date())){
            dateFormatter.dateFormat = "hh:mm"
        }
    }
    var body: some View {
        //Making the Row
        
            VStack(alignment: .leading){
                Text("\(contact.name!)")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                HStack(){
                    
                    Text(dateFormatter.string(from: contact.date ?? Date()))
                            .font(.subheadline)
                        .padding(.top, 1.0)
                        
                    Spacer()
                            
                }
                
                
                
                
            }
            if contact.unread{
                Image(systemName:"circle.fill")
                
            }
        
        
    }
}
struct ContactRow_Previews: PreviewProvider {
    var contact = Contact()
    
    static var previews: some View {
        ContactView()
            .preferredColorScheme(.dark)
    }
}


