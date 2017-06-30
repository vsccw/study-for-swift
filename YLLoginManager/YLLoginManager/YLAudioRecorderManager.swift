import AVFoundation


typealias RecorderCompletion = (String?) -> Void

class YLAudioRecorderManager: NSObject {
    // MARK: - Public property
    static let `default` = YLAudioRecorderManager()
    
    var audioRecorder: AVAudioRecorder?
    
    var audioRecorderSetting: [String: Any] {
        return [AVSampleRateKey: 8000.0,
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVLinearPCMBitDepthKey: 16,
                AVNumberOfChannelsKey: 1]
    }
    
    var recordCompletion: RecorderCompletion?
    
    fileprivate override init() {
        super.init()
    }
    
    func startRecord(withPath path: String, completion: ((Error?) -> Void)?) {
        let wavFilePath = path.deletingPathExtension.appendExtension("aac")
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
    
    func cancelRecord() {
        audioRecorder?.delegate = nil
        if let audioRecorder = audioRecorder,
            audioRecorder.isRecording {
            audioRecorder.stop()
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
        
    }
}
