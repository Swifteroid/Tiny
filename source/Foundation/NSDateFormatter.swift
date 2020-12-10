import Foundation

extension DateFormatter {
    /// Initializes formatter with the date format string.
    public convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }

    /// Initializes formatter with the date and time styles.
    public convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}
