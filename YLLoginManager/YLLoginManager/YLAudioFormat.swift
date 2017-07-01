
import AVFoundation

@objc
public class YLAudioFormat: NSObject, RawRepresentable {
    public let rawValue: UInt8

    required public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public static let aac = YLAudioFormat(rawValue: 1)
    public static let m4a = YLAudioFormat(rawValue: 2)
    public static let wav = YLAudioFormat(rawValue: 3)
}

public extension YLAudioFormat {
    public var format: UInt32 {
        switch rawValue {
        case 1:
            return kAudioFormatMPEG4AAC
        case 2:
            return kAudioFormatMPEG4AAC
        case 3:
            return kAudioFormatLinearPCM
        default:
            return kAudioFormatLinearPCM
        }
    }
    
    public var subExtension: String {
        switch rawValue {
        case 1:
            return "aac"
        case 2:
            return "m4a"
        case 3:
            return "wav"
        default:
            return "wav"
        }
    }
}
