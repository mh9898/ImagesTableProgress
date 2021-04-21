//
//  PBImageView.swift
//  ImagesTableProgress
//
//  Created by MiciH on 4/20/21.
//

import UIKit

class PBImageView: UIImageView {
    
    let placeHolderImage = UIImage(systemName: "photo")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = placeHolderImage
        contentMode = .scaleAspectFit
    }
    
//    func downloadImage(from urlString: String){
//
////        let cacheKey = NSString(string: urlString)
////
////        if let image = Network.shared.cache.object(forKey: cacheKey){
////            self.image = image
////            return
////        }
////
////        guard let url = URL(string: urlString) else { return }
////
////        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
////
////        session.downloadTask(with: url).resume()
//
//        guard let url = URL(string: urlString) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//
//            guard let self = self else {return}
//
//            if error != nil {return}
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
//            guard let data = data else {return}
//
//            guard let image = UIImage(data: data) else {return}
////            Network.shared.cache.setObject(image, forKey: cacheKey)
//
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//        task.resume()
//    }
}

//extension PBImageView: URLSessionDownloadDelegate{
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        
//        guard let data = try? Data(contentsOf: location) else{
//            print("can not load data")
//            return
//        }
//        
//        
//        let image = UIImage(data: data)
////                   Network.shared.cache.setObject(image, forKey: NSString(string: location))
//       
//                   DispatchQueue.main.async {
//                       self.image = image
//                   }
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
////        print("progress is: \(progress)")
//    }
//    
//    
//}
