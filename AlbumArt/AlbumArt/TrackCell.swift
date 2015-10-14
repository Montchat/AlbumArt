//
//  TrackCell.swift
//  AlbumArt
//
//  Created by Joe E. on 10/13/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import SVGPlayButton
import AVFoundation

class TrackCell: UITableViewCell {
    
    var trackInfo: Track! {
        didSet {
            
            if let price = trackInfo.trackPrice {
                buyButton.setTitle("$\(price)", forState: .Normal)
                
            } else {
                buyButton.hidden = true
                
            }
            
        }
        
    }

    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var playbutton: SVGPlayButton!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBAction func pressedPlayButton(sender: AnyObject) {
        print("pressed")
        
    }
    
    @IBAction func pressedBuyButton(sender: AnyObject) {
        
        if let urlString = trackInfo.trackViewURL {
            if let url = NSURL(string: urlString) {
                UIApplication.sharedApplication().openURL(url)
                    
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //this is a great time to setup the button
        
        playbutton.progressTrackColor = UIColor.lightGrayColor()
        playbutton.progressColor = UIColor.darkGrayColor()
        playbutton.playColor = UIColor.grayColor()
        playbutton.pauseColor = UIColor.grayColor()
        
        playbutton.willPlay = { self.willPlayHandler() }
        playbutton.willPause = { self.willPauseHandler() }
        
    }
    
    var player: AVAudioPlayer?
    
    private func willPlayHandler() {
        print("WillPlay")
        
        if let data = trackInfo.mediaData ?? trackInfo.getMedia() {
            player = player ?? (try? AVAudioPlayer(data: data))
            
        }
        
        player?.play()
        
    }
    
    private func willPauseHandler() {
        print("willPause")
        player?.pause()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
