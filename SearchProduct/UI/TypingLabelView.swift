//
//  TypingLabelView.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 13/07/2024.
//

import Foundation
import UIKit

final class TypingLabelView: UIView {
    
    private let label = UILabel()
    private var timer: Timer?
    private var currentText: String = ""
    private var fullText: String = ""
    private var characterIndex = 0
    private var typingSpeed: TimeInterval = 0.1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    private func setupLabel() {
        label.frame = bounds
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Courier-New", size: 100)
        label.textColor = BagifyTheme.lightPink

        addSubview(label)
    }

    func startTypingAnimation(text: String, typingSpeed: TimeInterval = 0.1) {
        self.typingSpeed = typingSpeed
        fullText = text
        currentText = ""
        characterIndex = 0
        label.text = ""

        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: typingSpeed, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
    }

    @objc private func updateText() {
        if characterIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: characterIndex)
            currentText += String(fullText[index])
            label.text = currentText
            characterIndex += 1
        } else {
            resetAnimation()
        }
    }

    private func resetAnimation() {
        currentText = ""
        characterIndex = 0
        label.text = ""
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: typingSpeed, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
    }

    func stopTypingAnimation() {
        timer?.invalidate()
        timer = nil
    }
}
