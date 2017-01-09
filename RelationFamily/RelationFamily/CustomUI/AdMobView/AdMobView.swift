//
//  AdMobView.swift
//  RelationFamily
//
//  Created by Nikita Gil on 09.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdMobView: UIView {
    
    //IBOutlet
    @IBOutlet weak var banerView: GADBannerView!
    @IBOutlet weak var hideForeverButton: UIButton!
 
    
    //var
    var completion  : (() -> ())?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    class func loadFromXib(bundle : Bundle? = nil) -> AdMobView? {
        return UINib(
            nibName: "AdMobView",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? AdMobView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.endEditing(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
    }
    
    //*****************************************************************
    // MARK: - Set UI
    //*****************************************************************
    
    private func updateUI() {
        hideForeverButton.layer.cornerRadius = hideForeverButton.frame.size.height / 2
    }
 
    func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.endEditing(true)
            windowView.addSubview(self)
            
            print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
            banerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            banerView.rootViewController = windowView.rootViewController
            banerView.load(GADRequest())
        }
        
        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func show(action: (() -> ())?) {
        
        completion = action
        self.showViewAnimation()
    }
    
    private func showViewAnimation() {
        
        self.bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { () -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func hideView() {

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            
            self.isHidden = true
            self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        
        self.hideView()
    }
    
    @IBAction func inappButtonPressed(_ sender: UIButton) {
        
        if let action = completion {
            action()
        }
    }
}

