//
//  ChartViewController.swift
//  TimePad
//
//  Created by yoga arie on 14/05/22.
//

import UIKit
import Charts

import RealmSwift

class ChartViewController: BaseViewController {

    weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "My Productivity"
        
        setup()
    }
    
    func setup() {
        let chartView = LineChartView(frame: .zero)
        view.addSubview(chartView)
        self.chartView = chartView
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor)
        ])
        if #available(iOS 11.0, *) {
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        } else {
            chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        }
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let yAxis = chartView.leftAxis
        yAxis.axisMinimum = -30
        yAxis.axisMaximum = 240
        yAxis.labelFont = .boldSystemFont (ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = UIColor(rgb: 0x070417)
        yAxis.axisLineColor = .clear
        yAxis.labelPosition = .outsideChart
        
        let xAxis = chartView.xAxis
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 6
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont (ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .black
        xAxis.axisLineColor = .systemBlue
        
        chartView.rightAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        
        setData()
    }

    func setData() {
        let realm = try! Realm()
        let tasks = Array(realm.objects(Task.self))
        
        let tasksMin3 = tasks.filter { task in
            if let date = Date().addDays(-3), let finish = task.finish {
                return finish.isSameDay(date)
            }
            return false
        }
        
        let tasksMin2 = tasks.filter { task in
            if let date = Date().addDays(-2), let finish = task.finish {
                return finish.isSameDay(date)
            }
            return false
        }
        
        let tasksMin1 = tasks.filter { task in
            if let date = Date().addDays(-1), let finish = task.finish {
                return finish.isSameDay(date)
            }
            return false
        }
        
        
        let tasksToday = tasks.filter { task in
            if let finish = task.finish {
                return finish.isSameDay(Date())
            }
            return false
        }
        
        var values: [ChartDataEntry] = []
        let groupedTasks = [tasksMin3, tasksMin2, tasksMin1, tasksToday]
        for i in 0..<groupedTasks.count {
            let tasks = groupedTasks[i]
            let minutes: [Double] = tasks
                .compactMap { task in
                    if let finish = task.finish, let start = task.start {
                        return finish.timeIntervalSince(start) / 60.0
                    }
                    return 0.0
                }
                
            let minute: Double = minutes.reduce(0, +)
            let dataEntry = ChartDataEntry(x: Double(i + 1), y: minute)
            values.append(dataEntry)
        }
        
        
//        for i in 0..<tasks.count {
//            let task = tasks[i]
//            if let finish = task.finish, let start = task.start {
//                let minute = finish.timeIntervalSince(start) / 60
//                let dataEntry = ChartDataEntry(x: Double(i + 1), y: minute)
//                values.append(dataEntry)
//            }
//        }
        
        let set = LineChartDataSet(entries: values, label: "My Activities")
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.lineWidth = 4
        set.setColor(UIColor(rgb: 0xA862EF))
        set.fill = Fill (color: UIColor(rgb: 0xA862EF))
        set.fillAlpha = 0.8
        set.drawFilledEnabled = true

        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = . systemRed
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        
        
        chartView.data = data
    }
}
