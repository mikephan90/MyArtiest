//
//  PlaybackPresenter.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/16/24.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource : AnyObject {
    var songName: String? { get }
    var artistName: String? { get }
    var imageUrl: URL? { get }
}

final class PlaybackPresenter {
    
    // MARK: - Properties
    
    static let shared = PlaybackPresenter()
    
    var playerVC: PlayerViewController?
    
    var audioPlayer: AVPlayer?
    
    private var track: AudioTrack?
    
    private var tracks = [AudioTrack]() // if album is selected
    
    private var currentTrack: AudioTrack? // refernce to current track for album play
    
    // MARK: - Methods
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        
        self.track = track
 
        guard let url = URL(string: track.preview_url ?? "") else { return }
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.volume = getSystemOutputVolume()
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.audioPlayer?.play()
        }
        vc.refreshUI()
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let audioPlayer {
            if audioPlayer.timeControlStatus == .paused {
                audioPlayer.play()
            } else if audioPlayer.timeControlStatus == .playing {
                audioPlayer.pause()
            }
        }
    }
    
    func didTapNext() {
        print("tapped Next")
    }
    
    func didTapBack() {
        print("tapped back")
    }
    
    
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return track?.name
    }
    
    var artistName: String? {
        return track?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: track?.album?.images.first?.url ?? "")
    }
}
