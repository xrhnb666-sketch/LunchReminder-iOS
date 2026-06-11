import SwiftUI

enum CuteColor {
    static let background = Color(hex: 0xFFF9F2)
    static let card = Color.white
    static let breakfast = Color(hex: 0xFFF2DA)
    static let lunch = Color(hex: 0xFFE8D1)
    static let dinner = Color(hex: 0xEAF6E5)
    static let skip = Color(hex: 0xF2EAFF)
    static let orange = Color(hex: 0xFF8A35)
    static let orangeLight = Color(hex: 0xF6A437)
    static let green = Color(hex: 0x6EAE67)
    static let textPrimary = Color(hex: 0x4A332A)
    static let textSecondary = Color(hex: 0x9A7562)
    static let navBackground = Color(hex: 0xFFF4E8)
}

enum CuteMetric {
    static let pagePadding: CGFloat = 20
    static let cardCorner: CGFloat = 24
    static let cardPadding: CGFloat = 18
    static let cardSpacing: CGFloat = 16
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension View {
    func cuteShadow() -> some View {
        shadow(color: Color(hex: 0xD5A06C, alpha: 0.16), radius: 10, x: 0, y: 5)
    }
}
