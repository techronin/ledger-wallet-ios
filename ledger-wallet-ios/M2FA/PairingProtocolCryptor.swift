//
//  PairingProtocolCryptor.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 06/02/2015.
//  Copyright (c) 2015 Ledger. All rights reserved.
//

import Foundation

final class PairingProtocolCryptor {
    
    private let diffieHellmanBytesLength = 32
    private let sessionKeyBytesLength = 16
    private let pairingKeyBytesLength = 16
    private let nonceBytesLength = 8
    private let challengeBytesLength = 4
    private let attestationKeyIDsLength = 8
    
    // MARK: Session key
    
    func sessionKeyForKeys(internalKey internalKey: BTCKey, externalKey: BTCKey) -> NSData {
        // compute shared secret
        let secretKey = externalKey.diffieHellmanWithPrivateKey(internalKey).compressedPublicKey
        let cuttedSecretKey = secretKey.subdataWithRange(NSMakeRange(1, secretKey.length - 1))
        
        // compute secret key
        let sessionFirstPart = cuttedSecretKey.subdataWithRange(NSMakeRange(0, sessionKeyBytesLength))
        let sessionSecondPart = cuttedSecretKey.subdataWithRange(NSMakeRange(sessionKeyBytesLength, sessionKeyBytesLength))
        let sessionKey = sessionFirstPart.XORWithData(sessionSecondPart)!
        return sessionKey
    }
    
    func decryptData(data: NSData, sessionKey: NSData) -> NSData {
        // decrypt data
        let (key1, key2) = sessionKey.splitData!
        return data.tripeDESCBCWithKeys(key1: key1, key2: key2, key3: key1, encrypt: false)!
    }
    
    func encryptData(data: NSData, sessionKey: NSData) -> NSData {
        // encrypt data
        let (key1, key2) = sessionKey.splitData!
        return data.tripeDESCBCWithKeys(key1: key1, key2: key2, key3: key1, encrypt: true)!
    }
    
    // MARK: Challenge data
    
    func nonceFromBlob(data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(0, nonceBytesLength))
    }
    
    func encryptedDataFromBlob(data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(nonceBytesLength, data.length - nonceBytesLength))
    }
    
    func challengeDataFromDecryptedData(data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(0, challengeBytesLength))
    }
    
    func pairingKeyFromDecryptedData(data: NSData) -> NSData {
        return data.subdataWithRange(NSMakeRange(challengeBytesLength, pairingKeyBytesLength))
    }
    
    func encryptedChallengeResponseDataFromChallengeString(challenge: String, nonce: NSData, sessionKey: NSData) -> NSData {
        // create challenge data from response
        let decryptedData = NSMutableData()
        let challengeData = challengeDataFromChallengeString(challenge)
        
        // add nonce
        decryptedData.appendData(nonce)
        
        // add challenge data
        decryptedData.appendData(challengeData)
        
        // add 0x00 * 4
        decryptedData.appendData(BTCDataFromHex("00000000"))
        
        // encrypt data
        let encryptedData = encryptData(decryptedData, sessionKey: sessionKey)
        
        return encryptedData
    }
    
    func challengeStringFromChallengeData(data: NSData) -> String {
        let dataCopy = data.mutableCopy() as! NSMutableData
        var pointer = UnsafeMutablePointer<UInt8>(dataCopy.mutableBytes)
        for _ in 0..<data.length {
            pointer.memory = pointer.memory + 0x30 // add '0'
            pointer = pointer.successor()
        }
        return NSString(data: dataCopy, encoding: NSASCIIStringEncoding)! as String
    }
    
    func challengeDataIsValid(data: NSData) -> Bool {
        var pointer = UnsafePointer<UInt8>(data.bytes)
        for _ in 0..<data.length {
            if pointer.memory > 0x4A { // upper limit (without +0x30)
                return false
            }
            pointer = pointer.successor()
        }
        return true
    }
    
    func challengeDataFromChallengeString(challenge: String) -> NSData {
        let string = challenge as NSString
        var computedString = ""
        for i in 0..<string.length {
            computedString = computedString + "0" + string.substringWithRange(NSMakeRange(i, 1))
        }
        return BTCDataFromHex(computedString)
    }
    
    func attestationKeyIDsWithData(data: NSData) -> (batchID: UInt32, derivationID: UInt32)? {
        guard data.length == attestationKeyIDsLength else {
            return nil
        }
        let (batchIDData, derivationIDData) = data.splitData!
        var values: (UInt32, UInt32) = (0, 0)
        batchIDData.getBytes(&values.0, length: sizeof(UInt32))
        derivationIDData.getBytes(&values.1, length: sizeof(UInt32))
        values.0 = CFSwapInt32BigToHost(values.0)
        values.1 = CFSwapInt32BigToHost(values.1)
        return values
    }

}