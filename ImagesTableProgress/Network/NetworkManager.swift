//
//  Network.swift
//  ImagesTableProgress
//
//  Created by MiciH on 4/21/21.
//

import UIKit

enum NetworkError: Error {
    case badURL
    case decodingError
    case noData
}

fileprivate struct APIResponse: Codable {
    let results: [Post]
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    //make a search images url end point
    private let baseURL = "https://api.unsplash.com"
    let searchPath = "/search/photos"
    var query = "karaoke"
    let tokenID = "u5g3fusSWsVkWLOfXTwF_gb7V28cZJKLKlq1Z_Ie3ZU"
    let per_page = 20
    
    let cache = NSCache<NSString, UIImage>()
    
    func getPosts(query: String, completion: @escaping (Result<Results, NetworkError>)-> Void){
        
        guard let url = URL(string: "\(baseURL)\(searchPath)\("?query=\(query)")&per_page=\(per_page)&client_id=\(tokenID)") else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.badURL))
                }
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
        
    }
    
    //Not in use if we want use image cache in the future
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void){
        
        let cacheKey = NSString(string: urlString)
        //find out if the image is the chace
        if let image = cache.object(forKey: cacheKey){
            //add image
            completed(image)
            return
        }
        
        //create & check a URL
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        //URLSessions Task = Fetch the data
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            //handle errors - passing nil(empty image) when error
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else{
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        //Start the Task
        task.resume()
    }
    
}



