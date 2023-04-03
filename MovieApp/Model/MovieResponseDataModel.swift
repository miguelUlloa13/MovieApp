//
//  MovieResponseDataModel.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 02/04/23.
//

import Foundation

/*
    JSON:
 {
    "page":1,
    "results":[
       {
          "adult":false,
          "backdrop_path":"/bT3IpP7OopgiVuy6HCPOWLuaFAd.jpg",
          "id":638974,
          "title":"Murder Mystery 2",
          "original_language":"en",
          "original_title":"Murder Mystery 2",
          "overview":"After starting their own detective agency, Nick and Audrey Spitz land a career-making case when their billionaire pal is kidnapped from his wedding.",
          "poster_path":"/5wpVy0KUWzDKDKgrayM0Q8lXOiK.jpg",
          "media_type":"movie",
          "genre_ids":[
             35,
             9648,
             28
          ],
          "popularity":235.901,
          "release_date":"2023-03-26",
          "video":false,
          "vote_average":6.691,
          "vote_count":228
       },
        // ...
    ],
    "total_pages":1000,
    "total_results":20000
 }
 
 */

struct MovieDataModel: Decodable {
    let adult:Bool?
    // let backdrop_path:
    let id:Int?
    let title: String?
    let language: String?
    let overview: String?
    let popularity: Float?
    let score: Float?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case title
        case language = "original_language"
        case overview
        case popularity
        case score = "vote_average"
    }
    
}

struct MovieResponseDataModel: Decodable {
    let page:Int?
    let movies:[MovieDataModel]
    let pages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case pages = "total_pages"
        case totalResults = "total_results"
    }
}
