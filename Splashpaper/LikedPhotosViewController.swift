//
//  LikedPhotosViewController.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 14/06/2021.
//

import UIKit

class LikedPhotosViewController: UIViewController {

    @IBOutlet weak var photosTable: UITableView!
    
    let token = "Of course i hide the access key :)"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photosIDs = Array<PhotoID>()
    var photos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotoIDs()
        getPhotos()
        
        photosTable.delegate = self
        photosTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPhotoIDs()
        getPhotos()
        photosTable.reloadData()
    }
    
    func fetchPhotoIDs () {
        do {
            photosIDs = try context.fetch(PhotoID.fetchRequest())
            
        } catch {print(error)}
    }
    
    func getPhotos() {
        for id in photosIDs {
            let photoURL = URL(string: "https://api.unsplash.com/photos/\(id.id!)")
            print("Photo id: \(id.id!)\n")
            var request = URLRequest(url: photoURL!)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data else { print("Corupted photo data"); return }
                do {
                    self.photos?.append(try JSONDecoder().decode(Photo.self, from: data))
                    
                } catch {print(error)}
            })
            
            task.resume()
        }
    }
}

extension LikedPhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = photos?.count else { return 0}
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
       
        let imageURL = URL(string: "\(photos![indexPath.row].urls.small)")
        var request = URLRequest(url: imageURL!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                cell.photo.image = UIImage(data: data)
                cell.authorName.text = self.photos![indexPath.row].user.name
            }
        })
        
        task.resume()

        return cell
    }
    
}

extension LikedPhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ImageDetailView") as! ImageDetailViewController
        
        if let photoId = photos?[indexPath.row].id {
            vc.imageID = photoId
            print(photoId)
            vc.token = self.token
            vc.modalPresentationStyle = .popover
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = photos?[indexPath.row] else { return CGFloat(270)}
        
        let imageHeight = Float(photo.height)
        let imageWidth = Float(photo.width)
        let aspectRatio = imageWidth/imageHeight
        
        return CGFloat(414.0 / aspectRatio)
    }
}


