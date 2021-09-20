//
//  TextFieldAlertViewController.swift
//  RememberFaces
//
//  Created by Roman Kavinskyi on 7/5/21.
//

import SwiftUI
import Combine

final class TextFieldAlertViewController: UIViewController {

    init(title: String, message: String?, text: Binding<String>, placeholder: String, isPresented: Binding<Bool>?) {
        self.alertTitle  = title
        self.message     = message
        self._text       = text
        self.placeholder = placeholder
        
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Dependencies
    private let alertTitle    : String
    private let message       : String?
    @Binding private var text : String
    private let placeholder : String
    private var isPresented   : Binding<Bool>?
    
    // MARK: - Private Properties
    private var subscription  : AnyCancellable?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertController()
    }
    
    private func presentAlertController() {
        let vc = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        vc.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            textField.autocorrectionType = .default
            textField.keyboardType = .default
            textField.placeholder = self.placeholder
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let input = vc.textFields?.first?.text, !input.isEmpty {
                self.text = input
            }
            self.isPresented?.wrappedValue = false
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.isPresented?.wrappedValue = false
        }
        
        vc.addAction(action)
        vc.addAction(cancel)
        present(vc, animated: true, completion: nil)
    }
}
