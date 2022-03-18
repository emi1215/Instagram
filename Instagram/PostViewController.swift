//
//  PostViewController.swift
//  Instagram
//
//  Created by 横田瑛美 on 2022/03/15.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            imageView.image = image
        }
    
    @IBAction func handlePostButton(_ sender: Any) {
        
        let imageData = image.jpegData(compressionQuality: 0.75)
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        
            SVProgressHUD.show()
        
        let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
        if error != nil {
            
            print(error!)
            SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            return
        }
                
        let name = Auth.auth().currentUser?.displayName
        let postDic = [
            "name": name!,
            "caption": self.textField.text!,
            "date": FieldValue.serverTimestamp(),
        ] as [String : Any]
        postRef.setData(postDic)
                
           SVProgressHUD.showSuccess(withStatus: "投稿しました")
                
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
