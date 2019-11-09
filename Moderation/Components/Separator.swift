import SwiftUI

/// One pixel wide separator line
struct Separator: View {
    let axis: NSLayoutConstraint.Axis

    var body: some View {
        switch axis {
        case .horizontal:
            return gray.frame(height: 1)
        case .vertical:
            return gray.frame(width: 1)
        @unknown default:
            fatalError("Unexpected axis")
        }
    }

    var gray: some View {
        Color(UIColor.systemGray3)
    }
}
