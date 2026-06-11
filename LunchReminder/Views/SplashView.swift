import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            CuteColor.background.ignoresSafeArea()
            Image(AssetNames.splashLogo)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
