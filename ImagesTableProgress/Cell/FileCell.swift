//
//  FileCell.swift
//  ProgressBarTest
//
//  Created by MiciH on 4/18/21.
//

import UIKit

class FileCell: UITableViewCell {
    
    static let reuseID = "FileCell"
    
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
    
    func configure(){
        addSubview(fileProgressLabel)
        addSubview(fileIdLabel)
        addSubview(fileImageView)
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            fileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            fileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            fileImageView.heightAnchor.constraint(equalToConstant: 200),
            
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
    
    func downloadImage(post: Post, buttonState: Bool){
        
        //##  can use regular, raw, full for different image resolution
        if let url = URL(string: post.urls.regular) {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            if buttonState == false{
                session.invalidateAndCancel()
                DispatchQueue.main.async { [weak self] in
                    self?.progressView.setProgress(self?.progress ?? 0.0, animated: true)
                    self?.fileProgressLabel.text = String(format: "%.2f", self?.progress ?? 0.0 * 100) + "%"
                }
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
    
}

extension FileCell: URLSessionDownloadDelegate{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let data = try? Data(contentsOf: location) else {
            print("could not display image")
            return
        }
        let image = UIImage(data: data)
        
        DispatchQueue.main.async {  [weak self] in
            self?.fileImageView.image = image
            self?.progressView.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 10
        
        if buttonState == true{
            if progress <= 1.0{
                DispatchQueue.main.async { [weak self] in
                    self?.progressView.isHidden = false
                    self?.progressView.setProgress(self?.progress ?? 0.0, animated: true)
                    self?.fileProgressLabel.text = String(format: "%.2f", self?.progress ?? 0.0 * 100) + "%"
                }
            }
            else{
                DispatchQueue.main.async { [weak self] in
                    self?.progressView.isHidden = true
                    self?.progressView.setProgress(self?.progress ?? 0.0, animated: true)
                    self?.fileProgressLabel.text = "1.00%"
                }
            }
        }
    }
}
