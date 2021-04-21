//
//  ViewController.swift
//  ImagesTableProgress
//
//  Created by MiciH on 4/20/21.
//

import UIKit


class ListVC: UIViewController {
    
    var progress: Float = 0.0
    
    var tableView = UITableView()
    var downloadButton = PBButton(backgroundColor: .systemRed, title: "Play | Pause")
    var posts: [Post] = []
    let networker = NetworkManager.shared
    var buttonState = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPostsResult()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Files Downloader"
        view.backgroundColor = .systemBackground
        configureTableView()
        configureButton()
    }
    
    func getPostsResult(){
        networker.getPosts(query: "karaoke") { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let posts):
                self.posts = posts.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        
        tableView.rowHeight = 280
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FileCell.self, forCellReuseIdentifier: FileCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureButton(){
        view.addSubview(downloadButton)
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        downloadButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton(){
        buttonState.toggle()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.reuseID) as! FileCell
        let post = posts[indexPath.row]
        cell.set(post: post, buttonState: buttonState)
        return cell
    }
}
