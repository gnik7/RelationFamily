//
//  Alert.swift
//  RelationFamily
//
//  Created by Nikita Gil on 09.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit

enum AlertTitle : String {
    
    case TitleCommon = "Result"
}

struct Alert {
    
    //*****************************************************************
    // MARK: - Simple
    //*****************************************************************
    
    static func showAlert(controller :UIViewController, title :String, message:String?, action: (() -> ())?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.cancel,
                                      handler: { act in
                                        if let action = action {
                                            action()
                                        }
        }))
        controller.present(alert, animated: true, completion: nil)
 }
}
