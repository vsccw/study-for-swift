import Foundation

public func exampleOf(desc: String, action: (Void) -> Void) {
    print("example: \(desc) begin.")
    action()
    print("example: \(desc) end")
}
