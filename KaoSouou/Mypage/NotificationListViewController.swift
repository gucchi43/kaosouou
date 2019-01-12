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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.rowHeight = 68
        tableView.register(NotificationTableViewCell.self)
        tableView.tableFooterView = UIView()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        resetBadgeNum()
    }
    
    func fetchNotifications() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let options: Options = Options()
        options.sortDescriptors = [sortDescriptor]
        
        dataSource = currentUser.notificationItems
            .order(by: "updatedAt")
            .dataSource(options: options)
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
    
    func resetBadgeNum() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        if currentUser.badgeNum > 0 {
            currentUser.badgeNum = 0
            currentUser.update { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("succes reset badgeNum")
                }
            }
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
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
        let notificationItem = dataSource![indexPath.row]
        let resultSB = UIStoryboard(name: "ResultList", bundle: nil)
        let resultNC = resultSB.instantiateInitialViewController() as! UINavigationController
        let resultVC = resultNC.topViewController as! ResultListViewController
        resultVC.notificationItem = notificationItem
        self.present(resultNC, animated: true, completion: nil)
    }
}

extension NotificationListViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return #imageLiteral(resourceName: "empty_main_2")
//    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let titleText = "まだ評価されてません"
        let titleAttributes = [.font: UIFont.boldSystemFont(ofSize: 16),
                               .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] as [NSAttributedStringKey : Any]
        return NSMutableAttributedString(string: titleText, attributes: titleAttributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let descText = "他の人を評価することで自分も評価されやすくなるよ！"
        let descAttributes = [.font: UIFont.systemFont(ofSize: 14),
                              .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] as [NSAttributedStringKey : Any]
        return NSAttributedString(string: descText, attributes: descAttributes)
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

