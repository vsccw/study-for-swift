
public enum YLAudioError: Error {
    case filePathNotExist(String)
    case audioPlayerDecodeError(String)
    case microphoneUnavailable(String)
    case currentRecorderNotOver(String)
    case recorderIsNotStarted(String)
    case recorderDurationTooShort(String)
    case invalidFormat(String)
}

