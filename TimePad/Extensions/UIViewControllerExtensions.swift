//
//  UIViewControllerExtensions.swift
//  TimePad
//
//  Created by yoga arie on 14/05/22.
//

import Foundation
import UIKit

extension UIViewController{
    func add(_ child: UIViewController, view: UIView? = nil) {
        let containerView: UIView! = view ?? self.view
        addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        child.didMove(toParent: self)
    }
    func remove(){
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}


// MARK: - Back & Close
extension UIViewController {
    func addCloseButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "btn_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(self.closeButtonTapped(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "btn_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonTapped(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
