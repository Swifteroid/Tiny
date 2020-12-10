import Foundation

extension FileManager {
    /// Checks whether the directory exists at the given path.
    public func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = ObjCBool(false)
        return self.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    /// Creates the directory at the specified path if the file doesn't exists already, otherwise throws an error.
    public func assureDirectory(atPath path: String) throws {
        var directory: ObjCBool = false
        let exists: Bool = self.fileExists(atPath: path, isDirectory: &directory)
        if exists && directory.boolValue {
            return
        } else if exists {
            throw Error.fileAlreadyExists
        }
        try self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
}

extension FileManager {
    enum Error: Swift.Error {
        case fileAlreadyExists
    }
}

/// URL shorthand.
extension FileManager {
    public func fileExists(at url: URL) -> Bool { self.fileExists(atPath: url.path) }
    public func directoryExists(at url: URL) -> Bool { self.directoryExists(atPath: url.path) }
    public func assureDirectory(at url: URL) throws { try self.assureDirectory(atPath: url.path) }
}