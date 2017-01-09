//
//  InfoViewController.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController {
    
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.router.popViewController(animated: true)
    }

}
