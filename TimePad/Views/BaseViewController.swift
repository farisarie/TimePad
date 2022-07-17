//
//  BaseViewController.swift
//  TimePad
//
//  Created by yoga arie on 18/05/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        setupColor()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
                setupColor()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func setupColor(){
        if #available(iOS 12.0, *) {
            view.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor.backgroundDark : UIColor.backgroundLight
        }
        else {
            // Fallback on earlier versions
            view.backgroundColor = UIColor.backgroundLight
        }

    }

}
