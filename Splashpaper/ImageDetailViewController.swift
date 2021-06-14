//
//  ImageDetailViewController.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 14/06/2021.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var token: String?
    var imageID: String?
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    
    @IBAction func likePhoto(){
        
    }
    
    @IBAction func donwloadPhoto() {
        let photoURL = URL(string: "https://api.unsplash.com/photos/\(imageID!)?")
        var getPhotoRequest = URLRequest(url: photoURL!)
        getPhotoRequest.httpMethod = "GET"
        getPhotoRequest.setValue("Client-ID \(token!)", forHTTPHeaderField: "Authorization")
        
        let getPhotoTask = URLSession.shared.dataTask(with: getPhotoRequest, completionHandler: { data, response, error in
            guard let data = data else { print("Photo data corupted"); return }
            do {
                let photo = try JSONDecoder().decode(Photo.self, from: data)
                let photoRawImageURL = URL(string: photo.urls.raw)
                var getRawImageRequest = URLRequest(url: photoRawImageURL!)
                getRawImageRequest.httpMethod = "GET"
                print("Done")
                let getRawImageTask = URLSession.shared.dataTask(with: getRawImageRequest, completionHandler: {data, response, error in
                    guard let data = data else { print("Image data corupted"); return}
                    print("Done")
                    guard let image = UIImage(data: data) else { print("UIImage corupted"); return}
                    print("Done")
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                })
                getRawImageTask.resume()
                
            } catch { print(error) }
        })
        getPhotoTask.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoto()
    }

    func getPhoto() {
        let photoURL = URL(string: "https://api.unsplash.com/photos/\(imageID!)?")
        var request = URLRequest(url: photoURL!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let resultPhoto = try JSONDecoder().decode(Photo.self, from: data)
                let imageURL = URL(string: "\(resultPhoto.urls.full)")
                var imageRequest = URLRequest(url: imageURL!)
                imageRequest.httpMethod = "GET"
                
                let imageTask = URLSession.shared.dataTask(with: imageRequest, completionHandler: {data, response, error in
                    guard let resultImage = data else { return }
                    DispatchQueue.main.async {
                        self.photo.image = UIImage(data: resultImage)
                        self.authorName.text = resultPhoto.user.name
                    }
                })
                
                imageTask.resume()
            } catch {
                print(error)
            }
        })
        task.resume()
    }
}
