//
//  BalanceView.swift
//  DHC
//
//  Created by Lab on 25.04.2024.
//

import SwiftUI
import AVFoundation

struct BalanceView: View {
    @ObservedObject var viewModel: BalanceViewModel
    @State private var remainingSeconds = 30
    @State private var timer: Timer?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Kalan Süre: \(remainingSeconds) saniye")
                .font(.largeTitle)
                .padding()

            Text("X: \(viewModel.gyroData.x)")
            Text("Y: \(viewModel.gyroData.y)")
            Text("Z: \(viewModel.gyroData.z)")

            ProgressView(value: Double(30 - remainingSeconds), total: 30)
                .progressViewStyle(.linear)
                .frame(width: 300, height: 20)

            Button("Dengeyi Ölçmeyi Başlat") {
                startMeasurement()
            }
            .padding()
            .disabled(timer != nil)

            Button("Ölçümü Durdur") {
                stopMeasurement()
            }
            .padding()
            .disabled(timer == nil)
        }
    }

    func startMeasurement() {
        viewModel.startGyroscope()
        remainingSeconds = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopMeasurement()
                playSound()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func stopMeasurement() {
        timer?.invalidate()
        timer = nil
        viewModel.stopGyroscope()
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "soundName", withExtension: "wav") else { return }
        var sound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
}
