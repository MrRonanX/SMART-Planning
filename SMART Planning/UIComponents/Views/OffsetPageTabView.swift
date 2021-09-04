//
//  OffsetPageTabView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 8/29/21.
//

import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    @Binding var offset: CGFloat
    var screenWidth: CGFloat
    var content: Content
    
    init(offset: Binding<CGFloat>, screenWidth: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.content        = content()
        self._offset        = offset
        self.screenWidth    = screenWidth
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let hostView = UIHostingController(rootView: content)
        scrollView.addSubview(hostView.view)
        hostView.view.pinToEdges(of: scrollView)
        hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let currentOffset = uiView.contentOffset.x
        
        if currentOffset < 0 {
            uiView.isScrollEnabled = false
            uiView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            uiView.isScrollEnabled = true
        }

        if currentOffset > screenWidth * 5 {
            uiView.isScrollEnabled = false
            uiView.setContentOffset(CGPoint(x: screenWidth * 5, y: 0), animated: true)
            uiView.isScrollEnabled = true
        }
        
        if currentOffset != offset {
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: OffsetPageTabView
        
        init(_ parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            parent.offset = offset
        }
    }
}
