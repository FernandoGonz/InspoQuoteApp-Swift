//
//  ViewController.swift
//  InspoQuoteApp
//
//  Created by Fernando González on 13/06/22.
//

import UIKit
import StoreKit

class ViewController: UITableViewController {
    // Product ID from AppStore Connect
    let productID = "com.fernandogonzalez.InspoQuoteApp.PremiumQuotes"
    
    private var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    private let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        // For SKPaymentTransactionObserver Delegate
        SKPaymentQueue.default().add(self)
    }
    
    @IBAction func restoreButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    // MARK: - UITableViewController DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quotesToShow.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: K.cellId, for: indexPath)
        
        if indexPath.row < self.quotesToShow.count {
            let quote: String = self.quotesToShow[indexPath.row]
            
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            content.text = quote
            content.textProperties.color = UIColor.black
            // A value of 0 indicates that the number of lines is limitless.
            content.textProperties.numberOfLines = 0
            
            cell.accessoryType = .none
            cell.contentConfiguration = content
        } else {
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            content.text = "Get More Quotes"
            content.textProperties.color = UIColor.blue
            // A value of 0 indicates that the number of lines is limitless.
            content.textProperties.numberOfLines = 0
            
            cell.accessoryType = .disclosureIndicator // Get More Quotes >
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    // MARK: - UITableViewController Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This method will triggered if indexPath.row == self.quotesToShow.count (Get More Quotes option)
        if indexPath.row == self.quotesToShow.count {
            self.buyPremiumQuotes()
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - In-App Purchase Methods
    private func buyPremiumQuotes() {
        // Check if user can purchase In-App
        if SKPaymentQueue.canMakePayments() {
            
            // Trying to make a payment
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = self.productID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            print("User can not make payments")
        }
    }
    
    private func showPremiumQuotes() {
        self.quotesToShow.append(contentsOf: self.premiumQuotes)
        self.tableView.reloadData()
    }

}

// MARK: - SKPaymentTransactionObserver Delegate
// This delegate inform us if the transaction is updated, failed or success
extension ViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // User payment successful
                SKPaymentQueue.default().finishTransaction(transaction)
                self.showPremiumQuotes()
            } else if transaction.transactionState == .failed {
                // Paymen failed
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    
}

