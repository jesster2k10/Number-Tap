//
//  ShareImageViewController.swift
//  Number Tap Universal
//
//  Created by Jesse on 23/10/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

import UIKit

class ShareImageViewController: UIViewController {
    var shareImage = UIImage()
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareImageView.image = shareImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
