//
//  ViewController.swift
//  AlbumArt
//
//  Created by Joe E. on 10/13/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import AFNetworking

typealias Dictionary = [String:AnyObject]

class AlbumsViewController: UIViewController, UISearchBarDelegate {
    
    var albumInfo: Album!
    var albumPicture: Album!
    
    let albumData = AlbumsDataSource()

    @IBOutlet weak var albumSearchBar: UISearchBar!
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumSearchBar.delegate = self
        
        albumsCollectionView.dataSource = albumData
        
        albumData.searchForAlbum("jimi hendrix") { () -> () in
            self.albumsCollectionView.reloadData()
            
        }
    
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            albumData.searchForAlbum(searchText) { () -> () in
                self.albumsCollectionView.reloadData()
                
            }
            
            searchBar.resignFirstResponder()
            
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! AlbumCell
        
        let detailVC = segue.destinationViewController as! AlbumDetailViewController
        
        detailVC.albumInfo = cell.albumInfo
        
    }
    
}

class AlbumsDataSource: NSObject, UICollectionViewDataSource {
    
    var albums: [Album] = []
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        let album = albums[indexPath.item]
        cell.albumInfo = album
        
        cell.albumImageView.image = album.albumImage ?? album.getImage() // if we have already downloaded the album, we are going to use that one. otherwise, we are going to donwload the image
        
        return cell
    }
    
    let requestManager = AFHTTPRequestOperationManager()
    
    func searchForAlbum(named:String, completion: () -> ()) {
        albums = []
        
        let nameStripped = named.stringByReplacingOccurrencesOfString(" ", withString:"+")
        let urlString = "https://itunes.apple.com/search?term=" + nameStripped + "&media=music&entity=album"
        
        requestManager.GET(urlString, parameters: nil, success: { (operation, data) -> Void in
            
            if let foundInfo = data as? [String:AnyObject] {
                if let results = foundInfo["results"] as? [Dictionary] {
                    for result in results {
                        let album = Album(info: result)
                        self.albums.append(album)
                        
                    }
                    
                    completion()
                    
                }
                
            }
            
            }) { (operation, error) -> Void in
                print(error)
            
        }
        
    }
    
}

class Album: NSObject {
    var artistName: String?
    var albumArtURL: String?
    var albumImage: UIImage?
    
    var albumID: Int?
    var albumName: String?
    var itunesLink: String?
    var isNotExplicit: Bool?
    var albumPrice: Double?
    
    init(info: Dictionary) {
        artistName = info["artistName"] as? String
        albumArtURL = info["artworkUrl100"] as? String
        albumID = info["collectionId"] as? Int
        albumName = info["collectionName"] as? String
        itunesLink = info["collectionViewUrl"] as? String
        isNotExplicit = info["collectionExplicitness"] as? String ?? "" != "notExplicit"
        albumPrice = Double(info["collectionPrice"] as? String ?? "0.00")
        
    }
    
    func getImage() -> UIImage? {
        if let imageURL = NSURL(string: albumArtURL ?? "") {
            if let imageData = NSData(contentsOfURL: imageURL) {
                albumImage = UIImage(data: imageData)
                return albumImage

            }
            
        }
        
        return nil
        
    }
    
}