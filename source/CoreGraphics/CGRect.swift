import CoreGraphics

extension CGRect {
    /// Initializes new rectangle by finding the difference between two points.
    public init(point point1: CGPoint, point point2: CGPoint) {
        self.init(x: min(point1.x, point2.x), y: min(point1.y, point2.y), width: abs(point2.x - point1.x), height: abs(point2.y - point1.y))
    }
}

/// Anchor points, setting these resizes the rectangle in the given direction, changing center points resizes rectangle 
/// in both ways on axis it sits on, exception is center point itself – changing it simply adjusts origin.
extension CGRect {
    public var topLeft: CGPoint {
        get { CGPoint(x: self.minX, y: self.minY) }
        mutating set {
            self.size.width -= newValue.x - self.minX
            self.size.height -= newValue.y - self.minY
            self.origin = newValue
        }
    }

    public var topRight: CGPoint {
        get { CGPoint(x: self.maxX, y: self.minY) }
        mutating set {
            self.size.width += newValue.x - self.maxX
            self.size.height -= newValue.y - self.minY
            self.origin = newValue.translating(x: -self.width)
        }
    }

    public var bottomLeft: CGPoint {
        get { CGPoint(x: self.minX, y: self.maxY) }
        mutating set {
            self.size.width -= newValue.x - self.minX
            self.size.height += newValue.y - self.maxY
            self.origin = newValue.translating(y: -self.height)
        }
    }

    public var bottomRight: CGPoint {
        get { CGPoint(x: self.maxX, y: self.maxY) }
        mutating set {
            self.size.width += newValue.x - self.maxX
            self.size.height += newValue.y - self.maxY
            self.origin = newValue.translating(x: -self.width, y: -self.height)
        }
    }

    public var center: CGPoint {
        get { CGPoint(x: self.midX, y: self.midY) }
        mutating set {
            self.origin = newValue.translating(x: -self.width / 2, y: -self.height / 2)
        }
    }

    public var centerLeft: CGPoint {
        get { CGPoint(x: self.minX, y: self.midY) }
        mutating set {
            let diff = newValue.y - self.midY
            self.size.width -= newValue.x - self.minX
            self.size.height -= diff * 2
            self.origin = newValue.translating(y: -self.height / 2 - diff)
        }
    }

    public var centerRight: CGPoint {
        get { CGPoint(x: self.maxX, y: self.midY) }
        mutating set {
            let diff = newValue.y - self.midY
            self.size.width += newValue.x - self.maxX
            self.size.height -= diff * 2
            self.origin = newValue.translating(x: -self.width, y: -self.height / 2 - diff)
        }
    }

    public var centerTop: CGPoint {
        get { CGPoint(x: self.midX, y: self.minY) }
        mutating set {
            let diff = newValue.x - self.midX
            self.size.width -= diff * 2
            self.size.height -= newValue.y - self.minY
            self.origin = newValue.translating(x: -self.width / 2 - diff)
        }
    }

    public var centerBottom: CGPoint {
        get { CGPoint(x: self.midX, y: self.maxY) }
        mutating set {
            let diff = newValue.x - self.midX
            self.size.width -= diff * 2
            self.size.height += newValue.y - self.maxY
            self.origin = newValue.translating(x: -self.width / 2 - diff, y: -self.height)
        }
    }
}

/// Alignment.
extension CGRect {
    public func aligned(innerLeft rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: rectangle.minX + (margin ?? 0), y: self.origin.y), size: self.size) }
    public func aligned(outerLeft rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: rectangle.minX - (margin ?? 0) - self.width, y: self.origin.y), size: self.size) }

    public func aligned(innerRight rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: rectangle.maxX - (margin ?? 0) - self.width, y: self.origin.y), size: self.size) }
    public func aligned(outerRight rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: rectangle.maxX + (margin ?? 0), y: self.origin.y), size: self.size) }

    public func aligned(innerTop rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: self.origin.x, y: rectangle.minY + (margin ?? 0)), size: self.size) }
    public func aligned(outerTop rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: self.origin.x, y: rectangle.minY - (margin ?? 0) - self.height), size: self.size) }

    public func aligned(innerBottom rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: self.origin.x, y: rectangle.maxY - (margin ?? 0) - self.height), size: self.size) }
    public func aligned(outerBottom rectangle: CGRect, margin: CGFloat? = nil) -> CGRect { CGRect(origin: CGPoint(x: self.origin.x, y: rectangle.maxY + (margin ?? 0)), size: self.size) }

    public func aligned(center rectangle: CGRect) -> CGRect { self.centered(in: rectangle) }

    public func centered(at point: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: point.x - self.width / 2, y: point.y - self.height / 2), size: self.size) }
    public func centered(in rectangle: CGRect) -> CGRect { CGRect(origin: CGPoint(x: rectangle.origin.x + (rectangle.width - self.width) / 2, y: rectangle.origin.y + (rectangle.height - self.height) / 2), size: self.size) }
    public func centered(horizontally rectangle: CGRect) -> CGRect { CGRect(origin: CGPoint(x: rectangle.origin.x + (rectangle.width - self.width) / 2, y: self.origin.y), size: self.size) }
    public func centered(vertically rectangle: CGRect) -> CGRect { CGRect(origin: CGPoint(x: self.origin.x, y: rectangle.origin.y + (rectangle.height - self.height) / 2), size: self.size) }
}

/// Containment, returns rectangle contained inside the specified one if width and height are not greater than
/// of one specified, in which case returns `nil`.
extension CGRect {
    public func contained(in rectangle: CGRect) -> CGRect? {
        self.contained(horizontally: rectangle)?.contained(vertically: rectangle)
    }

    public func contained(horizontally rectangle: CGRect) -> CGRect? {
        if self.width > rectangle.width {
            return nil
        } else if self.minX < rectangle.minX {
            return self.aligned(innerLeft: rectangle)
        } else if self.maxX > rectangle.maxX {
            return self.aligned(innerRight: rectangle)
        } else {
            return self
        }
    }

    public func contained(vertically rectangle: CGRect) -> CGRect? {
        if self.height > rectangle.height {
            return nil
        } else if self.minY < rectangle.minY {
            return self.aligned(innerTop: rectangle)
        } else if self.maxY > rectangle.maxY {
            return self.aligned(innerBottom: rectangle)
        } else {
            return self
        }
    }
}

/// Translating.
extension CGRect {
    /// Translates the rectangle origin along x axis by the given distance.
    public mutating func translate(x: CGFloat) { self.origin.translate(x: x) }

    /// Translates the rectangle origin along y axis by the given distance.
    public mutating func translate(y: CGFloat) { self.origin.translate(y: y) }

    /// Translates the rectangle origin along y and y axis by the given distance.
    public mutating func translate(x: CGFloat, y: CGFloat) { self.origin.translate(x: x, y: y) }

    /// Translates the rectangle origin along y and y axis by the given distance.
    public mutating func translate(_ distance: CGFloat) { self.origin.translate(x: distance, y: distance) }

    /// Translates the rectangle origin along y and y axis by the given distance.
    public mutating func translate(_ point: CGPoint) { self.origin.translate(point) }

    /// Translates the rectangle origin by the given distance in direction defined by the angle in radians.
    public mutating func translate(distance: CGFloat, angle: CGFloat) { self.origin.translate(distance: distance, angle: angle) }


    /// Returns the rectangle with origin translated along x axis by the given distance.
    public func translating(x: CGFloat) -> CGRect { CGRect(origin: self.origin.translating(x: x), size: self.size) }

    /// Returns the rectangle with origin translated along y axis by the given distance.
    public func translating(y: CGFloat) -> CGRect { CGRect(origin: self.origin.translating(y: y), size: self.size) }

    /// Returns the rectangle with origin translated along y and y axis by the given distance.
    public func translating(x: CGFloat, y: CGFloat) -> CGRect { CGRect(origin: self.origin.translating(x: x, y: y), size: self.size) }

    /// Returns the rectangle with origin translated along y and y axis by the given distance.
    public func translating(_ distance: CGFloat) -> CGRect { CGRect(origin: self.origin.translating(x: distance, y: distance), size: self.size) }

    /// Returns the rectangle with origin translated along y and y axis by the given distance.
    public func translating(_ point: CGPoint) -> CGRect { CGRect(origin: self.origin.translating(point), size: self.size) }

    /// Returns the rectangle with origin translated by the given distance in direction defined by the angle in radians.
    public func translating(distance: CGFloat, angle: CGFloat) -> CGRect { CGRect(origin: self.origin.translating(distance: distance, angle: angle), size: self.size) }
}

/// Scaling.
extension CGRect {
    /// Scales the rectangle horizontally and vertically by the given amount around the specified pivot point.
    public mutating func scale(width ws: CGFloat, height hs: CGFloat, pivot: CGPoint? = nil) {
        if let pivot: CGPoint = pivot { self.origin.translate((self.origin - pivot).scaling(x: ws - 1, y: hs - 1)) }
        self.size.scale(width: ws, height: hs)
    }

    /// Scales the rectangle horizontally by the given amount around the specified pivot point.
    public mutating func scale(width ws: CGFloat, pivot: CGPoint? = nil) {
        if let pivot: CGPoint = pivot { self.origin.translate((self.origin - pivot).scaling(x: ws - 1)) }
        self.size.scale(width: ws)
    }

    /// Scales the rectangle vertically by the given amount around the specified pivot point.
    public mutating func scale(height hs: CGFloat, pivot: CGPoint? = nil) {
        if let pivot: CGPoint = pivot { self.origin.translate((self.origin - pivot).scaling(y: hs - 1)) }
        self.size.scale(height: hs)
    }

    /// Scales the rectangle by the given amount around the specified pivot point.
    public mutating func scale(_ scale: CGFloat, pivot: CGPoint? = nil) { self.scale(width: scale, height: scale, pivot: pivot) }

    /// Scales the rectangle by the given amount around the specified pivot point.
    public mutating func scale(_ scale: CGPoint, pivot: CGPoint? = nil) { self.scale(width: scale.x, height: scale.y, pivot: pivot) }

    /// Scales the rectangle by the given amount around the specified pivot point.
    public mutating func scale(_ scale: CGSize, pivot: CGPoint? = nil) { self.scale(width: scale.width, height: scale.height, pivot: pivot) }


    /// Returns the rectangle scaled horizontally and vertically by the given amount around the specified pivot point.
    public func scaling(width ws: CGFloat, pivot: CGPoint? = nil) -> CGRect {
        let origin: CGPoint? = pivot.map({ self.origin.translating((self.origin - $0).scaling(x: ws - 1)) })
        return CGRect(origin: origin ?? self.origin, size: self.size.scaling(width: ws))
    }

    /// Returns the rectangle scaled horizontally by the given amount around the specified pivot point.
    public func scaling(height hs: CGFloat, pivot: CGPoint? = nil) -> CGRect {
        let origin: CGPoint? = pivot.map({ self.origin.translating((self.origin - $0).scaling(y: hs - 1)) })
        return CGRect(origin: origin ?? self.origin, size: self.size.scaling(height: hs))
    }

    /// Returns the rectangle scaled vertically by the given amount around the specified pivot point.
    public func scaling(width ws: CGFloat, height hs: CGFloat, pivot: CGPoint? = nil) -> CGRect {
        let origin: CGPoint? = pivot.map({ self.origin.translating((self.origin - $0).scaling(x: ws - 1, y: hs - 1)) })
        return CGRect(origin: origin ?? self.origin, size: self.size.scaling(width: ws, height: hs))
    }

    /// Returns the rectangle scaled by the given amount around the specified pivot point.
    public func scaling(_ scale: CGFloat, pivot: CGPoint? = nil) -> CGRect { self.scaling(width: scale, height: scale, pivot: pivot) }

    /// Returns the rectangle scaled by the given amount around the specified pivot point.
    public func scaling(_ scale: CGPoint, pivot: CGPoint? = nil) -> CGRect { self.scaling(width: scale.x, height: scale.y, pivot: pivot) }

    /// Returns the rectangle scaled by the given amount around the specified pivot point.
    public func scaling(_ scale: CGSize, pivot: CGPoint? = nil) -> CGRect { self.scaling(width: scale.width, height: scale.height, pivot: pivot) }
}

extension CGRect {

    /// Insets rectangle by a given distance.
    public func inset(by distance: CGFloat) -> CGRect { self.insetBy(dx: distance, dy: distance) }
    public func inset(x distance: CGFloat) -> CGRect { self.insetBy(dx: distance, dy: 0) }
    public func inset(y distance: CGFloat) -> CGRect { self.insetBy(dx: 0, dy: distance) }

    /// Checks if current rectangle is within (bound by) the specified one and returns current rectangle
    /// with origin adjusted to bounding rectangle, i.e., in bounding rectangle coordinate space.
    public func bound(by bounds: CGRect) -> CGRect? {
        bounds.intersection(self) == CGRect.null ? nil : self - bounds.origin
    }

    /// Flips current rectangle both horizontally and vertically inside the specified containment rectangle
    /// by symmetrically translating top-left points relation into bottom-right.
    public func flip(inside containment: CGRect) -> CGRect {
        self.flip(horizontally: containment).flip(vertically: containment)
    }

    /// Flips current rectangle horizontally inside the specified containment rectangle.
    public func flip(horizontally containment: CGRect) -> CGRect {
        // let newX = containment.origin.x + containment.width - (self.origin.x - containment.origin.x) - self.width
        // let diff = containment.origin.x + containment.width - (self.origin.x - containment.origin.x) - self.width - self.origin.x
        CGRect(origin: self.origin.translating(x: (containment.origin.x - self.origin.x) * 2 + containment.width - self.width), size: self.size)
    }

    /// Flips current rectangle vertically inside the specified containment rectangle, especially useful
    /// for achieving flipped view coordinates.
    public func flip(vertically containment: CGRect) -> CGRect {
        // let newY = containment.origin.y + containment.height - (self.origin.y - containment.origin.y) - self.height
        // let diff = containment.origin.y + containment.height - (self.origin.y - containment.origin.y) - self.height - self.origin.y
        CGRect(origin: self.origin.translating(y: (containment.origin.y - self.origin.y) * 2 + containment.height - self.height), size: self.size)
    }
}

extension CGRect {
    public func intersects(horizontally rect: CGRect) -> Bool {
        self.minX < rect.maxX && self.maxX > rect.minX || rect.minX < self.maxX && rect.maxX > self.minX
    }

    public func intersects(vertically rect: CGRect) -> Bool {
        self.minY < rect.maxY && self.maxY > rect.minY || rect.minY < self.maxY && rect.maxY > self.minY
    }
}

extension CGRect {
    /// Increases rectangle size by given size width and height.
    public static func + (lhs: CGRect, rhs: CGSize) -> CGRect { CGRect(x: lhs.origin.x, y: lhs.origin.y, width: lhs.width + rhs.width, height: lhs.height + rhs.height) }

    /// Decreases rectangle size by given size width and height.
    public static func - (lhs: CGRect, rhs: CGSize) -> CGRect { CGRect(x: lhs.origin.x, y: lhs.origin.y, width: lhs.width - rhs.width, height: lhs.height - rhs.height) }

    /// Increases rectangle origin x and y by given point x and y.
    public static func + (lhs: CGRect, rhs: CGPoint) -> CGRect { CGRect(x: lhs.origin.x + rhs.x, y: lhs.origin.y + rhs.y, width: lhs.width, height: lhs.height) }

    /// Decreases rectangle origin x and y by given point x and y.
    public static func - (lhs: CGRect, rhs: CGPoint) -> CGRect { CGRect(x: lhs.origin.x - rhs.x, y: lhs.origin.y - rhs.y, width: lhs.width, height: lhs.height) }

    /// Multiplies rectangle origin x and y and size width and height by given amount.
    public static func * (lhs: CGRect, rhs: CGFloat) -> CGRect { CGRect(x: lhs.origin.x * rhs, y: lhs.origin.y * rhs, width: lhs.width * rhs, height: lhs.height * rhs) }

    /// Divides rectangle origin x and y and size width and height by given amount.
    public static func / (lhs: CGRect, rhs: CGFloat) -> CGRect { CGRect(x: lhs.origin.x / rhs, y: lhs.origin.y / rhs, width: lhs.width / rhs, height: lhs.height / rhs) }
}

extension CGRect {
    public static func += (lhs: inout CGRect, rhs: CGSize) { lhs = lhs + rhs }
    public static func -= (lhs: inout CGRect, rhs: CGSize) { lhs = lhs - rhs }

    public static func += (lhs: inout CGRect, rhs: CGPoint) { lhs = lhs + rhs }
    public static func -= (lhs: inout CGRect, rhs: CGPoint) { lhs = lhs - rhs }

    public static func *= (lhs: inout CGRect, rhs: CGFloat) { lhs = lhs * rhs }
    public static func /= (lhs: inout CGRect, rhs: CGFloat) { lhs = lhs / rhs }
}

/// Rounds rectangle origin x and y and size width and height.
public func round(_ rectangle: CGRect) -> CGRect { CGRect(origin: round(rectangle.origin), size: round(rectangle.size)) }
