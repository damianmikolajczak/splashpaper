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
    
    var serachResult:Result?
    
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
                let result = try JSONDecoder().decode(Result.self, from: data)
                self.serachResult = result
                print(result)
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfElements = serachResult?.results.count else {
            return 0
        }
        
        return numberOfElements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

