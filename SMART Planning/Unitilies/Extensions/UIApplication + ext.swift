//
//  UIApplication + ext.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/21/21.
//

import UIKit

extension UIApplication {
    func addTapGestureRecognizer() {
        guard
            let windowScene = connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
