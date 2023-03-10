//
//  Movie.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-20.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}
struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

/*
 
 adult = 0;
 "backdrop_path" = "/uDgy6hyPd82kOHh6I95FLtLnj6p.jpg";
 "first_air_date" = "2023-01-15";
 "genre_ids" =             (
     18,
     10759
 );
 id = 100088;
 "media_type" = tv;
 name = "The Last of Us";
 "origin_country" =             (
     US
 );
 "original_language" = en;
 "original_name" = "The Last of Us";
 overview = "Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.";
 popularity = "5859.799";
 "poster_path" = "/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg";
 "vote_average" = "8.831";
 "vote_count" = 1888;
 
 */

