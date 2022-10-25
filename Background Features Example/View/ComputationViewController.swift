//
//  ComputationViewController.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 15/10/22.
//

import UIKit

class ComputationViewController: UIViewController {
    let computationViewModel: ComputationViewModel = ComputationViewModel()
    @IBOutlet weak var beginLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var computationLabel: UILabel!
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
            self?.computationLabelHandler()
        })
    }
    
    @IBAction func playPauseComputation(_ sender: UIButton) -> Void {
        self.computationViewModel.beginPauseComputation()
        self.beginLabelHandler()
        self.playPauseButtonHandler()
    }
}

extension ComputationViewController {
    func beginLabelHandler() -> Void {
        self.beginLabel.text = self.computationViewModel.isTaskExecuting ? "Stop Task" : "Begin Task"
    }
    
    func playPauseButtonHandler() -> Void {
        let imageName =  self.computationViewModel.isTaskExecuting ? "pause" : "play"
        self.playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func computationLabelHandler() -> Void {
        self.computationLabel.text = self.computationViewModel.isTaskExecuting ? self.computationViewModel.resultMessage : ComputationViewModel.initialMessage
    }
}
