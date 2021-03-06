//
//  ResultListViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/06/21.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Pring
import DZNEmptyDataSet

class ResultListViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    var notificationItem: NotificationItem?
    var currentResult: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResultTableViewCell.self)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchResults()
    }
    
    func fetchResults() {
        guard let notificationItem = notificationItem else { return }
        notificationItem.result.get { (result, error) in
            if let result = result {
                self.currentResult = result
                self.fetchVoter(result: result)
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchVoter(result: Result) {
        result.voter.get { (user, error) in
            if let user = user {
                let name = user.displayName
                self.navigationItem.title = name + "のチェック"
            }
        }
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ResultListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let contentHeight = UIScreen.main.bounds.size.height - (navigationBarHeight + statusbarHeight)
        let headerHeight = (contentHeight / 7) * 3
        let bottomHeight = (contentHeight / 7) * 4
        
        if indexPath.row < 3 {
            let height = headerHeight / 3
            print("height : ", indexPath.row, "→", height)
            return height
        } else {
            let height = bottomHeight / 6
            print("height : ", indexPath.row, "→", height)
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ResultTableViewCell.self, for: indexPath)
        switch indexPath.row {
        case 0:
            currentResult?.first.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 1:
            currentResult?.second.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 2:
            currentResult?.third.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 3:
            currentResult?.fource.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 4:
            currentResult?.fifth.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 5:
            currentResult?.sixth.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 6:
            currentResult?.seventh.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 7:
            currentResult?.eighth.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        case 8:
            currentResult?.ninth.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        default:
            currentResult?.ninth.get({ (user, error) in
                cell.configure(with: indexPath.row + 1, user: user)
            })
        }
        return cell
    }
}

extension ResultListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 他のユーザー表示する
//        tableView.deselectRow(at: indexPath, animated: true)
        //        let viewController = OtherUserProfileViewController.instantiate()
        //        viewController.user = cell.user
        //        present(viewController, animated: true, completion: nil)
    }
}

