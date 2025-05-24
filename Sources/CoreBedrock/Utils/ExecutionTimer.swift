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
        for name in timers.keys.sorted() {
            let entry = timers[name]!
            let formattedTotal = format(entry.totalElapsed)
            print("[\(name)] Total: \(formattedTotal)")
        }
    }

    public func start(_ processName: String = #function) {
        var entry = timers[processName] ?? TimerEntry()
        entry.startTime = CFAbsoluteTimeGetCurrent()
        timers[processName] = entry
        lastProcessName = processName
    }

    public func stop(_ processName: String? = nil, showMessage: Bool = true) {
        let nameToUse = processName ?? lastProcessName

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
        timers[name] = entry

        if showMessage {
            let formattedElapsed = format(elapsed)
            let formattedTotal = format(entry.totalElapsed)
            print("[\(name)] Execution Time: \(formattedElapsed), Total: \(formattedTotal)")
        }
    }

    public func reset(_ processName: String) {
        timers.removeValue(forKey: processName)
    }

    public func resetAll() {
        timers.removeAll()
        lastProcessName = nil
    }

    private func format(_ time: CFAbsoluteTime) -> String {
        if time >= 1.0 {
            return "\(String(format: "%.3f", time)) s"
        } else {
            return "\(String(format: "%.3f", time * 1000)) ms"
        }
    }
}
