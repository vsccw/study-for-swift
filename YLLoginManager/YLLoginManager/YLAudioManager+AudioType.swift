
import AudioToolbox

public extension YLAudioManager {
    
    public func audioType(withPath filePath: String) -> UInt32 {
        let pathToFile = filePath as CFString
        let inputFileUrl: CFURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, pathToFile, CFURLPathStyle.cfurlposixPathStyle, false)
        var inputFile: ExtAudioFileRef? = nil
        let err = ExtAudioFileOpenURL(inputFileUrl, &inputFile)
        if err != 0 {
            return 0
        }
        
        var fileDescription: AudioStreamBasicDescription? = AudioStreamBasicDescription()
        var propertySize = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        ExtAudioFileGetProperty(inputFile!, kExtAudioFileProperty_FileDataFormat, &propertySize, &fileDescription)
        
        return fileDescription?.mFormatID ?? 0
    }
    
    /// 该类型是否是: wav
    public func isLinearPCM(withPath filePath: String) -> Bool {
        let type = audioType(withPath: filePath)
        return type == kAudioFormatLinearPCM
    }
    
    /// 该类型是否是: aac
    public func isAAC(withPath filePath: String) -> Bool {
        let type = audioType(withPath: filePath)
        return type == kAudioFormatMPEG4AAC
    }
    
    /// 该类型是否是: amr
    public func isAMR(withPath filePath: String) -> Bool {
        let type = audioType(withPath: filePath)
        return type == kAudioFormatAMR
    }
}
