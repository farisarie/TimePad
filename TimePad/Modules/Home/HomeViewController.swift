//
//  HomeViewController.swift
//  TimePad
//
//  Created by yoga arie on 14/05/22.
//

import UIKit
import RealmSwift

class HomeViewController: BaseViewController {

    weak var tableView: UITableView!
    
    var task: Results<Task>!
    var token: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        let realm = try! Realm()
        task = realm.objects(Task.self)
        token = task.observe { [weak self] (changes) in
            guard let `self` = self else { return }
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, let insertions, let modifications):
                print("Delete ", deletions)
                print("Inserted ", insertions)
                print("Modified ", modifications)
                self.tableView.reloadData()
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit{
        token.invalidate()
    }
    
    func setup(){
        title = "Task"
        let tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        self.tableView = tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(TaskViewCell.self, forCellReuseIdentifier: "taskCellId")
        tableView.register(HistoryViewCell.self, forCellReuseIdentifier: "historyCellId")
    }

    // MARK: - Helpers
    func unfinishedTask() -> [Task] {
    
        let filteredTasks = task.filter { task in
            return task.start == nil || task.finish == nil
        }
        return Array(filteredTasks)
    }
    
    func finishedTask() -> [Task] {
      
        let filteredTasks = task.filter { task in
            return task.start != nil && task.finish != nil
        }
            .sorted { $0.finish! > $1.finish! }
        return Array(filteredTasks)
        
    }
    func duplicateTask(_ task: Task){
        let newTask = Task()
        newTask.title = task.title
        newTask.tag = task.tag
        newTask.category = task.category
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTask)
        }
        
    }
   
}
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return unfinishedTask().count
        } else {
            return finishedTask().count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskViewCell
        let task = unfinishedTask()[indexPath.row]
    
            
            if let start = task.start {
                cell.timeLabel.text = Date().timeIntervalSince(start).durationString
            }
            else {
                cell.timeLabel.text = "00:00:00"
            }
            cell.categoryType = task.categoryType
            cell.tagType = task.tagType
            cell.nameLabel.text = task.title
            
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as! HistoryViewCell
            let task = finishedTask()[indexPath.row]
            let category = task.categoryType
            cell.iconImageView.image = category?.icon
            cell.nameLabel.text = task.title
            if let finish = task.finish, let start = task.start {
                cell.timeLabel.text = finish.timeIntervalSince(start).durationString
            }
            else {
                cell.timeLabel.text = "00:00:00"
            }
            cell.categoryType = task.categoryType
            cell.tagType = task.tagType
            
            cell.delegate = self
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Today"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        return view
        }
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = unfinishedTask()[indexPath.row]
            presentTaskViewController(task: task)
        }
        else {
            
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TaskViewCell{
            cell.startTimer()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TaskViewCell{
            cell.stopTimer()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
}
 

// MARK: - HistoryViewCellDelegate
extension HomeViewController: HistoryViewCellDelegate {
    func historyViewCellPlayButtonTapped(_ cell: HistoryViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let task = finishedTask()[indexPath.row]
            duplicateTask(task)
        }
    }
}


extension HomeViewController: TaskViewCellDelegate{
    func taskViewCellTitleString(_ cell: TaskViewCell) -> String {
        if let indexPath = tableView.indexPath(for: cell){
            let task = unfinishedTask()[indexPath.row]
            if let start = task.start{
            return Date().timeIntervalSince(start).durationString
        }
        }
     return "00:00:00"
    }
    
}
