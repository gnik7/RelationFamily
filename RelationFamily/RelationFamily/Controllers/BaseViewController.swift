//
//  BaseViewController.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //var
    lazy var router :Router = Router(navigationController: self.navigationController!)
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.gestureTap))
    
    var yPositionBaseView   : CGFloat = 0.0
    var isNeedToScroll = false

    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyBoardObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func addKeyBoardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    final func gestureTap() {
        self.view.endEditing(true)
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func keyboardWasShown(_ notification: Notification) {
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        self.view.removeGestureRecognizer(tapGesture)
    }
}
