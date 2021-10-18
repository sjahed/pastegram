//
//  FeedViewController.swift
//  pastegram
//
//  Created by Sayed Jahed Hussini on 10/10/21.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!
    
    let totalNumPosts = 20
    let initialNumPosts = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
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
        query.includeKey("author")
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
//        if tableView.visibleCells.isEmpty {
//            return 0
//        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
//        if !tableView.visibleCells.isEmpty {
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.userLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.postImageView.af.setImage(withURL: url)
//        }
        
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            getMorePosts()
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
