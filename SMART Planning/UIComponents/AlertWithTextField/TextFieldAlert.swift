//
//  TextFieldAlert.swift
//  RememberFaces
//
//  Created by Roman Kavinskyi on 7/5/21.
//

import SwiftUI

struct TextFieldAlert {
    
    // MARK: Properties
    let title: String
    let message: String?
    @Binding var text: String
    let placeholder: String
    var isPresented: Binding<Bool>? = nil
    
    // MARK: Modifiers
    func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(title: title, message: message, text: $text, placeholder: placeholder, isPresented: isPresented)
    }
}

extension TextFieldAlert: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = TextFieldAlertViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
        TextFieldAlertViewController(title: title, message: message, text: $text, placeholder: placeholder, isPresented: isPresented)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: UIViewControllerRepresentableContext<TextFieldAlert>) {}
}


struct TextFieldWrapper<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert
    let dismissAction: () -> Void
    
    var body: some View {
        ZStack {
            if isPresented { content().dismissable($isPresented) }
            presentingView
            
        }.onChange(of: isPresented) { value in
            if !value { dismissAction() }
        }
    }
}


extension View {
    func textFieldAlert(isPresented: Binding<Bool>,
                        onDismiss: @escaping () -> Void,
                        content: @escaping () -> TextFieldAlert )  -> some View {
        TextFieldWrapper(isPresented: isPresented,
                         presentingView: self,
                         content: content, dismissAction: onDismiss)
    }
}


