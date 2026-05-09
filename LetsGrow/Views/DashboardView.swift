import SwiftUI

struct DashboardView: View {
    
    @Environment(AppStore.self) private var appStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Top Stats Row
                    HStack {
                        Text("Active Tasks")
                            .font(.title2.bold())
                        
                        Spacer()
                        
                        // Live Coin Counter
                        HStack(spacing: 4) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .foregroundColor(.yellow)
                            Text("\(appStore.session.totalCoins)")
                                .fontWeight(.bold)
                                .contentTransition(.numericText())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.yellow.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal)

                    // MARK: - Task List
                    if appStore.session.activeTasks.isEmpty {
                        // Empty State if they haven't brainstormed yet
                        ContentUnavailableView(
                            "No Tasks Yet",
                            systemImage: "sparkles",
                            description: Text("Head over to the Brainstorm tab to break down your first goal!")
                        )
                        .padding(.top, 40)
                    } else {
                        // Render every task the AI generated
                        ForEach(appStore.session.activeTasks) { task in
                            TaskCardView(task: task)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Today")
        }
    }
}

#Preview {
    DashboardView()
        .environment(AppStore())
}
