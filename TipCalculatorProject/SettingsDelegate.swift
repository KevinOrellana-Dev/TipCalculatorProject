//
//  SettingsDelegate.swift
//  raft5
//
//  Created by admin on 1/22/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
protocol SettingsDelegate {
    func setDefaultTipIndex(value: Int)
    func setRememberCustomTip(value: Bool)
}
