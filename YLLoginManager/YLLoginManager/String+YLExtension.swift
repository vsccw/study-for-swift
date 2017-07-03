//extension String {
//    var yl_deletingPathExtension: String {
//        if self.yl_hasPathExtension {
//            return (self as NSString).deletingPathExtension
//        }
//        return self
//    }
//    
//    var yl_hasPathExtension: Bool {
//        return !(self as NSString).pathExtension.isEmpty
//    }
//    
//    var yl_pathExtension: String {
//        if yl_hasPathExtension {
//            return (self as NSString).pathExtension
//        }
//        return ""
//    }
//    
//    func yl_appendExtension(_ exten: String) -> String {
//        let str = self
//        return str.appending(".").appending(exten)
//    }
//    
//    func yl_appendPathComponent(_ component: String) -> String {
//        let str = self as NSString
//        return str.appending("/").appending(component)
//    }
//}


class AudioManager<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

protocol AudioManagerCompatible {
    associatedtype CompatibleType
    var yl: CompatibleType { get }
}

extension AudioManagerCompatible {
    public var yl: AudioManager<Self> {
        get { return AudioManager(self) }
    }
}
extension String: AudioManagerCompatible { }

extension AudioManager where Base == String {
 
    var deletingPathExtension: String {
        if base.yl.hasPathExtension {
            return (base as NSString).deletingPathExtension
        }
        return base
    }
    
    var hasPathExtension: Bool {
        return !(base as NSString).pathExtension.isEmpty
    }
    
    var pathExtension: String {
        if base.yl.hasPathExtension {
            return (base as NSString).pathExtension
        }
        return ""
    }
    
    func appendPathComponent(_ component: String) -> String {
        let str = base
        return str.appending("/").appending(component)
    }
    
    func appendExtension(_ exten: String) -> String {
        let str = base
        return str.appending(".").appending(exten)
    }
}
