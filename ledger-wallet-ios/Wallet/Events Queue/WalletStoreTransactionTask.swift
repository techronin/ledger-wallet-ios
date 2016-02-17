//
//  WalletStoreTransactionTask.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 12/01/2016.
//  Copyright © 2016 Ledger. All rights reserved.
//

import Foundation

struct WalletStoreTransactionTask: WalletTaskType {
    
    let identifier = "WalletStoreTransactionTask"
    private let transaction: WalletTransactionContainer
    private weak var transactionsStream: WalletTransactionsStream?
    
    func process(completionQueue: NSOperationQueue, completion: () -> Void) {
        guard let transactionsStream = transactionsStream else {
            completion()
            return
        }
        transactionsStream.processTransaction(transaction, completionQueue: completionQueue, completion: completion)
    }
    
    // MARK: Initialization
    
    init(transaction: WalletTransactionContainer, transactionsStream: WalletTransactionsStream) {
        self.transaction = transaction
        self.transactionsStream = transactionsStream
    }
    
}