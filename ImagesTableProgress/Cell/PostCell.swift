//
//  FileCell.swift
//  ProgressBarTest
//
//  Created by MiciH on 4/18/21.
//

import UIKit

class PostCell: UITableViewCell {
    
    static let reuseID = "PostCell"
    
    let fileIdLabel = PBTitleLabel(textAlignment: .left, fontSize: 18, weight: .bold, color: .label)
    let fileProgressLabel = PBTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular, color: .secondaryLabel)
    let fileImageView = PBImageView(frame: .zero)
    let progressView = PBProgressView()
    var progress: Float = 0.0
    var buttonState: Bool?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(fileProgressLabel)
        addSubview(fileIdLabel)
        addSubview(fileImageView)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            fileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            fileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            fileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            progressView.topAnchor.constraint(equalTo: fileImageView.bottomAnchor, constant: 6),
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            fileIdLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            fileIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            fileIdLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            fileProgressLabel.bottomAnchor.constraint(equalTo: fileIdLabel.topAnchor, constant: -6),
            fileProgressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            fileProgressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
    func set(post: Post, buttonState: Bool){
        self.buttonState = buttonState
        fileIdLabel.text = "ID#: \(post.id)"
        
        if buttonState == false{
            return
        }
        if buttonState == true{
            downloadImage(post: post, buttonState: buttonState)
        }
    }
    
    private func downloadImage(post: Post, buttonState: Bool){
        
        //##  can use regular, raw, full for different image resolution
        if let url = URL(string: post.urls.raw) {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            if buttonState == false{
                downloadPause(session: session)
                return
            }
            if buttonState == true{
                session.downloadTask(with: url).resume()
            }
        }
        else{
            print("image download url no valid")
        }
    }
    
    private func downloadPause(session: URLSession){
        session.invalidateAndCancel()
        DispatchQueue.main.async { [weak self] in
            self?.progressView.setProgress(self?.progress ?? 0.0, animated: true)
            self?.fileProgressLabel.text = String(format: "%.2f", self?.progress ?? 0.0 * 100) + "%"
        }
    }
    
    private func downloadFinish(image: UIImage?){
        DispatchQueue.main.async {  [weak self] in
            self?.fileImageView.image = image
            self?.progressView.isHidden = true
        }
    }
    
    private func downloadTaskInProgress(){
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else {return}
            
            self.fileImageView.isHidden = true
            self.fileProgressLabel.text = String(format: "%.2f", self.progress * 100) + "%"
        }
    }
    
    private func downloadTaskPaused(){
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else {return}
            self.fileImageView.isHidden = false
            self.progressView.progress = self.progress
            self.fileProgressLabel.text = "DONe"
        }
    }
}


extension PostCell: URLSessionDownloadDelegate{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let data = try? Data(contentsOf: location) else {
            print("could not display image")
            return
        }
        let image = UIImage(data: data)
        self.downloadFinish(image: image)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 10
        
        if buttonState == true{
            if progress <= 1.0{
                self.downloadTaskInProgress()
            }
            else{
                self.downloadTaskPaused()
            }
        }
    }
}
