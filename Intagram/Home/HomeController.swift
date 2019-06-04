//
//  HomeController.swift
//  Intagram
//
//  Created by Jorge Casariego on 12/7/18.
//  Copyright © 2018 Jorge Casariego. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellId = "cellId"
    var posts: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // La idea aquí es escuchar si tenemos alguna notificación de actualización de Feeds.
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        fetchAllPosts()
    }
    
    @objc fileprivate func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc fileprivate func handleRefresh() {
        // Ya que al refrescar siguen mostrando los posts de quien dejamos de seguir debemos primero limpiar nuestro array de posts
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingsUserIds()
    }
    
    fileprivate func fetchFollowingsUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
                }
            })
        }) { (err) in
            print("Failed to fetch users: ", err)
        }
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            
            // Ordenamos las fotos segun la fecha de creación
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch post: ", err)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal),  style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc fileprivate func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8  // username + userprofileImageView
        height += view.frame.width // image height
        height += 50 // For other icons
        height += 60 // For captions
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
            cell.delegate = self
            
        }
        
        return cell
    }
    
    func didTapComment(post: Post) {
        print("Message coming from HomeController")
        print(post.caption)
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(commentsController, animated: true)
    }
}
