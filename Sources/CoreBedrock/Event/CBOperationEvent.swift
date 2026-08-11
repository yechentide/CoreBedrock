//
// Created by yechentide on 2026/04/11
//

public enum CBOperationEvent<
    Progress: Sendable,
    Warning: Sendable,
    PartialResult: Sendable,
    Completion: Sendable
>: Sendable {
    case progress(Progress)
    case warning(Warning)
    case partialResult(PartialResult)
    case completed(Completion)
}
