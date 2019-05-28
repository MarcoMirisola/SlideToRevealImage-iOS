//
//  ViewController.swift
//  SlideToRevealImage-iOS
//
//  Created by MarcoMirisola on 05/28/2019.
//  Copyright (c) 2019 MarcoMirisola. All rights reserved.
//

import UIKit
import SlideToRevealImage

class ViewController: UIViewController {
    
    @IBOutlet weak var slideToRevealView: SlideToRevealImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        slideToRevealView.setBaseImage(image: UIImage(named: "image")!)
        slideToRevealView.addImage(image: UIImage(named: "image_bw_1")!, thumb: UIImage(named: "scroll")!, startPercentage: 25)
        slideToRevealView.addImage(image: UIImage(named: "image_bw_2")!, thumb: UIImage(named: "scroll")!, startPercentage: 50)
        slideToRevealView.addImage(image: UIImage(named: "image_bw_3")!, thumb: UIImage(named: "scroll")!, startPercentage: 75)
        slideToRevealView.initialize()
    }
}
