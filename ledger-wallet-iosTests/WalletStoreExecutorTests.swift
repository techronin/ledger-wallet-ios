//
//  WalletStoreExecutorTests.swift
//  ledger-wallet-ios
//
//  Created by Nicolas Bigot on 10/12/2015.
//  Copyright © 2015 Ledger. All rights reserved.
//

import Foundation
import XCTest
@testable import ledger_wallet_ios

class WalletStoreExecutorTests: XCTestCase {
    
    private var store: SQLiteStore!
    
    override func setUp() {
        super.setUp()
        store = WalletStoreManager.managedStoreAtURL(nil, uniqueIdentifier: "unique_identifier")
    }
    
    override func tearDown() {
        super.tearDown()
        store = nil
    }
    
    // MARK: Accounts tests
    
    func testAllAccountsNoResults() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.allAccounts(context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.count, 0, "There should be no results")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAllAccountsWithResults() {
        let account1 = WalletAccountModel(index: 0, extendedPublicKey: "xpub1", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let account2 = WalletAccountModel(index: 1, extendedPublicKey: "xpub2", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account1, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAccount(account2, context: context), "It should be possible to add an account")
            let results = WalletStoreExecutor.allAccounts(context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.count, 2, "There should be two accounts")
            XCTAssertEqual(results![0].index, 0, "Account index should match")
            XCTAssertEqual(results![1].index, 1, "Account index should match")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAccountAtRealIndex() {
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            let results = WalletStoreExecutor.accountAtIndex(0, context: context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.index, account.index, "Accounts indexes should match")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAccountAtFakeIndex() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.accountAtIndex(1, context: context)
            XCTAssertNil(results, "Results should be nil")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddSingleAccount() {
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddAccountTwice() {
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertFalse(WalletStoreExecutor.addAccount(account, context: context), "It should not be possible to add a second same account")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    // MARK: Addresses tests
    
    func testAddressesNoResults() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.addressesAtPaths([], context: context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.count, 0, "There should be no results")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddressesAtUnknownPaths() {
        let paths = Array(0..<10).map({ return WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: $0) })
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.addressesAtPaths(paths, context: context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.count, 0, "There should be no results")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddressesAtKnownPaths() {
        let paths = Array(0..<10).map({ return WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: $0) })
        let addresses = paths.map({ return WalletAddressModel(addressPath: $0, address: NSUUID().UUIDString)})
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddresses(addresses, context: context), "It should be possible to add addresses")
            let results = WalletStoreExecutor.addressesAtPaths(paths, context: context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.count, paths.count, "There should be some results")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddressAtUnknownPath() {
        let path = WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: 0)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.addressAtPath(path, context: context)
            XCTAssertNil(results, "Results should be nil")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddressAtKnownPath() {
        let path = WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: 0)
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let address = WalletAddressModel(addressPath: path, address: NSUUID().UUIDString)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddress(address, context: context), "It should be possible to add an address")
            let results = WalletStoreExecutor.addressAtPath(path, context: context)
            XCTAssertNotNil(results, "Results should not be nil")
            XCTAssertEqual(results!.addressPath, address.addressPath, "Address paths should match")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddressWithUnknownAddress() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.addressWithAddress("an address", context: context)
            XCTAssertNil(results, "Results should be nil")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddressWithKnownAddress() {
        let addressString = NSUUID().UUIDString
        let path = WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: 0)
        let address = WalletAddressModel(addressPath: path, address: addressString)
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddress(address, context: context), "It should be possible to add an address")
            let results = WalletStoreExecutor.addressWithAddress(addressString, context: context)
            XCTAssertNotNil(results, "Results should no be nil")
            XCTAssertEqual(results!.address, addressString, "Addresses should match")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddNoAddresses() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAddresses([], context: context), "It should be possible to add an address")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddDifferentAddresses() {
        let paths = Array(0..<10).map({ return WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: $0) })
        let addresses = paths.map({ return WalletAddressModel(addressPath: $0, address: NSUUID().UUIDString)})
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddresses(addresses, context: context), "It should be possible to add addresses")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddSameAddresses() {
        let paths = Array(0..<10).map({ return WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: $0) })
        let addresses = paths.map({ return WalletAddressModel(addressPath: $0, address: NSUUID().UUIDString)})
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddresses(addresses, context: context), "It should be possible to add addresses")
            XCTAssertTrue(WalletStoreExecutor.addAddresses(addresses, context: context), "It should be possible to add addresses")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddOneAddress() {
        let addressString = NSUUID().UUIDString
        let path = WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: 0)
        let address = WalletAddressModel(addressPath: path, address: addressString)
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddress(address, context: context), "It should be possible to add an address")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testAddTwiceAddress() {
        let addressString = NSUUID().UUIDString
        let path = WalletAddressPath(accountIndex: 0, chainIndex: 0, keyIndex: 0)
        let address = WalletAddressModel(addressPath: path, address: addressString)
        let account = WalletAccountModel(index: 0, extendedPublicKey: "xpub", nextInternalIndex: 0, nextExternalIndex: 0, name: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.addAccount(account, context: context), "It should be possible to add an account")
            XCTAssertTrue(WalletStoreExecutor.addAddress(address, context: context), "It should be possible to add an address")
            XCTAssertTrue(WalletStoreExecutor.addAddress(address, context: context), "It should be possible to add an address")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    // MARK: Schema tests
    
    func testSchemaVersionNil() {
        let store = SQLiteStore(URL: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.open()
        store.performBlock() { context in
            XCTAssertNil(WalletStoreExecutor.schemaVersion(context), "There should be no version")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testSchemaVersion() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let results = WalletStoreExecutor.schemaVersion(context)
            XCTAssertNotNil(results, "There should be a version")
            XCTAssertEqual(results!, WalletStoreSchemas.currentVersion)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testUpdateNoMetadata() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.updateMetadata([:], context: context), "It should be possible to update metadata")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testUpdateMetadata() {
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.performBlock() { context in
            let version = WalletStoreExecutor.schemaVersion(context)
            XCTAssertNotNil(version, "Version should not be nil")
            XCTAssertTrue(WalletStoreExecutor.updateMetadata([WalletMetadataTableEntity.schemaVersionKey: 42], context: context), "It should be possible to update metadata")
            let versionAfter = WalletStoreExecutor.schemaVersion(context)
            XCTAssertNotNil(version, "After version should not be nil")
            XCTAssertEqual(versionAfter!, 42, "Versions should be equal")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testExecutePragmaCommand() {
        let store = SQLiteStore(URL: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.open()
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.executePragmaCommand("PRAGMA foreign_keys = ON", context: context), "It should be possible to execute command")
            XCTAssertFalse(WalletStoreExecutor.executePragmaCommand("PRAGMA", context: context), "It should not be possible to execute command")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testExecuteTableCreation() {
        let store = SQLiteStore(URL: nil)
        let expectation = expectationWithDescription("Waiting for executor to perform")
        store.open()
        store.performBlock() { context in
            XCTAssertTrue(WalletStoreExecutor.executeTableCreation("CREATE TABLE test (email TEXT)", context: context), "It should be possible to create a table")
            XCTAssertFalse(WalletStoreExecutor.executeTableCreation("CREATE TABLE test (email TEXT)", context: context), "It should not be possible to create a table")
            XCTAssertNotNil(context.executeQuery("SELECT * FROM test", withArgumentsInArray: nil), "It should be possible to query table")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
}