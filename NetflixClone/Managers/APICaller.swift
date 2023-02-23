//
//  APICaller.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-20.
//

import Foundation

struct constants {
    // tmdb api key
    static let APIKey = "53bb76834e431dda9c6ac64c32ec35a5"
    // tmdb base url
    static let baseUrl = "https://api.themoviedb.org"
    // google dev api key
    static let YoutubeAPIKey = "AIzaSyAeOhT5SAS-H5UZtpjJHqJjiPh47J25fBI"
    // youtube base url
    static let YoutubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
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
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
                //                print(result)
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
    
    // Get upcoming movies method
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
    
    // Get popular movies method
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
    
    // Get top rated movies method
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
    
    // discover movies method
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>)-> Void)  {
        guard let url = URL(string: "\(constants.baseUrl)/3/discover/movie?api_key=\(constants.APIKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                //                print(result)
                completion(.success(result.results))
            }
            catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // search api caller
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        // format query to return a new string
        //        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        //        guard let url = URL(string:
        //            "\(constants.baseUrl)/3/search/movie?api_key=\(constants.APIKey)&query=\(query)") else { return }
        // replace white space adding Percent Encoding
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(constants.baseUrl)/3/search/movie?api_key=\(constants.APIKey)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                //                print(result)
                completion(.success(result.results))
            }
            catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // movie preview
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        // replace white space adding Percent Encoding
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        // url string
        guard let url = URL(string: "\(constants.YoutubeBaseUrl)q=\(query)&key=\(constants.YoutubeAPIKey)") else { return }
        // url session
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data, error == nil else { return }
            do {
                //                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                // access the items but return the firs index which is the best result
                completion(.success(result.items[0]))
                print(result)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}


// https://youtube.googleapis.com/youtube/v3/search?q=Harry%20&key=[YOUR_API_KEY] HTTP/1.1

//https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher

//https://api.themoviedb.org/3/discover/movie?api_key=<<api_key>>&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate

//https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
