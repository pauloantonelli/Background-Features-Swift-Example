//
//  AudioViewModel.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 13/10/22.
//

import UIKit

class AudioViewController: UIViewController {
    private var audioViewModel: AudioViewModel!
    private var timer: Timer?
    @IBOutlet weak var playPauseTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicTimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.audioViewModel = AudioViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.musicTimerLabelHandler()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        self.audioViewModel.playPauseAudio()
        self.playPauseTitleHandler()
        self.playPauseImageHandler()
        self.musicTitleHandler()
    }
    
    @IBAction func goToPreviousSong(_ sender: UIButton) {
        self.audioViewModel.goToPreviousSong()
    }
    
    @IBAction func goToNextSong(_ sender: UIButton) {
        self.audioViewModel.goToNextSong()
    }
    
    
    func gotoLocationScreen() -> Void {
        let locationViewController = LocationViewController()
        navigationController?.pushViewController(locationViewController, animated: true)
    }
}
extension AudioViewController {
    func playPauseTitleHandler() -> Void {
        let name: String = self.audioViewModel.isPlaying ? "Pause" : "Play"
        self.playPauseTitle.text = name
    }
    
    func playPauseImageHandler() -> Void {
        let imageName: String = self.audioViewModel.isPlaying ? "pause" : "play"
        self.playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func musicTitleHandler() -> Void {
        self.musicTitle.text = self.audioViewModel.itemTitle
    }
    
    func musicTimerLabelHandler() -> Void {
        self.musicTimerLabel.text = TimerFormatterHelper.formatter.string(from: self.audioViewModel.timer)
    }
}
