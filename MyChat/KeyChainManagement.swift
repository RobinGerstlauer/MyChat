//
//  KeyChainManagement.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 13.02.21.
//

import Foundation
import KeychainSwift

class KeyChainManagement{
    let keychain = KeychainSwift()
    
    func save(data: Data , name: String){
        keychain.set(data, forkey)
    }
    
    
}
