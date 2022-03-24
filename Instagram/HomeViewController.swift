//
//  HomeViewController.swift
//  Instagram
//
//  Created by 横田瑛美 on 2022/03/15.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    var listener: ListenerRegistration!

    override func viewDidLoad() {
           super.viewDidLoad()

           tableView.delegate = self
           tableView.dataSource = self

           // カスタムセルを登録する
           let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
           tableView.register(nib, forCellReuseIdentifier: "Cell")
       }

       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           print("DEBUG_PRINT: viewWillAppear")
           // ログイン済みか確認
           if Auth.auth().currentUser != nil {
               
           let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
               listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
            return
            }
                         // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.postArray = querySnapshot!.documents.map { document in
            print("DEBUG_PRINT: document取得 \(document.documentID)")
            let postData = PostData(document: document)
            return postData
            }
                         // TableViewの表示を更新する
            self.tableView.reloadData()
                }
               
            } else {
                     // ログイン未(またはログアウト済み)
              if listener != nil {
                       // listener登録済みなら削除してpostArrayをクリアする
                 listener.remove()
                 listener = nil
                 postArray = []
                 tableView.reloadData()
            }
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return postArray.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // セルを取得してデータを設定する
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
           cell.setPostData(postArray[indexPath.row])

           return cell
       }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
