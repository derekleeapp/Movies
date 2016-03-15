import Foundation

private let oneMicroSecond: NSTimeInterval = 0.000_001

extension NSRunLoop {
    static func advance(by timeInterval: NSTimeInterval = oneMicroSecond) {
        let stopDate = NSDate().dateByAddingTimeInterval(timeInterval)
        mainRunLoop().runUntilDate(stopDate)
    }
}

extension String {
    func utf8EncodedData() -> NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
