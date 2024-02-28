//
//  FeedCell.swift
//  InstaCloneApp
//
//  Created by Ali serkan Boyracı  on 13.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage


class FeedCell: UITableViewCell {
    
    
    @IBOutlet var userEmailLabel: UILabel!
    
    @IBOutlet var commentLabel: UILabel!
    
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var likeLabel: UILabel!
    
    
    @IBOutlet var documentIdLabel: UILabel! // for like count
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code şçıioöuüp[]\';/..,,mmnbvcçxzåasAÅÅQŒWEÇİ§±.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) { // if we can reach actual likelabel
            let likeStore = ["likes": likeCount + 1] as [String : Any] //WE MUST DEFINE one string: any dict to change likecount
            
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true) //to reach like number and update it' merge means only update likes', not to do anything otherpart.
            
        }
        // only one like enabled, we must define likes collection and define only likes collection.
        // you must work on firebase and read firebase documantry.
        // followers collection and you can define fellowship between users.h ktkkt
    
    }
}
// push notification is not added, because I havent got apple developer account,
