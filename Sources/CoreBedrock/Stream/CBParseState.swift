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
