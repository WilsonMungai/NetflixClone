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

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    // fetch trending movies
    //    func getTrendingMovies(completion: @escaping (String) -> Void) {
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        // construct the url
        guard let url = URL(string: "\(constants.baseUrl)/3/trending/movie/day?api_key=\(constants.APIKey)") else {return}
        // start the url session
        // completion handler returns the data, response and error
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            // check there is no error
            guard let data = data, error == nil else { return }
            do {
                //                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                //                print(result)
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
                //                print(result.results[0].original_name)
            } catch {
                completion(.failure(APIError.failedToGetData))
                //                print(error.localizedDescription)
            }
        }
        // the task was in a suspended state so we need to resume
        task.resume()
    }
    
    // fetch trending shows
    func getTrendingTv(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseUrl)/3/trending/tv/day?api_key=\(constants.APIKey)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            do {
                //                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
//                print(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>)-> Void) {
        guard let url = URL(string: "\(constants.baseUrl)/3/movie/upcoming?api_key=\(constants.APIKey)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            do {
//                let result = try JSONSerialization.jsonObject(with: data,
//                                                              options: .fragmentsAllowed)
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
//                print(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseUrl)/3/movie/popular?api_key=\(constants.APIKey)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
//                print(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(constants.baseUrl)/3/movie/top_rated?api_key=\(constants.APIKey)&language=en-US&page=1") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
//                print(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}


//https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
