import SwiftUI

enum AppTab {
    case dashboard
    case brainstorm
    case timer
    case shop
}

struct MainTabView: View{
    
    @State private var selectedTab: AppTab = .dashboard
    @Environment(AppStore.self) private var appStore
    
    var body: some View{
        
        TabView(selection: $selectedTab) {
            
            Tab("Today", systemImage: "checklist", value: .dashboard){
                DashboardView()
            }
            
            Tab("Brainstorm", systemImage: "sparkles", value: .brainstorm){
                BrainstormView()
            }
            
            Tab("Focus", systemImage: "timer", value: .timer){
                TimerView()
            }
            
            Tab("Rewards", systemImage: "gift.fill", value: .shop){
                ShopView()
            }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
        .environment(AppStore())
}
