//
//  ComputationViewModel.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 15/10/22.
//

import SwiftUI
import UIKit

class ComputationViewModel {
    static let initialMessage: String = "Fibonacci Computations"
    static let maxValue = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
    var isTaskExecuting: Bool = false
    var resultMessage: String = initialMessage
    private var previous: NSDecimalNumber = NSDecimalNumber.one
    private var current: NSDecimalNumber = NSDecimalNumber.one
    private var position: UInt = 1
    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func beginPauseComputation() -> Void {
        self.isTaskExecuting.toggle()
        if self.isTaskExecuting {
            self.resetCalculation()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
                self?.calculateNextNumber()
            })
        } else {
            self.timer?.invalidate()
            self.timer = nil
            self.resultMessage = Self.initialMessage
        }
    }
    
    private func resetCalculation() -> Void {
        self.previous = .one
        self.current = .one
        self.position = 1
    }
    
    private func calculateNextNumber() -> Void {
        let result = self.current.adding(self.previous)
        if result.compare(Self.maxValue) == .orderedAscending {
            self.previous = self.current
            self.current = result
            self.position += 1
        } else {
            self.resetCalculation()
        }
        self.resultMessage = "Position \(self.position) = \(self.current)"
            switch UIApplication.shared.applicationState {
            case .background:
                let timeRemaining = UIApplication.shared.backgroundTimeRemaining
                if timeRemaining < Double.greatestFiniteMagnitude {
                    let secondsRemaining = String(format: "%.1f seconds remaining", timeRemaining)
                    print("App is in background - \(self.resultMessage) - \(secondsRemaining)")
                }
            default:
                break
        }
    }
}

extension ComputationViewModel {
    // MARK: background handlers
    private func registerBackgroundTask() -> Void {
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            print("iOS has signaled time has expired")
            self?.endBackgroundTaskIfActive()
        })
    }
    
    private func endBackgroundTaskIfActive() -> Void {
        let isBackgroundTaskActive = self.backgroundTask != .invalid
        if isBackgroundTaskActive {
            print("Background task ended.")
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
    
    func onChangeScenePhase(withScenePhase scenePhase: ScenePhase) -> Void {
        switch scenePhase {
            case .background:
                let timerIsRunning = self.timer != nil
                let isTaskUnregistered = self.backgroundTask != .invalid
                if timerIsRunning && isTaskUnregistered {
                    self.registerBackgroundTask()
                }
                break
            case .active:
                self.endBackgroundTaskIfActive()
                break
            default:
                break
        }
    }
}
