//
//  Upcoming.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-21.
//

//import Foundation
//
//struct UpcomingMoviesResponse: Codable {
//    let results: [UpcomingMovies]
//}
//// MARK: - Result
//struct UpcomingMovies: Codable {
//    let id: Int
//    let original_language: String?
//    let original_title: String?
//    let overview: String?
//    let popularity: String?
//    let poster_path: String?
//    let release_date: String?
//    let title: String?
//    let vote_average: Double?
//    let vote_count: Int?
//}
    
//    let adult: Bool?
//    let backdropPath: String?
//    let genreIDS: [Int]
//    let id: Int
//    let originalLanguage: OriginalLanguage
//    let originalTitle, overview: String?
//    let popularity: Double?
//    let posterPath, releaseDate, title: String?
//    let video: Bool?
//    let voteAverage: Double?
//    let voteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }

//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case es = "es"
//}

//results =     (
//            {
//        adult = 0;
//        "backdrop_path" = "/9Rq14Eyrf7Tu1xk0Pl7VcNbNh1n.jpg";
//        "genre_ids" =             (
//            28,
//            12,
//            53
//        );
//        id = 646389;
//        "original_language" = en;
//        "original_title" = Plane;
//        overview = "After a heroic job of successfully landing his storm-damaged aircraft in a war zone, a fearless pilot finds himself between the agendas of multiple militias planning to take the plane and its passengers hostage.";
//        popularity = "3115.286";
//        "poster_path" = "/qi9r5xBgcc9KTxlOLjssEbDgO0J.jpg";
//        "release_date" = "2023-01-13";
//        title = Plane;
//        video = 0;
//        "vote_average" = "6.8";
//        "vote_count" = 502;
//    },
