//
//  ImageDetailViewController.swift
//  Splashpaper
//
//  Created by Damian Mikołajczak on 14/06/2021.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var image: UIImage?
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        // Do any additional setup after loading the view.
    }

}
