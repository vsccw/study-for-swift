import AVFoundation
import CoreTelephony

@objc
public class YLAudioManager: NSObject {
    
    // MARK: - Public property
    public static let manager = YLAudioManager()
    public var audioFormat: YLAudioFormat {
        set {
            YLAudioRecorderManager.default.audioFormat = newValue
        }
        get {
            return self.audioFormat
        }
    }

    public var recordMinDuration: TimeInterval = 1.0
    public var recordMaxDuration: Int = 60 {
        didSet {
            YLAudioRecorderManager.default.recordMaxDuration = recordMaxDuration
        }
    }
    
    /// 来电话而且正在录音时的处理，默认取消录音
    public var callIncomingHandler: ((_ isCallingIn: Bool) -> Void)? = { _ in
        if YLAudioManager.manager.isRecroding {
            YLAudioRecorderManager.default.cancelRecord(completion: { _ in
            })
            YLAudioPlayerManager.default.stopPlaying()
        }
    }
    public var callDialingHandler: (() -> Void)?
    public var callConnectedHandler: (() -> Void)?
    public var callDisconnectedHandler: (() -> Void)?
    public var convertToAmrHandler:((_ filePath: String) -> String)?
    public var remainSecondsHandler: ((_ seconds: Int) -> Void)?
    
    // MARK: - Private property
    fileprivate var recordStartDate: Date!
    fileprivate var recordEndDate: Date!
    fileprivate var currentActiveState = false
    fileprivate var timer: Timer?
    fileprivate var currentCategory = ""
    fileprivate let callCenter = CTCallCenter()
    
    fileprivate override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(YLAudioManager.proximitySensorStateChange(notification:)), name: .UIDeviceProximityStateDidChange, object: nil)
        audioFormat = YLAudioFormat.aac
        
        callCenter.callEventHandler = { [weak self] call in
            switch call.callState {
            case CTCallStateDialing:
                self?.callDialingHandler?()
            case CTCallStateIncoming:
                self?.callIncomingHandler?(true)
            case CTCallStateConnected:
                self?.callConnectedHandler?()
            case CTCallStateDisconnected:
                self?.callDisconnectedHandler?()
            default:
                break
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Audio player
    public var isAudioPlaying: Bool {
        return YLAudioPlayerManager.default.isPlaying
    }
    
    public var audioPlayingDuration: TimeInterval {
        return YLAudioPlayerManager.default.duration
    }
    
    public func startPlayAudio(withPath path: String, completion: ((Error?) -> Void)?) {
        var isNeedSetActive = true
        if isAudioPlaying {
            YLAudioPlayerManager.default.stopPlaying()
            isNeedSetActive = false
        }
        
        if isNeedSetActive {
            setCategory(category: AVAudioSessionCategoryPlayback, active: true)
        }
        
        var wavFilePath = ""
        if isAAC(withPath: path) || isLinearPCM(withPath: path) {
            wavFilePath = path
            enableProximitySensor()
            YLAudioPlayerManager.default.play(withPath: wavFilePath) { [weak self] (error) in
                self?.setCategory(category: AVAudioSessionCategoryAmbient, active: false)
                self?.disableProximitySensor()
                if completion != nil {
                    completion?(error)
                }
            }
        }
        else if isAMR(withPath: path) {
            /// convert to amr
            if let handler = convertToAmrHandler {
                wavFilePath = handler(path)
                enableProximitySensor()
                YLAudioPlayerManager.default.play(withPath: wavFilePath) { [weak self] (error) in
                    self?.setCategory(category: AVAudioSessionCategoryAmbient, active: false)
                    self?.disableProximitySensor()
                    if completion != nil {
                        completion?(error)
                    }
                }
            }
        }
        else {
            let error = YLAudioError.filePathNotExist("file path does not exit")
            if completion != nil {
                completion?(error)
            }
            setCategory(category: AVAudioSessionCategoryAmbient, active: false)
            return
        }
    }
    
    public func stopPlayAudio() {
        if isAudioPlaying {
            YLAudioPlayerManager.default.stopPlaying()
        }
        setCategory(category: AVAudioSessionCategoryAmbient, active: false)
    }
    
    // MARK: - Audio recorder
    public func startRecord(withFileName fileName: String, completion: ((Error?) -> Void)?) {
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
        audioRecorderManager.startRecord(withPath: recordPath.yl.appendPathComponent(fileName), completion: completion)
    }
    
    public func stopRecord(withCompletion completion: ((_ recordPath: String?, _ duration: TimeInterval, _ error: Error?) -> Void)?) {
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
    
    public func cancelRecord() {
        YLAudioRecorderManager.default.cancelRecord()
    }
    
    public func pauseRecord() {
        YLAudioRecorderManager.default.pauseRecord()
    }
    
    public func resumeRecord() {
        YLAudioRecorderManager.default.resumeRecord()
    }
    
    public var isRecroding: Bool {
        return YLAudioRecorderManager.default.isRecording
    }
    
    // MARK: - Public property
    public var isMicrophoneAvailable: Bool {
        var _granted = false
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { (granted) in
            _granted = granted
        }
        return _granted
    }
    
    public var peekRecorderVoiceMeter: Double {
        return YLAudioRecorderManager.default.peekRecorderVoiceMeter
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
