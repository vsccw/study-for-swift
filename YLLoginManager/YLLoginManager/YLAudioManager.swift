import AVFoundation

class YLAudioManager: NSObject {
    
    // MARK: - Public property
    static let manager = YLAudioManager()
    
    // MARK: - Private property
    fileprivate var recordStartDate: Date!
    fileprivate var recordEndDate: Date!
    fileprivate let recordMinDuration: TimeInterval = 1.0
    fileprivate var currentActiveState = false
    fileprivate var currentCategory = ""
    
    fileprivate override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(YLAudioManager.proximitySensorStateChange(notification:)), name: .UIDeviceProximityStateDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Audio player
    var isAudioPlaying: Bool {
        guard let audioPlayer = YLAudioPlayerManager.default.audioPlayer else {
            return false
        }
        return audioPlayer.isPlaying
    }
    
    func startPlayAudio(withPath path: String, completion: ((Error?) -> Void)?) {
        var isNeedSetActive = true
        if isAudioPlaying {
            YLAudioPlayerManager.default.stopPlaying()
            isNeedSetActive = false
        }
        
        if isNeedSetActive {
            setCategory(category: AVAudioSessionCategoryPlayback, active: true)
        }
        
        let wavFilePath = path.deletingPathExtension.appendExtension("aac")
        let fm = FileManager.default
        if !fm.fileExists(atPath: wavFilePath) {
            let error = YLAudioError.filePathNotExist("file path does not exit")
            if completion != nil {
                completion?(error)
            }
            setCategory(category: AVAudioSessionCategoryAmbient, active: false)
            return
        }
        enableProximitySensor()
        YLAudioPlayerManager.default.play(withPath: wavFilePath) { [weak self] (error) in
            self?.setCategory(category: AVAudioSessionCategoryAmbient, active: false)
            self?.disableProximitySensor()
            if completion != nil {
                completion?(error)
            }
        }
    }
    
    func stopPlayAudio() {
        if isAudioPlaying {
            YLAudioPlayerManager.default.stopPlaying()
        }
        setCategory(category: AVAudioSessionCategoryAmbient, active: false)
    }
    
    // MARK: - Audio recorder
    func startRecord(withFileName fileName: String, completion: ((Error?) -> Void)?) {
        if !isMicrophoneAvailable {
            let error = YLAudioError.microphoneUnavailable("麦克风不可用")
            completion?(error)
            return
        }
        let audioRecorderManager = YLAudioRecorderManager.default
        if isRecroding {
            let error = YLAudioError.currentRecorderNotOver("当前的录音没有结束")
            completion?(error)
            return
        }
        
        if fileName.isEmpty {
            let error = YLAudioError.filePathNotExist("路径不存在")
            completion?(error)
        }
        if isRecroding {
            audioRecorderManager.cancelRecord()
        }
        setCategory(category: AVAudioSessionCategoryRecord, active: true)
        
        recordStartDate = Date()
        let homeDirectory = NSHomeDirectory()
        let recordPath = homeDirectory.appending("/Library/appdata/chatbuffer/recorderfiles")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: recordPath) {
            do {
                try fileManager.createDirectory(atPath: recordPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                completion?(error)
                return
            }
        }
        audioRecorderManager.startRecord(withPath: recordPath.appendPathComponent(fileName), completion: completion)
    }
    
    func stopRecord(withCompletion completion: ((_ recordPath: String?, _ duration: TimeInterval, _ error: Error?) -> Void)?) {
        if !isRecroding, completion != nil {
            let error = YLAudioError.recorderIsNotStarted("录音尚未开始")
            completion?(nil, 0, error)
            return
        }
        recordEndDate = Date()
        let duration = recordEndDate.timeIntervalSince(recordStartDate)
        if duration < recordMinDuration {
            if completion != nil {
                let error = YLAudioError.recorderDurationTooShort("录音时间过短")
                completion?(nil, 0, error)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + recordMinDuration) { [weak self] in
                YLAudioRecorderManager.default.stopRecord(completion: { (recordPath) in
                    self?.setCategory(category: AVAudioSessionCategoryAmbient, active: false)
                })
            }
            return
        }
        YLAudioRecorderManager.default.stopRecord { [weak self] (recordPath) in
            
            self?.setCategory(category: AVAudioSessionCategoryAmbient, active: false)
            
            if completion != nil {
                completion?(recordPath, duration, nil)
            }
        }
    }
    
    var isRecroding: Bool {
        guard let audioRecorder = YLAudioRecorderManager.default.audioRecorder else {
            return false
        }
        return audioRecorder.isRecording
    }
    
    // MARK: - Public property
    var isMicrophoneAvailable: Bool {
        var _granted = false
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (granted) in
            _granted = granted
        }
        return _granted
    }
    
    var peekRecorderVoiceMeter: Double {
        var ret = 0.0
        guard let recorder = YLAudioRecorderManager.default.audioRecorder else {
            return ret
        }
        if recorder.isRecording {
            ret = Double(pow(10, 0.05 * recorder.peakPower(forChannel: 0)))
        }
        return ret
    }
    
    // MARK: - Private function
    fileprivate func setCategory(category: String, active: Bool) {
        let audioSession = AVAudioSession.sharedInstance()
        var isNeedSetActive = false
        if active != currentActiveState {
            isNeedSetActive = true
        }
        do {
            if currentCategory != category {
                try audioSession.setCategory(category)
            }
            if isNeedSetActive {
                try audioSession.setActive(active, with: .notifyOthersOnDeactivation)
            }
        }
        catch let error {
            print(error)
        }
        currentCategory = category
        currentActiveState = active
    }
}
