//
//  WalletTransactionsStreamContext.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 16/12/2015.
//  Copyright © 2015 Ledger. All rights reserved.
//

import Foundation

final class WalletTransactionsStreamContext {
    
    let transaction: WalletRemoteTransaction
    var inputs: [WalletRemoteTransactionRegularInput: WalletAddressModel] = [:]
    var outputs: [WalletRemoteTransactionOutput: WalletAddressModel] = [:]
    
    init(transaction: WalletRemoteTransaction) {
        self.transaction = transaction
    }

}