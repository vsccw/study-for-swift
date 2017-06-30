extension String {
    var deletingPathExtension: String {
        if self.hasPathExtension {
            return (self as NSString).deletingPathExtension
        }
        return self
    }
    
    var hasPathExtension: Bool {
        return !(self as NSString).pathExtension.isEmpty
    }
    
    func appendExtension(_ exten: String) -> String {
        let str = self
        return str.appending(".").appending(exten)
    }
    
    func appendPathComponent(_ component: String) -> String {
        let str = self as NSString
        return str.appending("/").appending(component)
    }
}
