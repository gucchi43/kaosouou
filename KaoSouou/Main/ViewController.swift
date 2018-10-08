//
//  ViewController.swift
//  KaoSouou
//
//  Created by Hiroki Taniguchi on 2018/02/19.
//  Copyright © 2018年 Hiroki Taniguchi. All rights reserved.
//

import UIKit
import Kingfisher
import Pring
import Firebase
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mypageButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!
    
    // TEST データがない時用の仮データ
    var humanArray = [UIImage]()
    var girlsArray =  [#imageLiteral(resourceName: "g2"),#imageLiteral(resourceName: "g3"),#imageLiteral(resourceName: "g8"),#imageLiteral(resourceName: "g0"),#imageLiteral(resourceName: "g5"),#imageLiteral(resourceName: "g4"),#imageLiteral(resourceName: "g6"),#imageLiteral(resourceName: "g7"),#imageLiteral(resourceName: "g1")]
    var mensArray = [#imageLiteral(resourceName: "m3"),#imageLiteral(resourceName: "m0"),#imageLiteral(resourceName: "m4"),#imageLiteral(resourceName: "m6"),#imageLiteral(resourceName: "m2"),#imageLiteral(resourceName: "m1"),#imageLiteral(resourceName: "m5"),#imageLiteral(resourceName: "m7"),#imageLiteral(resourceName: "m8")]
    
    var kaoUserArray = [User]()
    var currentKaoUserArray = [User]()
    var numArray = [0,0,0,0,0,0,0,0,0] //9人の順位が入っていく 例) [9,1,2,3,6,4,7,5,8]
    var selectNum = 0
    var firstUser: User?
    var firstFace: UIImage?
    
    var disEnabledCellArray = [humanCell]()
    var selectCell: humanCell?
    var oldSelectCell: humanCell?
    var timer = Timer()
    
    var finishFlag = false
    
    var userDataSourse: DataSource<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setButton() {
        mypageButton.layer.cornerRadius = mypageButton.bounds.height / 2
        mypageButton.layer.borderWidth = 1
        mypageButton.layer.borderColor = UIColor.white.cgColor
        mypageButton.clipsToBounds = true
        mypageButton.btnShadow(radius: 0.5, opacity: 0.5)
        
        resetButton.layer.cornerRadius = resetButton.bounds.height / 2
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.white.cgColor
        resetButton.clipsToBounds = true
        resetButton.btnShadow(radius: 0.5, opacity: 0.5)
    }
    
    func startLoding() {
        coverView.isHidden = false
        oneLabel.isHidden = false
        twoLabel.isHidden = false
        threeLabel.isHidden = false
        loadLabel.isHighlighted = false
        loading()
    }
    
    func stopLoading() {
        coverView.isHidden = true
        oneLabel.isHidden = true
        twoLabel.isHidden = true
        threeLabel.isHidden = true
        loadLabel.isHighlighted = true
        timer.invalidate()
    }
    
    func loading() {
        var count = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
            count += 1
            self.changeLoadView(count: count)
        })
    }
    
    func changeLoadView(count: Int) {
        let key = count % 3
        switch key {
        case 0:
            oneLabel.text = "🦄"
            twoLabel.text = "🐴"
            threeLabel.text = "🐴"
        case 1:
            oneLabel.text = "🐴"
            twoLabel.text = "🦄"
            threeLabel.text = "🐴"
        case 2:
            oneLabel.text = "🐴"
            twoLabel.text = "🐴"
            threeLabel.text = "🦄"
        default:
            oneLabel.text = "🐴"
            twoLabel.text = "🐴"
            threeLabel.text = "🦄"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        finishFlag = false
        collectionView.reloadData()
        // ローカルのUserのArray(kaoUserArray)がまだ9あればそのまま使う。なければまた取ってくる。
        // 本番は一日あたりに選択できる回数を制限する場合はここに何かしらの追記が必要
        self.startLoding()
        guard let currentUser = AccountManager.shared.currentUser else { return } // TODO: elseの時のアラート出す
        if kaoUserArray.count >= 9 {
            createCurrentKaoUserArray()
            self.collectionView.reloadData {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.stopLoading()
                }
            }
        } else {
            if currentUser.gender == 2 {
                humanArray = mensArray
                getUserArray(with: 1)
            } else {
                humanArray = girlsArray
                getUserArray(with: 2)
            }
        }
    }
    
    // 全Userを性別でwhereかけて取ってくる
    // 取ってきた後、arrayをshuffleしてcollectionViewをリロード
    func getUserArray(with genderNum: Int) {
        kaoUserArray.removeAll()
        userDataSourse = User
            .where(\User.gender, isEqualTo: genderNum)
            .order(by: \User.createdAt)
            .dataSource()
            .onCompleted({ (snapshot, userArray) in
                print("userArray : ",  userArray)
                if userArray.count >= 9 {
                    self.kaoUserArray = userArray
                    self.shuffleArray()
                    self.createCurrentKaoUserArray()
                } else {
                    self.kaoUserArray = userArray
                    self.shuffleArray()
                    self.createCurrentKaoUserArray()
                }
                self.collectionView.reloadData {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.stopLoading()
                    }
                }
            })
        .listen()
    }
    
    func shuffleArray() {
        for i in 0 ..< kaoUserArray.count{
            let r = Int(arc4random_uniform(UInt32(kaoUserArray.count - i))) + i
            kaoUserArray.swapAt(i, r)
        }
    }
    
    func createCurrentKaoUserArray() {
        self.currentKaoUserArray = Array(self.kaoUserArray.prefix(9))
        self.kaoUserArray = Array(self.kaoUserArray.suffix(self.kaoUserArray.count - self.currentKaoUserArray.count))
        finishFlag = true
        
        print("currentKaoUserArray :", currentKaoUserArray)
        print("kaoUserArray :", kaoUserArray)
        
    }
    
    func getHensachi(with num: Int) -> Double {
        let juni = numArray[num]
        let tensu = Double(8 - juni) * 12.5
        let heikin = Double(45)
        let hensachi = 50 + (tensu - heikin) / 2
        
        print("num : ", num)
        print("juni : ", juni)
        
        return hensachi
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentPrintFacePower" {
            // リセット
            selectNum = 0
            numArray = [0,0,0,0,0,0,0,0,0]
            let vc = segue.destination as! PrintFacePowerViewController
            vc.faceImage = firstFace
        }
    }
    
    @IBAction func tapResetButton(_ sender: Any) {
        selectNum = 0
        firstUser = nil
        firstFace = nil
        numArray = [0,0,0,0,0,0,0,0,0]
        collectionView.reloadData()
    }
    
    @IBAction func tapMypageButton(_ sender: Any) {
        let sb = UIStoryboard(name: "MyPage", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! MyPageViewController
        self.show(vc, sender: nil)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space = 1
        let wlength = (Int(UIScreen.main.bounds.width) - space) / 3
        let hlength = (Int(UIScreen.main.bounds.height) - space) / 3
        
        return CGSize(width: wlength, height: hlength)
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(with: humanCell.self, for: indexPath)
//        if let user = kaoUserArray[safe: indexPath.row] {
//            cell.configure(with: user, num: self.numArray[indexPath.row])
//        } else {
//            cell.configure(with: humanArray[indexPath.row], num: numArray[indexPath.row])
//        }
//        return cell
        
        // kaoUserArrayをローカルで使い回すパターン
        // currentKaoUserArrayに分けてそれを使う
        
        let cell = collectionView.dequeueReusableCell(with: humanCell.self, for: indexPath)
        if finishFlag {
            if let user = currentKaoUserArray[safe: indexPath.row] {
                cell.configure(with: user, num: self.numArray[indexPath.row])
            } else {
                cell.configure(with: humanArray[indexPath.row], num: numArray[indexPath.row])
            }
        } else {
            cell.emptyConfigure()
        }
        return cell
    }
}


extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("indexPath.row : ", indexPath.row)
        
        let cell = collectionView.cellForItem(at: indexPath) as! humanCell        
        let currentNum = selectNum
        if numArray[indexPath.row] == 0 {
            //選択されてない
            cell.check(with: currentNum + 1)
            numArray[indexPath.row] = currentNum + 1
            selectNum = currentNum + 1
        } else {
            // 選択されてる
            cell.uncheck()
            numArray[indexPath.row] = 0
            selectNum = currentNum - 1
        }
        if selectNum == 1 {
            if let user = currentKaoUserArray[safe: indexPath.row] {
                self.firstUser = user
            }
            self.firstFace = cell.imageView.image
        }
        print("selectNum", selectNum)
        print("numArray", numArray)
        
        collectionView.reloadData()
        if selectNum == 9 {
            print("numArray : ", numArray)
            SVProgressHUD.show(withStatus: "マイリスト更新中")
            addLoveList(success: {
                SVProgressHUD.show(withStatus: "facepower更新中")
                self.createResult()
                SVProgressHUD.dismiss()
                let sb = UIStoryboard(name: "PrintFacePower", bundle: nil)
                let vc = sb.instantiateInitialViewController() as! PrintFacePowerViewController
                vc.modalTransitionStyle = .crossDissolve
                // リセット
                self.selectNum = 0
                self.numArray = [0,0,0,0,0,0,0,0,0]
                vc.faceImage = self.firstFace
                
                print("採点！")
                self.present(vc, animated: true, completion: nil)
            }) { (error) in
                SVProgressHUD.showError(withStatus: "データ送信に失敗しました")
                print(error)
            }
        }
    }
}

// POST部分
extension ViewController {
    func addLoveList(success: @escaping() -> Void, failure: @escaping(Error) -> Void) {
        guard let user = AccountManager.shared.currentUser else { return }
        if let firstUser = firstUser {
            user.loveUsers.insert(firstUser)
            user.update { (error) in
                if let error = error {
                    failure(error)
                } else {
                    success()
                }
            }
        } else {
            success()
        }
    }
    
    func createResult() {
        let result = Result()
        result.voter.set(AccountManager.shared.currentUser!)
        for (index, user) in currentKaoUserArray.enumerated() {
            print("index : ", index)
            print("user : ", user)
            updateUserHensachi(user: user, index: index)
            let num = numArray[index]
            switch num{
            case 1:
                result.first.set(user)
            case 2:
                result.second.set(user)
            case 3:
                result.third.set(user)
            case 4:
                result.fource.set(user)
            case 5:
                result.fifth.set(user)
            case 6:
                result.sixth.set(user)
            case 7:
                result.seventh.set(user)
            case 8:
                result.seventh.set(user)
            case 9:
                result.seventh.set(user)
            default:
                result.seventh.set(user)
            }
        }
        createNotification(result: result)
    }
    
    func updateUserHensachi(user: User, index: Int) {
        let oldHensachi = user.hensachi
        let updateHensachi = getHensachi(with: index)
        let newHensachi = (oldHensachi + updateHensachi) / 2
        user.hensachi = newHensachi
        let oldKaisu = user.kaisu
        let newKaisu = oldKaisu + 1
        user.kaisu = newKaisu
        user.update { (error) in
            if let error = error {
                print("hensachi update error! : ",error)
            } else {
                print("oldHensachi : ", oldHensachi)
                print("updateHensachi : ", updateHensachi)
                print("newHensachi : ", newHensachi)
                print("更新後 currentUser.hensachi : ", user.hensachi)
                
            }
        }
    }
    
    func createNotification(result: Result) {
        for (index, user) in currentKaoUserArray.enumerated() {
            print("index: ", index)
            print("result: ", result)
            let notificationItem = NotificationItem()
            notificationItem.from.set(AccountManager.shared.currentUser!)
            notificationItem.to.set(user)
            notificationItem.num = String(numArray[index])
            notificationItem.result.set(result)
            user.results.insert(result)
            user.notificationItems.insert(notificationItem)
            user.badgeNum += 1
            user.update { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("user update succses")
                }
            }
        }
    }
}
