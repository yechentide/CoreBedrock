//
// Created by yechentide on 2024/06/02
//

enum CBParseState {
    case atStreamBeginning
    case atCompoundBeginning
    case inCompound
    case atCompoundEnd
    case atListBeginning
    case inList
    case atStreamEnd
    case error
}
