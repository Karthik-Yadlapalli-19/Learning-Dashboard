import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text("You're offline. Showing previously loaded courses.")
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.yellow.opacity(0.2))
    }
}
