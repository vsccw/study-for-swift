//
//  ViewController.swift
//  new-user-notifications
//
//  Created by 程庆春 on 2017/1/2.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UITableViewController {
    typealias Task = String

    let tasks: [Task] = [
        "Wash up",
        "Walk dog",
        "Exercise"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "New User Notifications"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.titleLabel.text = task

        retrieveNotification(for: task) { (request) in
            request != nil ? cell.showReminderOnIcon() : cell.showReminderOffIcon()
        }
        cell.onButtonSelection = {
            [unowned self] in
            self.toggleReminder(for: task)
        }
        return cell
    }
}

extension ViewController {

    func cell(for task: Task) -> TaskCell {
        let index = tasks.index(of: task)
        let indexPath = IndexPath(item: index!, section: 0)
        return tableView.cellForRow(at: indexPath) as! TaskCell
    }


    func toggleReminder(for task: Task) {

        retrieveNotification(for: task) {
            request in
            guard request != nil else {
                // Notification doesn't exist, therefore schedule it
                self.createReminderNotification(for: task)
                return
            }

            // Remove notification
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task])

            // Now we've muted the notification, let's set the cell's icon to reflect that.
            let cell = self.cell(for: task)
            cell.showReminderOffIcon()
        }
    }

    func retrieveNotification(for task: Task, completion: @escaping (UNNotificationRequest?) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            DispatchQueue.safeMainQueue(excute: { 
                let request = requests.filter({
                    $0.identifier == task
                }).first
                completion(request)
            })
        }
    }

    func createReminderNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "Task reminder"
        content.body = "\(task)!!"
        content.sound = UNNotificationSound.default()
        
        content.categoryIdentifier = Identifiers.reminderCategory

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let identifier = "\(task)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                 print("Problem adding notification: \(error.localizedDescription)")
            }
            else {
                DispatchQueue.safeMainQueue { [weak self] in
                    guard let strongSelf = self else { return }
                    let cell = strongSelf.cell(for: task)
                    cell.showReminderOnIcon()
                }
            }
        }
    }
}

