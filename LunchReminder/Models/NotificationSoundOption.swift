import Foundation

enum NotificationSoundOption: String, Codable, CaseIterable, Identifiable {
    case systemDefault
    case gentle
    case bear
    case music

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .systemDefault: "默认铃声"
        case .gentle: "温柔铃声"
        case .bear: "小熊铃声"
        case .music: "轻音乐"
        }
    }

    var resourceFileName: String? {
        switch self {
        case .systemDefault: "default_sound.wav"
        case .gentle: "gentle_sound.wav"
        case .bear: "bear_sound.wav"
        case .music: "music_sound.wav"
        }
    }
}
