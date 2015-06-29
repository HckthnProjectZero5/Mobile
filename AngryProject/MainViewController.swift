//
//  MainViewController.swift
//  AngryProject
//
//  Created by jpk on 6/27/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImage = UIImage(named: "sketchBg.jpg")
        bgImageView.image = bgImage

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
