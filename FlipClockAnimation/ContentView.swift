//
//  ContentView.swift
//  FlipClockAnimation
//
//  Created by 香饽饽zizizi on 2024/2/15.
//

import SwiftUI

struct ContentView: View {
    @State private var hour = 0
    @State private var minute = 0
    @State private var second = 0
    @State private var amOrPm = "AM"

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            HStack {
                FlipNumbeView(current: hour)
                    .overlay(alignment: .topLeading) {
                        Text(amOrPm)
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .offset(CGSize(width: 10.0, height: 10.0))
                    }
                FlipNumbeView(current: minute)
                FlipNumbeView(current: second)
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { v in
            hour = Calendar.current.component(.hour, from: v + 1)
            minute = Calendar.current.component(.minute, from: v + 1)
            second = Calendar.current.component(.second, from: v + 1)
            amOrPm = hour < 12 ? "AM" : "PM"
        })
        .onAppear {
            let v = Date.now
            hour = Calendar.current.component(.hour, from: v + 1)
            minute = Calendar.current.component(.minute, from: v + 1)
            second = Calendar.current.component(.second, from: v + 1)
            amOrPm = hour < 12 ? "AM" : "PM"
        }
    }
}

extension Int {
    func toDisplay() -> String {
        if self >= 0 && self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

struct FlipAnimate {
    var flip1: Double = 0
    var flip2: Double = 90
}

struct FlipNumbeView: View {
    var current: Int = 0

    var body: some View {
        let curr = current.toDisplay()
        let prev = ((current - 1 + 60) % 60).toDisplay()

        KeyframeAnimator(initialValue: FlipAnimate(), trigger: current) { values in
            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(.bg)
                    .overlay {
                        Text(curr)
                            .font(.system(size: 120))
                            .foregroundStyle(.white)
                    }
                    .frame(height: 240)
                    .mask {
                        Rectangle()
                            .frame(height: 120)
                            .offset(y: -60)
                    }

                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(.bg)
                    .overlay {
                        Text(prev)
                            .font(.system(size: 120))
                            .foregroundStyle(.white)
                    }
                    .frame(height: 240)
                    .mask {
                        Rectangle()
                            .frame(height: 120)
                            .offset(y: -60)
                    }
                    .rotation3DEffect(
                        .degrees(values.flip1),
                        axis: (x: -1.0, y: 0.0, z: 0.0)
                    )

                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(.bg)
                    .overlay {
                        Text(prev)
                            .font(.system(size: 120))
                            .foregroundStyle(.white)
                    }
                    .frame(height: 240)
                    .mask {
                        Rectangle()
                            .frame(height: 120)
                            .offset(y: 60)
                    }

                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(.bg)
                    .overlay {
                        Text(curr)
                            .font(.system(size: 120))
                            .foregroundStyle(.white)
                    }
                    .frame(height: 240)
                    .mask {
                        Rectangle()
                            .frame(height: 120)
                            .offset(y: 60)
                    }
                    .rotation3DEffect(
                        .degrees(values.flip2),
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                    )

            }
            .overlay {
                Rectangle()
                    .fill(.black)
                    .frame(height: 3)
            }
        } keyframes: { _ in
            KeyframeTrack(\.flip1) {
                LinearKeyframe(90, duration: 0.2)
            }
            KeyframeTrack(\.flip2) {
                LinearKeyframe(90, duration: 0.2)
                LinearKeyframe(0, duration: 0.12)
            }
        }

    }
}

#Preview {
    ContentView()
}
