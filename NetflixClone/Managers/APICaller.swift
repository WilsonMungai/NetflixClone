//
//  APICaller.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-20.
//

import Foundation

struct constants {
    static let APIKey = "53bb76834e431dda9c6ac64c32ec35a5"
    static let baseUrl = "https://api.themoviedb.org"
}

class APICaller {
    static let shared = APICaller()
    
    // fetch trending movies
    func getTrendingMovies(completion: @escaping (String) -> Void) {
        // construct the url
        guard let url = URL(string: "\(constants.baseUrl)/3/trending/all/day?api_key=\(constants.APIKey)") else {return}
        // start the url session
        // completion handler returns the data, response and error
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            // check there is no error
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(result)
            } catch {
                print(error.localizedDescription)
            }
        }
        // the task was in a suspended state so we need to resume 
        task.resume()
    }
}
