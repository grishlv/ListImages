//
//  NetworkService.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 31.08.23.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchImages(completion: @escaping ([Image]?, Error?) -> Void)
}

enum TechError: Error {
    case invalidURL
}

final class NetworkService: NetworkServiceProtocol {
    
    private let url = "https://jsonplaceholder.typicode.com/photos"
    
    func fetchImages(completion: @escaping ([Image]?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil, TechError.invalidURL)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                do {
                    let images = try JSONDecoder().decode([Image].self, from: data)
                    completion(images, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
