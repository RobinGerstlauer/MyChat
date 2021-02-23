//
//  Encryption.swift
//  MyChat
//
//  Created by Robin Gerstlauer on 10.02.21.
//
import CryptoKit
import Foundation
import KeychainSwift

class Encription {
    let keychain = KeychainSwift()
    func saveEncriptionKeys(){
        if (keychain.getData("PublicKey") == nil || keychain.getData("PrivateKey") == nil){
            let privateKey = Curve25519.KeyAgreement.PrivateKey()
            let publicKey = privateKey.publicKey
            keychain.set(privateKey.rawRepresentation,forKey: "PrivateKey")
            keychain.set(publicKey.rawRepresentation, forKey: "PublicKey")
            print ("onekeybefore: \(publicKey.rawRepresentation)")
            print ("onekeyafter: \(String(describing: keychain.getData("PublicKey")))")
        }
    }
    func encryptMessage(message:String,contact: Contact)-> Data{
        
        
        let privateKeyAsData = keychain.getData("PrivateKey")!
        let privateKey = try! Curve25519.KeyAgreement.PrivateKey.init(rawRepresentation: privateKeyAsData )
        
        let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with:Curve25519.KeyAgreement.PublicKey.init(rawRepresentation: contact.key!))
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: "7xXDJMALb36GqZ6j".data(using: .utf8)!,sharedInfo: Data(), outputByteCount: 32)
        
        let encryptedData = try! ChaChaPoly.seal(message.data(using: .utf8)!, using: symmetricKey ).combined
        return encryptedData
    }
    func decryptMessage(contact: Contact, encryptedMessage: Data)-> String{
       
        let privateKeyAsData = keychain.getData("PrivateKey")!
        let privateKey = try! Curve25519.KeyAgreement.PrivateKey.init(rawRepresentation: privateKeyAsData)
        let sharedSecret = try! privateKey.sharedSecretFromKeyAgreement(with:Curve25519.KeyAgreement.PublicKey.init(rawRepresentation: contact.key!))
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: "7xXDJMALb36GqZ6j".data(using: .utf8)!,sharedInfo: Data(), outputByteCount: 32)
        let sealedBox = try! ChaChaPoly.SealedBox(combined: encryptedMessage)
        let decryptedData = try! ChaChaPoly.open(sealedBox, using: symmetricKey)
        return String(decoding: decryptedData, as: UTF8.self)
        
    }
    func getPublicKey()->Data{
        return keychain.getData("PublicKey")!
    }
}
