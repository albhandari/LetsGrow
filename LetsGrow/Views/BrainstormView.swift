import SwiftUI

struct BrainstormView: View {
    // 1. Global State (Injected from App)
    @Environment(AppStore.self) private var appStore
    
    // 2. Local State (Managed by the ViewModel)
    @State private var viewModel = BrainstormViewModel(aiProvider: OpenAIProvider())
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("What's on your mind?")) {
                    TextField("e.g., Study for my final", text: $viewModel.draftTask)
                    
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
                            //fetch the Task and its Subtasks
                            if let newTask = await viewModel.fetchActionPlan() {
                                //Route the results to the Store
                                appStore.addNewTask(newTask)
                                
                                //Clear the input field after success
                                viewModel.draftTask = ""
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
                    // Makes the button look disabled when the text field is empty
                    .listRowBackground(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                }
                
                // Read from the global store to show the Task
                if !appStore.session.activeTasks.isEmpty {
                    Section(header: Text("Active Tasks")) {
                        ForEach(appStore.session.activeTasks) { task in
                            VStack(alignment: .leading, spacing: 8) {
                                // MARK: - Parent Task Row
                                HStack {
                                    Text(task.title)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(task.estimatedMinutes)m")
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                                
                                // MARK: - Subtasks List
                                if !task.subtasks.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(task.subtasks) { subtask in
                                            HStack(alignment: .top) {
                                                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(subtask.isCompleted ? .green : .gray)
                                                    .font(.subheadline)
                                                
                                                Text(subtask.title)
                                                    .font(.subheadline)
                                                    .strikethrough(subtask.isCompleted, color: .gray)
                                                    .foregroundColor(subtask.isCompleted ? .gray : .primary)
                                                
                                                Spacer()
                                                
                                                Text("\(subtask.estimatedMinutes)m")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    .padding(.leading, 16) // This indents the subtasks so it looks like a tree
                                    .padding(.top, 4)
                                }
                            }
                            .padding(.vertical, 4)
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
