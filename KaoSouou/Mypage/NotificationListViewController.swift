//
//  NotificationListViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/20.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Pring
import DZNEmptyDataSet

class NotificationListViewController: UIViewController, Storyboardable {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: DataSource<NotificationItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 68
        tableView.register(NotificationTableViewCell.self)
        fetchNotifications()
    }
    
    func fetchNotifications() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        dataSource = currentUser.notificationItems.order(by: \NotificationItem.createdAt, descending: true).dataSource()
            .on({ [weak self] (snapshot, changes) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
            }).listen()
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension NotificationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ??  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NotificationTableViewCell.self, for: indexPath)
        cell.configure(with: dataSource![indexPath.row])
        return cell
    }
}

extension NotificationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        let notificationItem = dataSource![indexPath.row]
//        let viewController = ResultListViewController.instantiate()
        
        let resultSB = UIStoryboard(name: "ResultList", bundle: nil)
        let resultNC = resultSB.instantiateInitialViewController() as! UINavigationController
        let resultVC = resultNC.topViewController as! ResultListViewController
        notificationItem.result.get { (result, error) in
            if let result = result {
                print("ゲット リザルト！！！", result)
                resultVC.currentResult = result
                self.present(resultNC, animated: true, completion: nil)
            } else {
                self.present(resultNC, animated: true, completion: nil)
            }
        }
//        let viewController = OtherUserProfileViewController.instantiate()
//        viewController.user = cell.user
//        present(viewController, animated: true, completion: nil)
    }
}
