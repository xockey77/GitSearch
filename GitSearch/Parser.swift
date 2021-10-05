//
//  Parser.swift
//  GitSearch
//
//  Created by username on 05.10.2021.
//

import UIKit

class Parser {
    
    static func parseArray<T: Decodable>(data: Data, type: T) -> [T] {
        do {
            var repositories = [T]()
            
            let decoder = JSONDecoder()
            repositories = try decoder.decode([T].self, from: data)
            return repositories
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
