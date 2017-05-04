import Foundation


public func example(of: String, action: () -> Void) {
  print("--------\(of) example---------")
  action()
  print("\n")
}
