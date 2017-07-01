
import AVFoundation

public extension YLAudioManager {
    
    // MARK: - Public
    public func enableProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
    }
    
    public func disableProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
    }
    
    public var currentProximityEnabled: Bool {
        let device = UIDevice.current
        return device.isProximityMonitoringEnabled
    }
    
    internal func proximitySensorStateChange(notification: NotificationCenter) {
        let device = UIDevice.current
        let audioSession = AVAudioSession.sharedInstance()
        var category = AVAudioSessionCategoryPlayback
        if device.proximityState == true  {
            category = AVAudioSessionCategoryPlayAndRecord
        }
        else {
            category = AVAudioSessionCategoryPlayback
        }
        do {
            try audioSession.setCategory(category)
        }
        catch let error {
            print(error)
        }
    }
}
