//
//  SearchResult.swift
//  GitSearch
//
//  Created by username on 01.10.2021.
//

import Foundation

class ResultArray: Codable {
    var total_count = 0
    var items = [SearchResult]()
}

class ReposInfo: Codable {
    
    var name = ""
    var description: String?
    var html_url: String?
    var updated_at: String?
    var stargazers_count: Int
    var forks_count: Int
    var language: String?
}

class SearchResult: Codable, CustomStringConvertible {

    var login = ""
    var url = ""
    var avatar_url = ""
    var html_url = ""
    var followers_url = ""
    var repos_url = ""
    
    var description: String {
        return "Login: \(login)"
    }

    /*
    enum CodingKeys: String, CodingKey {
        
    }
    */
}
