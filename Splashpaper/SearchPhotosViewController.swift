//
//  SearchPhotosViewController.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 14/06/2021.
//

import UIKit

class SearchPhotosViewController: UIViewController {

    @IBOutlet weak var photosTable: UITableView!
    @IBOutlet weak var searchQurryField: UITextField!
    
    @IBAction func SearchButtonTapped() {
        guard let query = searchQurryField.text else { return }
        searchPhotos(query)
        view.endEditing(true)
    }
    
    let token = "Of course i hide the access key :)"
    
    var serachResult:Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPhotos("new")
        
        photosTable.delegate = self
        photosTable.dataSource = self
        photosTable.rowHeight = 270
    }
    
    func searchPhotos(_ query: String) {
        let url = URL(string: "https://api.unsplash.com/search/photos?&query=\(query)")
        var request = URLRequest(url: url!)

        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                self.serachResult = result
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

extension SearchPhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfElements = serachResult?.results.count else {
            return 0
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

extension SearchPhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ImageDetailView") as! ImageDetailViewController
        
        if let photoId = serachResult?.results[indexPath.row].id {
            vc.imageID = photoId
            print(photoId)
            vc.token = self.token
            vc.modalPresentationStyle = .popover
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = serachResult?.results[indexPath.row] else { return CGFloat(270)}
        
        let imageHeight = Float(photo.height)
        let imageWidth = Float(photo.width)
        let aspectRatio = imageWidth/imageHeight
        
        return CGFloat(414.0 / aspectRatio)
    }
}

extension SearchPhotosViewController {
    
    func hideKeyboard() {
        
    }
}

