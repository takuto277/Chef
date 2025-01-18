//
//  KeyboardMonitor.swift
//  Chef
//
//  Created by 小野拓人 on 2025/01/18.
//

import SwiftUI
import Combine

final class KeyboardMonitor: ObservableObject {
    static let shared = KeyboardMonitor()
    @Published var isKeyboardVisible: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = true
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = false
            }
            .store(in: &cancellables)
    }
}
