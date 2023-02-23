//
//  Youtube.swift
//  NetflixClone
//
//  Created by Wilson Mungai on 2023-02-22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}

/*
 items =     (
             {
         etag = br8hN1WnwfeuK8cmuvBIPZaEWiw;
         id =             {
             kind = "youtube#video";
             videoId = okUNLqtHRP8;
         };
         kind = "youtube#searchResult";
     },
 */
