//
//  Photo.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 13/06/2021.
//

import Foundation
import UIKit

struct Results: Codable {
    var total: Int
    var results: [Photo]
}

struct Photo: Codable {
    var id: String
    var description: String?
    var urls: URLs
}

struct URLs: Codable {
    var small: String
}



