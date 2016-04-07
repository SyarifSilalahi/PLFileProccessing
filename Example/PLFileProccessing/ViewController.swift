//
//  ViewController.swift
//  PLFileProccessing
//
//  Created by Syarif Silalahi on 04/06/2016.
//  Copyright (c) 2016 Syarif Silalahi. All rights reserved.
//

import UIKit
import PLFileProccessing

class ViewController: UIViewController {
    @IBOutlet var imgLoaded: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PLFileProccessing().loadAsyncImage("http://cdn3-i.hitc-s.com/151/dota_2_terrorblade_47771.jpg") { (img:UIImage) in
            self.imgLoaded.image = img
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

