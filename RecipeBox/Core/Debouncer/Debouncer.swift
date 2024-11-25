//
//  Debouncer.swift
//  RecipeBox
//
//  Created by Tatarella on 22.11.24.
//

import Foundation

class Debouncer {
    private var timer: Timer?
    private let delay: TimeInterval
    private let work: () -> Void

    init(delay: TimeInterval, work: @escaping () -> Void) {
        self.delay = delay
        self.work = work
    }

    func call() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.work()
        }
    }
}
