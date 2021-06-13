//
//  ViewController.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 13/06/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photosTable: UITableView!
    
    
    let token = "Of course i hide the access key :)"
    var photos = Array<Results>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPhotos()
        
        photosTable.delegate = self
        photosTable.dataSource = self
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

