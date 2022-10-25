//
//  RefreshViewController.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 15/10/22.
//

import UIKit
import Foundation

class RefreshViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLabel.text = "Never"
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
            self?.getBackgroundPerformedTaskStatus()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    func getBackgroundPerformedTaskStatus() -> Void {
        let result = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastRefreshDateKey)
        self.statusLabel.text = result
    }
}
