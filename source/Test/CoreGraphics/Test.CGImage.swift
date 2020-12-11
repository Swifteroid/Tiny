import AppKit
import Foundation
import Nimble
import Quick
import Tiny

internal class CGImageExtensionSpec: QuickSpec {
    override internal func spec() {
        it("can be resized") {
            let nsImage: NSImage = NSImage(size: CGSize(width: 640, height: 360), flipped: true, drawingHandler: { NSColor.red.setFill(); $0.fill(); return true })
            let cgImage: CGImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            let originalSize = cgImage.size

            expect(originalSize) == CGSize(width: 640, height: 360)
            expect(cgImage.resize(to: originalSize / 3).size) == round(originalSize / 3)
        }
    }
}
