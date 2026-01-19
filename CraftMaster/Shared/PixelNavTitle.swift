import SwiftUI

extension View {
    /// Use a PixelTheme font for the navigation bar title (matches Achievements pixel styling).
    /// Forces `.inline` so the custom title renders consistently.
    func pixelNavigationTitle(_ title: String) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(PixelTheme.titleFont())
                }
            }
    }
}

