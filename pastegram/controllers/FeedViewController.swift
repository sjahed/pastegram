//
//  FeedViewController.swift
//  pastegram
//
//  Created by Sayed Jahed Hussini on 10/10/21.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!
    
    var selectedPost: PFObject!
    let totalNumPosts = 20
    let initialNumPosts = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name:
                            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        getPosts()
////        let currentUser = PFUser.getCurrentUserInBackground()
//
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
//        tableView.refreshControl = refreshControl
//
//    }
    
    @objc func getPosts(numPosts: Int){
        
        let query = PFQuery(className: "Posts")
        query.addDescendingOrder("createdAt")
        query.includeKeys(["author","comments","comments.author"])
        query.limit = totalNumPosts + numPosts
        
        query.findObjectsInBackground { (posts,error) in
                
            if posts != nil{
                self.posts.removeAll()
                self.posts.append(contentsOf: posts!)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
            
        }
    }
    
    func getMorePosts(){
        getPosts(numPosts: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts(numPosts: initialNumPosts)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
     
            let user = post["author"] as! PFUser
            cell.userLabel.text = user.username
            cell.captionLabel.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.postImageView.af.setImage(withURL: url)
            return cell
        }
        else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row-1]
            cell.commentLabel.text = (comment["text"] as? String) ?? ""
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
             
        }
        
        
        
        
//        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            getMorePosts()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = posts[indexPath.section]
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
//        let comment = PFObject(className: "comments")
        
        if indexPath.row == comments.count + 1 {
            print("here at\(indexPath.row)")
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }

    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewContoller = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewContoller
        
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { success, error in
            if success{
                print("comment saved")
            } else {
                print("Could not save comment. error:\(error)")
            }
        }
        tableView.reloadData()
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
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
