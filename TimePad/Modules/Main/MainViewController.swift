//
//  MainViewController.swift
//  TimePad
//
//  Created by yoga arie on 14/05/22.
//

import UIKit

class MainViewController: BaseViewController {
    
    var homeViewController: UIViewController = {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        return navigationController
    }()
    
    let chartViewController: UIViewController = {
        let navigationController = UINavigationController(rootViewController: ChartViewController())
        return navigationController
    }()
    
    weak var tabBarView: TabBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        tabBarView.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            homeViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarView.bounds.height + 16, right: 0)
            chartViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarView.bounds.height + 16, right: 0)
        } else {
            // Fallback on earlier versions
        }
        
       
    }
    
    func setup() {
        let tabBarView = TabBarView(cornerRadius: 30, color: UIColor.tabBarLight, darkColor: UIColor.tabBarDark)
        view.addSubview(tabBarView)
        self.tabBarView = tabBarView
        tabBarView.delegate = self
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            tabBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        }
        else {
            // Fallback on earlier versions
            tabBarView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        }
        
        let homeButton = TabBarButton(image: UIImage(named: "tab_time"), disabledImage: UIImage(named: "tab_time_active"), darkDisabledImage: UIImage(named: "tab_time_active_dark"))
        
        let addButton = TabBarButton(image: UIImage(named: "tab_add"), disabledImage: nil)
        
        let chartButton = TabBarButton(image: UIImage(named: "tab_chart"), disabledImage: UIImage(named: "tab_chart_active"), darkDisabledImage: UIImage(named: "tab_chart_active_dark"))
        
        tabBarView.items = [homeButton, addButton, chartButton]
    }
    
    func showHome() {
        chartViewController.remove()
        add(homeViewController)
        view.bringSubviewToFront(tabBarView)
    }
    
    func showChart() {
        homeViewController.remove()
        add(chartViewController)
        view.bringSubviewToFront(tabBarView)
    }
    
    func addTask() {
        presentAddTaskViewController()
    }
}


// MARK: - TabBarViewDelegate
extension MainViewController: TabBarViewDelegate {
    func tabBarView(_ view: TabBarView, didSelectItemAt index: Int) {
        switch index {
        case 0:
            showHome()
        case 1:
            addTask()
        case 2:
            showChart()
        default:
            break
        }
    }
    
    func tabBarView(_ view: TabBarView, shouldSelectItemAt index: Int) -> Bool {
        return index != 1
    }
}
