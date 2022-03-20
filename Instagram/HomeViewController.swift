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
    
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           print("DEBUG_PRINT: viewWillAppear")
        
           if Auth.auth().currentUser != nil {
               
           let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
               listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
           if let error = error {
                  print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                  return
           }
                   
            self.postArray = querySnapshot!.documents.map { document in
                  print("DEBUG_PRINT: document取得 \(document.documentID)")
              let postData = PostData(document: document)
              return postData
            }
                   
            self.tableView.reloadData()
            }
          }
     }

    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           print("DEBUG_PRINT: viewWillDisappear")
           listener?.remove()
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postArray.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
            cell.setPostData(postArray[indexPath.row])
        
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        cell.comentWriteButton.addTarget(self, action:#selector(touchWriteButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
    
    @objc func touchWriteButton(_ sender: UIButton, forEvent event: UIEvent){
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

            // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        let comentViewController = self.storyboard?.instantiateViewController(withIdentifier: "comentView") as! ComentWriteViewController
        comentViewController.id = postData.id
        self.present(comentViewController, animated: true, completion: nil)
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
            print("DEBUG_PRINT: likeボタンがタップされました。")
        
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)
        
            let postData = postArray[indexPath!.row]
        
            if let myid = Auth.auth().currentUser?.uid {
                
                var updateValue: FieldValue
                if postData.isLiked {
                    
                    updateValue = FieldValue.arrayRemove([myid])
                } else {
                    
                    updateValue = FieldValue.arrayUnion([myid])
                }
                
                let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                postRef.updateData(["likes": updateValue])
            }
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
