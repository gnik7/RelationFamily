//
//  UserView.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit
import DropDown

enum UserNumber: Int {
    case One = 1
    case Two = 2
}

protocol UserViewDelegate : class {
    
    func relationChoosen(item: String, index: Int, user: UserNumber, userName: String)
    func textFieldIsActive()
}

class UserView: UIView {
    
    // @IBOutlet
    
    @IBOutlet weak var dropDownList     : UIView!
    @IBOutlet weak var uselLabel        : UILabel!
    @IBOutlet weak var relationLabel    : UILabel!
    @IBOutlet weak var dropDownLabel    : UILabel!
    @IBOutlet weak var nameTexField     : UITextField!
    @IBOutlet weak var relationTextField: UITextField!
    
    // var
    
    var dropDown        : DropDown?
    var currentUser     : UserNumber?
    weak var delegate   : UserViewDelegate?
    
    let userText = "Person "
    let defaultText = "Common Relative's Relation To You"

    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTexField.delegate = self
        nameTexField.autocapitalizationType = .words
        relationTextField.delegate = self
        relationTextField.autocapitalizationType = .words
    }

    class func loadFromXib(bundle : Bundle? = nil) -> UserView? {
        return UINib(
            nibName: String(describing: UserView.self ),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UserView
    }
    
    func setupDropDownList(){
        dropDown = DropDown()
        dropDown?.anchorView = dropDownList
        dropDown?.direction = .bottom
        
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.relationLabel.text = item
            
            let name = self.nameTexField.text!
            
            if let delegate = self.delegate {
                delegate.relationChoosen(item: item, index: index + 1,  user: self.currentUser!, userName: name)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Setup Data
    //*****************************************************************
    
    func setupData(user: UserNumber){
        currentUser = user
        uselLabel.text = userText + String(user.rawValue)
        
        var array = XSLDataSourceManger.sharedInstance.simpleChartArray[0]
        array.removeLast()
        array.removeLast()
        array.removeLast()
        array.removeLast()
        array.removeFirst()
        dropDown?.dataSource = array
    }
    
    func clearFields() {
        relationTextField.text = ""
    }

    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func dropDownListButtonPressed(_ sender: UIButton) {
        dropDown?.show()
    }
}

extension UserView: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //*****************************************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if let delegate = self.delegate, let user = currentUser, user == UserNumber.Two {
            delegate.textFieldIsActive()
        }
        return true
    }
}

