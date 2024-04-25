//
//  BalanceViewModel.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import Foundation
import CoreMotion
import SwiftUI

class BalanceViewModel: ObservableObject {
    private var motionManager = CMMotionManager()
    private var balanceManager = BalanceManager()
    @Published var gyroData: (x: Double, y: Double, z: Double) = (0, 0, 0)
    private var allGyroData: [(x: Double, y: Double, z: Double)] = []

    func startGyroscope() {
        motionManager.gyroUpdateInterval = 1.0 / 60.0
        motionManager.startGyroUpdates(to: .main) { [weak self] (gyroData, error) in
            guard let data = gyroData else { return }
            let currentData = (data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
            self?.allGyroData.append(currentData)
            self?.gyroData = currentData
        }
    }

    func stopGyroscope() {
        motionManager.stopGyroUpdates()
        saveDataToFirebase()
    }

    func saveDataToFirebase() {
        for data in allGyroData {
            balanceManager.saveGyroscopeData(x: data.x, y: data.y, z: data.z)
        }
        allGyroData.removeAll()
    }
}
