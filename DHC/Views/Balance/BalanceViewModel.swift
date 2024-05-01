//
//  BalanceViewModel.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import Foundation
import CoreMotion
import SwiftUI
import AVFoundation

class BalanceViewModel: ObservableObject {
    private var motionManager = CMMotionManager()
    private var balanceManager = BalanceManager()
    @Published var gyroData: (x: Double, y: Double, z: Double) = (0, 0, 0)
    private var allGyroData: [(x: Double, y: Double, z: Double)] = []
    private var initialGyroData: (x: Double, y: Double, z: Double)? = nil
    private let threshold: Double = 0.5
    
    func startGyroscope() {
        motionManager.gyroUpdateInterval = 1.0 / 60.0
        motionManager.startGyroUpdates(to: .main) { [weak self] (gyroData, error) in
            guard let data = gyroData else { return }
            let currentData = (data.rotationRate.x, data.rotationRate.y, data.rotationRate.z)
            if self?.initialGyroData == nil {
                self?.initialGyroData = currentData
            }
            self?.allGyroData.append(currentData)
            self?.gyroData = currentData
            self?.checkThreshold(currentData)
        }
    }

    func checkThreshold(_ currentData: (x: Double, y: Double, z: Double)) {
        guard let initialData = initialGyroData else { return }
        let distance = sqrt(pow(currentData.x - initialData.x, 2) +
                            pow(currentData.y - initialData.y, 2) +
                            pow(currentData.z - initialData.z, 2))
        if distance > threshold {
            DispatchQueue.main.async {
                self.playSound()
            }
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
    func playSound() {
        let systemSoundID: SystemSoundID = 1005
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
