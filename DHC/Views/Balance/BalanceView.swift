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
    @Binding var isPresented: Bool
    @State private var remainingSeconds = 30
    @State private var timer: Timer?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Remaining: \(remainingSeconds) sec")
                .font(.largeTitle)
                .padding()

            ProgressView(value: Double(30 - remainingSeconds), total: 30)
                .progressViewStyle(.linear)
                .frame(width: 300, height: 20)

            Button("Start Measure Balance") {
                startMeasurement()
            }
            .padding()
            .disabled(timer != nil)

            Button("Stop") {
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
        let systemSoundID: SystemSoundID = 1003
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
