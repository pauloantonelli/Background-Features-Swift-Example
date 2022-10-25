//
//  TimerFormatter.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 13/10/22.
//

import Foundation

class TimerFormatterHelper {
   static let formatter: DateComponentsFormatter = {
      let formatter = DateComponentsFormatter()
      formatter.unitsStyle = .positional
      formatter.allowedUnits = [.minute, .second]
      formatter.zeroFormattingBehavior = .pad
      return formatter
    }()
}
