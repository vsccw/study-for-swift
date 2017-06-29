
import AVFoundation

extension YLAudioManager {
    
    // MARK: - Public
    func enableProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
    }
    
    func disableProximitySensor() {
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = false
    }
    
    var currentProximityEnabled: Bool {
        let device = UIDevice.current
        return device.isProximityMonitoringEnabled
    }
    
    func proximitySensorStateChange(notification: NotificationCenter) {
        let device = UIDevice.current
        let audioSession = AVAudioSession.sharedInstance()
        var category = AVAudioSessionCategoryPlayback
        if device.proximityState == true  {
            category = AVAudioSessionCategoryPlayAndRecord
        }
        
        do {
            try audioSession.setCategory(category)
        }
        catch let error {
            print(error)
        }
    }
}
