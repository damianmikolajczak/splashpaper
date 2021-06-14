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

struct Photo: Codable {
    var id: String
    var description: String?
    var urls: URLs
    var user: User
    var width: Int
    var height: Int
}

struct URLs: Codable {
    var small: String
    var regular: String
    var full: String
    var raw: String
}

struct User:Codable {
    var id: String
    var username: String
    var name: String
}



