import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "book.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("AI Guide")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding()
            .navigationTitle("AI Guide")
        }
    }
}

#Preview {
    ContentView()
}
