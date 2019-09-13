//
//  GifVC.swift
//  CCMN
//
//  Created by Ganna DANYLOVA on 9/9/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import UIKit

class GifVC: UIViewController {
    
    @IBOutlet weak var gifImage: UIImageView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
//        let navigationBarAppearace = UINavigationBar.appearance()
        
//        navigationBarAppearace.tintColor = .black
//        navigationBarAppearace.barTintColor = .black
//        self.navigationController?.navigationBar.backgroundColor = .black
//        self.tabBarController?.tabBar.barTintColor = UIColor.brown
        gifImage.loadGif(name: "space")
        self.view.addBackground()
        
    }
}

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "YOUR IMAGE NAME GOES HERE")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}
