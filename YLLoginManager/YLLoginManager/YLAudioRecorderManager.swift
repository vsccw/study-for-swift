import AVFoundation


typealias RecorderCompletion = (String?) -> Void

class YLAudioRecorderManager: NSObject {
    // MARK: - Public property
    static let `default` = YLAudioRecorderManager()
    
    var audioRecorder: AVAudioRecorder?
    var audioFormat = YLAudioFormat.aac {
        didSet {
            audioRecorderSetting[AVFormatIDKey] = audioFormat.format
        }
    }
    
    var isRecording: Bool {
        if let audioRecorder = audioRecorder {
            return audioRecorder.isRecording
        }
        return false
    }
    
    var peekRecorderVoiceMeter: Double {
        var ret = 0.0
        guard let recorder = YLAudioRecorderManager.default.audioRecorder else {
            return ret
        }
        recorder.updateMeters()
        if recorder.isRecording {
            ret = Double(pow(10, 0.05 * recorder.peakPower(forChannel: 0)))
        }
        return ret
    }
    
    var audioRecorderSetting = [String: Any]()
    
    var recordCompletion: RecorderCompletion?
    
    fileprivate override init() {
        super.init()
        audioRecorderSetting = [AVSampleRateKey: 8000.0,
                                AVFormatIDKey: audioFormat.format,
                                AVLinearPCMBitDepthKey: 16,
                                AVNumberOfChannelsKey: 1]
    }
    
    func startRecord(withPath path: String, completion: ((Error?) -> Void)?) {
        let wavFilePath = path.yl.deletingPathExtension.yl.appendExtension(audioFormat.subExtension)
        guard let wavURL = URL(string: wavFilePath) else {
            fatalError("the wav file path does not exit.")
        }
        do {
            try audioRecorder = AVAudioRecorder(url: wavURL, settings: audioRecorderSetting)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.delegate = self

            audioRecorder?.record()
            
            if completion != nil {
                completion?(nil)
            }
        }
        catch let error {
            completion?(error)
            return
        }
    }
    
    func stopRecord(completion: RecorderCompletion?) {
        audioRecorder?.stop()
        recordCompletion = completion
    }
    
    func cancelRecord(completion: RecorderCompletion? = nil) {
        audioRecorder?.delegate = nil
        if let audioRecorder = audioRecorder,
            audioRecorder.isRecording {
            self.stopRecord(completion: completion)
            audioRecorder.deleteRecording()
        }
        audioRecorder = nil
        recordCompletion = nil
    }
    
    func pauseRecord() {
        if let audioRecorder = audioRecorder,
            audioRecorder.isRecording {
            audioRecorder.pause()
        }
    }
    
    func resumeRecord() {
        if let audioRecorder = audioRecorder,
            !audioRecorder.isRecording {
            audioRecorder.record()
        }
    }
}

extension YLAudioRecorderManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let path: String = recorder.url.path
        if recordCompletion != nil {
            if flag {
                recordCompletion?(path)
            }
            else {
                recordCompletion?(nil)
            }
        }
        audioRecorder = nil
        recordCompletion = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        audioRecorder = nil
    }
}
