//
//  AlbumDetailViewController.swift
//  AlbumArt
//
//  Created by Joe E. on 10/13/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AFNetworking

class AlbumDetailViewController: UIViewController {
    var albumInfo: Album!
    var tracks: [Track] = []
    
    let tracksData = TracksDataSource()

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tracksTableView.dataSource = tracksData
    
        albumNameLabel.text = albumInfo.albumName
        albumImageView.image = albumInfo.albumImage ?? albumInfo.getImage()
        albumImageView.contentMode = .ScaleAspectFit
        
        if let albumID = albumInfo.albumID {
            print(albumID)
            tracksData.FindTracksForAlbum("\(albumID)", completion: { () -> () in
                self.tracksTableView.reloadData()
                
            })
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
}

class TracksDataSource: NSObject, UITableViewDataSource {
    var tracks: [Track] = []
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        let track = tracks[indexPath.row]
        
        cell.trackInfo = track
        cell.trackNameLabel.text = track.trackName
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    let requestManager = AFHTTPRequestOperationManager()
    
    func FindTracksForAlbum(albumID: String, completion: () -> ()) {
        tracks = []
        
        let urlString = "https://itunes.apple.com/lookup?id=\(albumID)&entity=song"
        print(urlString)
        
        requestManager.GET(urlString, parameters: nil, success: { (operation, data) -> Void in
            if let foundInfo = data as? [String:AnyObject] {
                if let results = foundInfo["results"] as? [Dictionary] {
                    for result in results {
                        if result["trackName"] != nil {
                            let track = Track(info: result)
                            self.tracks.append(track)
                        }
                        
                    }
                    
                    completion()
                    
                }
                
            }
            
            }) { (operation, error) -> Void in
                print(error)
                
        }
        
    }
    
}

class Track: NSObject {
    var trackNumber: Int?
    var trackName: String?
    var trackPrice: Double?
    var mediaURL: String?
    var mediaData: NSData?
    var trackViewURL: String?
    
    init(info:Dictionary) {
        trackName = info["trackName"] as? String
        trackNumber = info["trackNumber"] as? Int
        trackPrice = info["trackPrice"] as? Double
        mediaURL = info["previewUrl"] as? String
        trackViewURL = info["trackViewUrl"] as? String 
    
    }
    
    func getMedia() -> NSData? {
        if let mediaURLString = NSURL(string: mediaURL ?? "") {
            mediaData = NSData(contentsOfURL: mediaURLString)
            return mediaData
            
        }
        
        return nil
        
    }


}
