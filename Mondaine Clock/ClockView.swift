import SwiftUI

struct ClockView: View {
    @Environment(\.colorScheme) var colorScheme // 检测系统主题
    @State private var currentTime = CurrentTime()

    var body: some View {
        ZStack {
            // 背景图像
            Image(colorScheme == .dark ? "BG_Dark" : "BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // 表盘
            Image(colorScheme == .dark ? "ClockFace_Dark" : "ClockFace")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.92)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

            // 时钟指示器
            Image(colorScheme == .dark ? "ClockIndicator_Dark" : "ClockIndicator")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.85)
                .offset(y: 6)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)

            // 时针
            Image(colorScheme == .dark ? "HOURBAR_Dark" : "HOURBAR")
                .resizable()
                .frame(width: 50, height: 433.87)
                .rotationEffect(Angle.degrees(currentTime.hoursAngle))
                .scaleEffect(0.92)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .animation(.linear(duration: 0.5), value: currentTime.hoursAngle)

            // 分针
            Image(colorScheme == .dark ? "MINBAR_Dark" : "MINBAR")
                .resizable()
                .frame(width: 50, height: 711)
                .scaleEffect(0.92)
                .rotationEffect(Angle.degrees(currentTime.minutesAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .animation(.linear(duration: 0.5), value: currentTime.minutesAngle)

            // 秒针
            Image(colorScheme == .dark ? "REDINDICATOR_Dark" : "REDINDICATOR")
                .resizable()
                .frame(width: 383.77, height: 579.36)
                .scaleEffect(0.92)
                .offset(y: -1)
                .rotationEffect(Angle.degrees(currentTime.secondsAngle))
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                .animation(.linear(duration: currentTime.secondsAngleAnimationDuration), value: currentTime.secondsAngle)
        }
        .onAppear(perform: startClock)
    }

    func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentTime = CurrentTime()
        }
    }
}

struct CurrentTime {
    var hoursAngle: Double
    var minutesAngle: Double
    var secondsAngle: Double
    var secondsAngleAnimationDuration: Double

    init() {
        let calendar = Calendar.current
        let date = Date()

        let hours = Double(calendar.component(.hour, from: date) % 12) + Double(calendar.component(.minute, from: date)) / 60.0
        let minutes = Double(calendar.component(.minute, from: date)) + Double(calendar.component(.second, from: date)) / 60.0
        let seconds = Double(calendar.component(.second, from: date))

        self.hoursAngle = (hours / 12.0) * 360.0
        self.minutesAngle = (minutes / 60.0) * 360.0

        if seconds >= 59 {
            self.secondsAngle = (seconds - 60) / 60.0 * 360.0
            self.secondsAngleAnimationDuration = 2.0
        } else {
            self.secondsAngle = (seconds / 60.0) * 360.0
            self.secondsAngleAnimationDuration = 1.0
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
    }
}
