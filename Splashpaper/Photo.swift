//
//  Photo.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 13/06/2021.
//

import Foundation
import UIKit

struct Result: Codable {
    var total: Int
    var results: [Photo]
}

struct Photo: Codable, Hashable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var description: String?
    var urls: URLs
    var user: User
    var width: Int
    var height: Int
}

struct URLs: Codable, Hashable {
    static func == (lhs: URLs, rhs:URLs) -> Bool {
        return false
    }
    var small: String
    var regular: String
    var full: String
    var raw: String
}

struct User:Codable, Hashable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String
    var username: String
    var name: String
}



