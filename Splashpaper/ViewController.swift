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
        photosTable.rowHeight = 270
    }

    func searchPhotos() {
        let url = URL(string: "https://api.unsplash.com/search/photos?&query=mountain")
        var request = URLRequest(url: url!)

        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                self.serachResult = result
                print(result)
                DispatchQueue.main.async {
                    self.photosTable.reloadData()
                }
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
            return 2
        }
        
        return numberOfElements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
        if let photoUrlString = serachResult?.results[indexPath.row].urls.regular {
            let photoURL = URL(string: photoUrlString)
            var request = URLRequest(url: photoURL!)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    cell.photo.image = UIImage(data: data)
                    cell.authorName.text = self.serachResult!.results[indexPath.row].user.name
                }
            })
            
            task.resume()
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ImageDetailView") as! ImageDetailViewController
        
        if let photoUrlString = serachResult?.results[indexPath.row].urls.full {
            let photoURL = URL(string: photoUrlString)
            var request = URLRequest(url: photoURL!)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    vc.image = UIImage(data: data)
                    vc.modalPresentationStyle = .popover
                    self.present(vc, animated: true, completion: nil)
                }
            })
            
            task.resume()
        }
    }
}

