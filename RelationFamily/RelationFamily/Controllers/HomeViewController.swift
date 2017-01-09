//
//  HomeViewController.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit
import StoreKit

let productIDApp = "com.jack.rwerelated.removeads"


class HomeViewController: BaseViewController {
    
    //IBOutlet
    @IBOutlet weak var user1View    : UIView!
    @IBOutlet weak var user2View    : UIView!
    @IBOutlet weak var scrollView   : UIScrollView!
    @IBOutlet weak var resultButton : UIButton!
    
    //var
    private var userView1 : UserView?
    private var userView2 : UserView?
    internal var adView    : AdMobView?
    
    var user1   : UserModel?
    var user2   : UserModel?
    var logic   : MainLogicManager = MainLogicManager()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupInApp()
        yPositionBaseView = user1View.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        resultButton.layer.cornerRadius = resultButton.frame.size.height / 2
        resultButton.clipsToBounds = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //*****************************************************************
    // MARK: - In App init
    //*****************************************************************
    
    private func setupInApp() {
        
        SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
        
        //Check if product is purchased
        if (UserDefaults.standard.bool(forKey: "purchased")){
            // Hide ads
        } else {
            //Should show ads
            showAds()
        }
    }
    
    func inAppAction(){
        
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: productIDApp);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<NSString> as Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        }else{
            print("Can't make purchases");
        }
    }
    
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    //*****************************************************************
    // MARK: - Setup Views
    //*****************************************************************
    
    private func setupViews() {
        // user view 1
        userView1 = UserView.loadFromXib()
        userView1?.frame = CGRect(x: 0, y: 0, width: (user1View?.frame.size.width)!, height: (user1View?.frame.size.height)!)
        userView1?.delegate = self
        user1View?.addSubview(userView1!)
        userView1?.setupDropDownList()
        userView1?.setupData(user: UserNumber.One)
        
        // user view 2
        userView2 = UserView.loadFromXib()
        userView2?.frame = CGRect(x: 0, y: 0, width: (user2View?.frame.size.width)!, height: (user2View?.frame.size.height)!)
        userView2?.delegate = self
        user2View?.addSubview(userView2!)
        userView2!.setupDropDownList()
        userView2?.setupData(user: UserNumber.Two)
    }
    
    private func showAds() {
        adView = AdMobView.loadFromXib()
        adView?.show(action: { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.inAppAction()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        self.router.showInfoViewController()
    }
    
    @IBAction func resultButtonPressed(_ sender: UIButton) {
        mainLogic()
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    override func keyboardWasShown(_ notification: Notification) {
        super.keyboardWasShown(notification)
        if self.isNeedToScroll {
            let point = CGPoint(x: 0, y: self.yPositionBaseView)
            self.scrollView.setContentOffset(point, animated: true)
        }
    }
    
    override func keyboardWillBeHidden(_ notification: Notification) {
        super.keyboardWillBeHidden(notification)
        if self.isNeedToScroll {
            let point = CGPoint(x: 0, y: 0)
            self.scrollView.setContentOffset(point, animated: true)
            self.isNeedToScroll = false
        }
    }
    
    //*****************************************************************
    // MARK: - Main Logic
    //*****************************************************************
    
    func mainLogic(){
        
        user1 = UserModel(name: (userView1?.nameTexField.text)!, type: UserNumber.One, relation: (userView1?.relationTextField.text)!, indexRelation: 0)
        user2 = UserModel(name: (userView2?.nameTexField.text)!, type: UserNumber.Two, relation: (userView2?.relationTextField.text)!, indexRelation: 0)
        
        guard  let user1 = self.user1, let user2 = self.user2,
               let relation1 = user1.relation  , let relation2 = user2.relation else {
            return
        }
        
        let rel1 = logic.parseUser(p1: relation1)
        let rel2 = logic.parseUser(p1: relation2)
        
        let fullString = logic.convertPossibilitiesBase(x: rel1, y: rel2, name1: user1.name!, name2: user2.name!)
        Alert.showAlert(controller: self, title: AlertTitle.TitleCommon.rawValue, message: fullString, action: {
            
            self.userView1?.clearFields()
            self.userView2?.clearFields()
        })
    }
}

extension HomeViewController: UserViewDelegate {
    
    //*****************************************************************
    // MARK: - UserViewDelegate
    //*****************************************************************
    
    func relationChoosen(item: String, index: Int, user: UserNumber, userName: String) {
        if user == UserNumber.One {
            user1 = UserModel(name: userName, type: user, relation: item, indexRelation: index)
        }
        if user == UserNumber.Two {
            user2 = UserModel(name: userName, type: user, relation: item, indexRelation: index)
        }
    }
    
    func textFieldIsActive(){
        isNeedToScroll = true
    }
}

extension HomeViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    //*****************************************************************
    // MARK: - SKProductsRequestDelegate
    //*****************************************************************
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == productIDApp) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(product: validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error){
        print("Error Fetching product information")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction])
        
    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    self.adView?.hideView()
                    break;
                case .failed:
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
   
                case .restored:
                    print("Already Purchased");
                    SKPaymentQueue.default().restoreCompletedTransactions()

                    // Handle the purchase
                    UserDefaults.standard.set(true , forKey: "purchased")
                    self.adView?.hideView()
                    break;
                default:
                    break;
                }
            }
        }
    }
}

//code to restore a non-consumable in app purchase
//if (SKPaymentQueue.canMakePayments()) {
//    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
//}


// https://github.com/AssistoLab/DropDown
