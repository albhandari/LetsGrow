import SwiftUI


struct BrainstormView: View {
    // 1. Global State (Injected from App)
    @Environment(AppStore.self) private var appStore
    
    // 2. Local State (Managed by our new ViewModel)
    @State private var viewModel = BrainstormViewModel(aiProvider: MockAIProvider())
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("What's on your mind?")) {
                    TextField("e.g., Study for my final", text: $viewModel.draftGoal)
                    
                    Picker("Energy Level", selection: $viewModel.draftEnergy) {
                        ForEach(EnergyLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button(action: {
                        Task {
                            // 1. Ask ViewModel to do the heavy lifting
                            if let newTasks = await viewModel.generateActionPlan() {
                                // 2. Route the results to the Global Vault
                                appStore.saveNewPlan(tasks: newTasks)
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Break It Down")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                    .listRowBackground(Color.blue)
                    .foregroundColor(.white)
                }
                
                // Read from the global store to show the final result
                if !appStore.activeTasks.isEmpty {
                    Section(header: Text("Your Game Plan")) {
                        ForEach(appStore.activeTasks) { task in
                            HStack {
                                Text(task.title)
                                Spacer()
                                Text("\(task.estimatedMinutes)m")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("LetsGrow")
        }
    }
}

#Preview {
    BrainstormView()
        .environment(AppStore())
}
