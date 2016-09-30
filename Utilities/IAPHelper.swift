//
//  IAPHelper.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import StoreKit
import MBProgressHUD

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper : NSObject  {
    
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    static let IAPHelperPurchaseReceiptInvalidNotificaton = "IAPInvalidReceipt"
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        print("Loaded list of products...")
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver, AppStoreReceiptValidator {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        validateReceipt(forProductID: transaction.payment.productIdentifier) { success in
            DispatchQueue.main.async { [unowned self] in
                if success {
                    self.deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
                } else {
                    print("Failed to verify receipt")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelper.IAPHelperPurchaseReceiptInvalidNotificaton), object: transaction.payment.productIdentifier)
                }
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        
        validateReceipt(forProductID: productIdentifier) { success in
            DispatchQueue.main.async { [unowned self] in
                if success {
                    self.deliverPurchaseNotificationFor(identifier: productIdentifier)
                } else {
                    print("Failed to verify receipt")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelper.IAPHelperPurchaseReceiptInvalidNotificaton), object: productIdentifier)
                }
            }
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
}


/*/// Notification that is generated when a product is purchased.
public let IAPHelperProductPurchasedNotification = "IAPHelperProductPurchasedNotification"

/// Notification that is generated when the receipt is not valid
public let IAPHelperReceiptInvalidNotification = "IAPHelperReceiptInvalidNotification"

/// Product identifiers are unique strings registered on the app store.
public typealias ProductIdentifier = String

/// Completion handler called when products are fetched.
public typealias RequestProductsCompletionHandler = (_ success: Bool, _ products: [SKProduct]) -> ()


/// A Helper class for In-App-Purchases, it can fetch products, tell you if a product has been purchased,
/// purchase products, and restore purchases.  Uses NSUserDefaults to cache if a product has been purchased.
open class IAPHelper : NSObject  {
    
    /// MARK: - Private Properties
    
    // Used to keep track of the possible products and which ones have been purchased.
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    
    // Used by SKProductsRequestDelegate
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var completionHandler: RequestProductsCompletionHandler?
    
    /// MARK: - User facing API
    
    /// Initialize the helper.  Pass in the set of ProductIdentifiers supported by the app.
    public init(productIdentifiers: Set<ProductIdentifier>) {
        self.productIdentifiers = productIdentifiers
        for productIdentifier in productIdentifiers {
            if UserDefaults.keyAlreadyExists(productIdentifier) {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            }
            else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    /// Gets the list of SKProducts from the Apple server calls the handler with the list of products.
    open func requestProductsWithCompletionHandler(_ handler: @escaping RequestProductsCompletionHandler) {
        completionHandler = handler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    /// Initiates purchase of a product.
    open func purchaseProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    /// Given the product identifier, returns true if that product has been purchased.
    open func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    /// If the state of whether purchases have been made is lost  (e.g. the
    /// user deletes and reinstalls the app) this will recover the purchases.
    open func restoreCompletedTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    open class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    deinit {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().remove(self)
        }
    }
}

// This extension is used to get a list of products, their titles, descriptions,
// and prices from the Apple server.

extension IAPHelper: SKProductsRequestDelegate, SKRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        completionHandler?(true, products)
        clearRequest()
        
        // debug printing
        for p in products {
            FTLogging().FTLog("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error)")
        clearRequest()
    }
    
    fileprivate func clearRequest() {
        productsRequest = nil
        completionHandler = nil
    }
}

extension IAPHelper: SKPaymentTransactionObserver, AppStoreReceiptValidator {
    /// This is a function called by the payment queue, not to be called directly.
    /// For each transaction act accordingly, save in the purchased cache, issue notifications,
    /// mark the transaction as complete.
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                completeTransaction(transaction)
                break
            case .failed:
                failedTransaction(transaction)
                break
            case .restored:
                restoreTransaction(transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    func completeTransaction(_ transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.original!.payment.productIdentifier
        print("completeTransaction...")
        validateReceipt(forProductID: productIdentifier) { success in
            DispatchQueue.main.async { [unowned self] in
                if success {
                    self.provideContentForProductIdentifier(productIdentifier)
                } else {
                    print("Failed to verify receipt")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelperReceiptInvalidNotification), object: productIdentifier)
                }
            }
            
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    fileprivate func restoreTransaction(_ transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.original!.payment.productIdentifier
        print("restoreTransaction... \(productIdentifier)")
        validateReceipt(forProductID: productIdentifier) { success in
            DispatchQueue.main.async { [unowned self] in
                if success {
                    self.provideContentForProductIdentifier(productIdentifier)
                } else {
                    print("Failed to verify receipt")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelperReceiptInvalidNotification), object: productIdentifier)
                }
            }
            
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    // Helper: Saves the fact that the product has been purchased and posts a notification.
    fileprivate func provideContentForProductIdentifier(_ productIdentifier: String) {
        purchasedProductIdentifiers.insert(productIdentifier)
        UserDefaults.standard.set(true, forKey: productIdentifier)
        NotificationCenter.default.post(name: Notification.Name(rawValue: IAPHelperProductPurchasedNotification), object: productIdentifier)
    }
    
    fileprivate func failedTransaction(_ transaction: SKPaymentTransaction) {
        FTLogging().FTLog("failedTransaction...")
        if transaction.error!._code != SKError.paymentCancelled .rawValue{
            FTLogging().FTLog("Transaction error: \(transaction.error!.localizedDescription)")
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelled"), object: nil)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        if request is SKReceiptRefreshRequest {
            let receiptUrl = Bundle.main.appStoreReceiptURL!
            
            if FileManager.default.fileExists(atPath: receiptUrl.path) {
                print("App receipt exists")
            } else {
                print("Receipt request done but there is no receipt")
            }
        }
    }
}*/

