//
//  FeedViewController.swift
//  InstaCloneApp
//
//  Created by Ali serkan Boyracı  on 11.10.2022.
//

import UIKit
import FirebaseStorage
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SDWebImage



class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var useremailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]() // to make like Button, first we will take all documentId's to save here and give it in feedcell in label and we will take it from there.
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore () {
        let fireStoreDatabase = Firestore.firestore()
        // it is important
        /*let settings = fireStoreDatabase.settings // to change firestore settings //ın old versions
         // settings.areTimestampsInSnapshotsEnabled = true
         fireStoreDatabase.settings = settings
         */
        
        
        // to take data from firebase
        // to order tak'ng data we mustt add .order

        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in // if you have to enter one lower you must add after .collection() to add .document().collection after .addsnapshot
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil { // must be sth in snapshot array
                    
                    // to not see lots of duplicate images
                    
                    self.useremailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents { // means in storage, you can see all of them in array
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        
                        // we can use it only in one if let structure
                        if let postedBy = document.get("postedBy") as? String { //means if we can take postedby as string, we define as postedBy
                            self.useremailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData() // to reload Data
                }
            }
        }
    }
  
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return useremailArray.count
        }
        // it is impoartan we must use dequeuereusablecell.
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell // Feedcell defines here
            
            cell.commentLabel.text = userCommentArray[indexPath.row]
            cell.userEmailLabel.text = useremailArray[indexPath.row]
            cell.likeLabel.text = String(likeArray[indexPath.row])
            cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row])) // we have to write in URL paranthesis.
            cell.documentIdLabel.text = documentIdArray[indexPath.row] // to give data  from feedcell.swift
            
            return cell
        }
        
        
    }

