//
//  ClockViewController.swift
//  Mondaine Clock
//
//  Created by Steve Wang on 8/8/24.
//

import UIKit

class ClockViewController: UIViewController {

    var timer: Timer?
    var elapsedSeconds: CGFloat = 0.0;

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BG"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let hourHandImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "HOURBAR"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let minuteHandImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MINBAR"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let secondHandImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "REDINDICATOR"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTheme() // 设置主题

        view.addSubview(backgroundImageView)
        view.addSubview(hourHandImageView)
        view.addSubview(minuteHandImageView)
        view.addSubview(secondHandImageView)

        setupConstraints()
        startClock()
    }

    func setupTheme() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        if userInterfaceStyle == .dark {
            backgroundImageView.image = UIImage(named: "BG_Dark")
            hourHandImageView.image = UIImage(named: "HOURBAR_Dark")
            minuteHandImageView.image = UIImage(named: "MINBAR_Dark")
            secondHandImageView.image = UIImage(named: "REDINDICATOR_Dark")
        } else {
            backgroundImageView.image = UIImage(named: "BG")
            hourHandImageView.image = UIImage(named: "HOURBAR")
            minuteHandImageView.image = UIImage(named: "MINBAR")
            secondHandImageView.image = UIImage(named: "REDINDICATOR")
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupTheme() // 在系统主题变化时更新主题
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor),

            hourHandImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hourHandImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hourHandImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.02),
            hourHandImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            minuteHandImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minuteHandImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            minuteHandImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.015),
            minuteHandImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            secondHandImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondHandImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            secondHandImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.01),
            secondHandImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
        ])
    }

    func startClock() {
        updateClockHands()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClockHands), userInfo: nil, repeats: true)
    }

    @objc func updateClockHands() {
        elapsedSeconds += 1.0
        
        if elapsedSeconds <= 60.0 {
            let secondsAngle = (elapsedSeconds / 60.0) * 2.0 * CGFloat.pi
            secondHandImageView.transform = CGAffineTransform(rotationAngle: secondsAngle)
        } else if elapsedSeconds == 60.0 {
            let calendar = Calendar.current
            let date = Date()
            let minutes = CGFloat(calendar.component(.minute, from: date))
            let nextMinuteAngle = ((minutes + 1) / 60.0) * 2.0 * CGFloat.pi

            UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
                self.minuteHandImageView.transform = CGAffineTransform(rotationAngle: nextMinuteAngle)
            }) { _ in
                self.elapsedSeconds = 0.0 // Reset to start new minute cycle
            }
        } else {
            secondHandImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
    }

    deinit {
        timer?.invalidate()
    }
}
