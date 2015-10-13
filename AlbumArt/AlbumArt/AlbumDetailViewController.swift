//
//  AlbumDetailViewController.swift
//  AlbumArt
//
//  Created by Joe E. on 10/13/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    var albumInfo: Album!

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumNameLabel.text = albumInfo.albumName
        albumImageView.image = albumInfo.albumImage ?? albumInfo.getImage()
        albumImageView.contentMode = .ScaleAspectFit
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

    }
    


    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
