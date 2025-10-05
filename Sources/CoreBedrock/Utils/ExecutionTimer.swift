//
// Created by yechentide on 2025/05/09
//

import Foundation

public final actor ExecutionTimer {
    public struct TimerEntry {
        var startTime: CFAbsoluteTime?
        var totalElapsed: CFAbsoluteTime = 0
    }

    public static let shared = ExecutionTimer()

    private var timers: [String: TimerEntry] = [:]
    private var lastProcessName: String?

    public func showTimers() {
        print("========== ========== ==========")
        for name in self.timers.keys.sorted() {
            let entry = self.timers[name]!
            let formattedTotal = self.format(entry.totalElapsed)
            print("[\(name)] Total: \(formattedTotal)")
        }
    }

    public func start(_ processName: String = #function) {
        var entry = self.timers[processName] ?? TimerEntry()
        entry.startTime = CFAbsoluteTimeGetCurrent()
        self.timers[processName] = entry
        self.lastProcessName = processName
    }

    public func stop(_ processName: String? = nil, showMessage: Bool = true) {
        let nameToUse = processName ?? self.lastProcessName

        guard let name = nameToUse else {
            if showMessage {
                print("[ExecutionTimer] No process name provided and no previous process recorded.")
            }
            return
        }
        guard var entry = timers[name], let start = entry.startTime else {
            if showMessage {
                print("[\(name)] Timer was not started.")
            }
            return
        }

        let elapsed = CFAbsoluteTimeGetCurrent() - start
        entry.totalElapsed += elapsed
        entry.startTime = nil
        self.timers[name] = entry

        if showMessage {
            let formattedElapsed = self.format(elapsed)
            let formattedTotal = self.format(entry.totalElapsed)
            print("[\(name)] Execution Time: \(formattedElapsed), Total: \(formattedTotal)")
        }
    }

    public func reset(_ processName: String) {
        self.timers.removeValue(forKey: processName)
    }

    public func resetAll() {
        self.timers.removeAll()
        self.lastProcessName = nil
    }

    private func format(_ time: CFAbsoluteTime) -> String {
        if time >= 1.0 {
            "\(String(format: "%.3f", time)) s"
        } else {
            "\(String(format: "%.3f", time * 1000)) ms"
        }
    }
}
