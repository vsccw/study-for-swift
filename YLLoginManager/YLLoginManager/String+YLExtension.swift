extension String {
    var yl_deletingPathExtension: String {
        if self.yl_hasPathExtension {
            return (self as NSString).deletingPathExtension
        }
        return self
    }
    
    var yl_hasPathExtension: Bool {
        return !(self as NSString).pathExtension.isEmpty
    }
    
    var yl_pathExtension: String {
        if self.yl_hasPathExtension {
            return (self as NSString).pathExtension
        }
        return ""
    }
    
    func yl_appendExtension(_ exten: String) -> String {
        let str = self
        return str.appending(".").appending(exten)
    }
    
    func yl_appendPathComponent(_ component: String) -> String {
        let str = self as NSString
        return str.appending("/").appending(component)
    }
}
