//
//  ComentWriteViewController.swift
//  Instagram
//
//  Created by 横田瑛美 on 2022/03/18.
//

import UIKit
import Firebase
class ComentWriteViewController: UIViewController {
    var id = ""
    @IBOutlet weak var comentTextView: UITextView!
    @IBAction func goButton(_ sender: Any) {
        let commentText = comentTextView.text
             // ユーザー名を加えたコメントメッセージを組み立て
             let name = Auth.auth().currentUser!.displayName!
             let comment = "\(name) : \(commentText)"
             // FireStoreにコメントメッセージを追加
             let updateValue = FieldValue.arrayUnion([comment])
             let postRef = Firestore.firestore().collection(Const.PostPath).document(id)
             postRef.updateData(["comments": updateValue])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
