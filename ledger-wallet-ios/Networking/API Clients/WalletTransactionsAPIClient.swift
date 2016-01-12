//
//  WalletTransactionsAPIClient.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 03/12/2015.
//  Copyright © 2015 Ledger. All rights reserved.
//

import Foundation

final class WalletTransactionsAPIClient: APIClientType {
    
    let httpClient: HTTPClient
    private let logger = Logger.sharedInstance(name: "WalletTransactionsAPIClient")
    private let workingQueue = NSOperationQueue(name: dispatchQueueNameForIdentifier("WalletTransactionsAPIClient"), maxConcurrentOperationCount: NSOperationQueueDefaultMaxConcurrentOperationCount)
    private let servicesProvider: ServicesProviderType
    private let delegateQueue: NSOperationQueue
    
    // MARK: Transactions mangement
    
    func fetchTransactionsForAddresses(addresses: [String], completion: ([WalletTransactionContainer]?) -> Void) {
        guard addresses.count > 0 else {
            delegateQueue.addOperationWithBlock() { [weak self] in
                guard self != nil else { return }
                completion([])
            }
            return
        }
        
        let URL = servicesProvider.walletTransactionsURLForAddresses(addresses)
        httpClient.get(URL) { [weak self] data, request, response, error in
            guard let strongSelf = self else { return }
            
            guard error == nil, let data = data, JSON = JSON.JSONObjectFromData(data) as? [[String: AnyObject]] else {
                strongSelf.logger.error("Unable to fetch or parse transactions JSON")
                strongSelf.delegateQueue.addOperationWithBlock() { completion(nil) }
                return
            }
            
            let transactions = WalletTransactionContainer.collectionFromJSONArray(JSON)
            strongSelf.delegateQueue.addOperationWithBlock() { completion(transactions) }
        }
    }
    
    // MARK: Initialization
    
    init(servicesProvider: ServicesProviderType, delegateQueue: NSOperationQueue) {
        self.servicesProvider = servicesProvider
        self.delegateQueue = delegateQueue
        self.httpClient = HTTPClient(delegateQueue: workingQueue)
        self.httpClient.additionalHeaders = servicesProvider.httpHeaders
    }
    
}