//
//  ViewController.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 13/06/2021.
//

import UIKit

class ViewController: UIViewController {

    let token = "Of course i hide the access key :)"
    var photos = Array<Results>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPhotos()
    }

    func searchPhotos() {
        let url = URL(string: "https://api.unsplash.com/search/photos?query=office")
        var request = URLRequest(url: url!)

        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                self.photos.append(results)
                print("2")
                print(results)
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
}

