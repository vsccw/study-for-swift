import AVFoundation

class YLAudioPlayerManager: NSObject {
    static let `default` = YLAudioPlayerManager()
    
    var audioPlayer: AVAudioPlayer?
    
    var duration: TimeInterval {
        if let audioPlayer = audioPlayer {
            return audioPlayer.duration
        }
        return 0
    }
    
    var isPlaying: Bool {
        if let audioPlayer = audioPlayer {
            return audioPlayer.isPlaying
        }
        return false
    }
    
    fileprivate var finishedHandler: ((Error?) -> Void)?
    
    func play(withPath filePath: String, completion: ((Error?) -> Void)?) {
        self.finishedHandler = completion

        guard let wavUrl = URL(string: filePath) else {
            let error = YLAudioError.filePathNotExist("file path does not exit")
            if finishedHandler != nil {
                finishedHandler?(error)
            }
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: wavUrl)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch let error {
            if finishedHandler != nil {
                finishedHandler?(error)
            }
        }
    }
    
    func stopPlaying() {
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
            audioPlayer.delegate = nil
            self.audioPlayer = nil
        }
        
        if finishedHandler != nil {
            finishedHandler = nil
        }
    }
    
    func pausePlaying() {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
        }
    }
}


extension YLAudioPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if finishedHandler != nil {
            let error = YLAudioError.audioPlayerDecodeError("audio player decode error did occur")
            finishedHandler?(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if finishedHandler != nil {
            finishedHandler?(nil)
        }
        if let audioPlayer = self.audioPlayer {
            audioPlayer.delegate = nil
            self.audioPlayer = nil
        }
        
    }
}
