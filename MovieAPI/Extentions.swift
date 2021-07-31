//
//  Extentions.swift
//  MovieAPI
//
//  Created by ryan on 7/30/21.
//

import UIKit

extension UIView {

    func addShadow() {
         layer.shadowColor = UIColor.black.cgColor
         layer.shadowOffset = CGSize(width: 5, height: 5)
         layer.shadowRadius = 4
         layer.shadowOpacity = 0.4
     }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data)?.jpegData(compressionQuality: 0.3) {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: image)
                    }
                }
            }
        }
    }
}

extension UITableView {
    func setEmptyMessage(message: String, size: CGFloat) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}

extension UIViewController {
    func setupGradientLayer(fromColor start: UIColor, toColor end: UIColor) {
        let gradient =  CAGradientLayer()
        gradient.colors = [start.cgColor, end.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
    }
}
