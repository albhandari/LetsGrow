import SwiftUI

struct TaskCardView: View {
    @Environment(AppStore.self) private var appStore
    let task: TaskItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Parent Task Header
            HStack {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted, color: .green)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                Spacer()
                
                // Show a seal of approval if the whole thing is done
                if task.isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                        .symbolEffect(.bounce, value: task.isCompleted)
                } else {
                    Text("\(task.estimatedMinutes)m")
                        .font(.caption.bold())
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 4)
            
            Divider()
            
            // Render the Subtasks
            ForEach(task.subtasks) { subtask in
                Button {
                    // Tell the AppStore to do the math and hand out coins, wrapped in a snappy animation
                    withAnimation(.snappy) {
                        appStore.toggleSubtask(taskId: task.id, subtaskId: subtask.id)
                    }
                } label: {
                    HStack(alignment: .top) {
                        Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(subtask.isCompleted ? .green : .gray)
                            .font(.title3)
                            .contentTransition(.symbolEffect(.replace))
                        
                        Text(subtask.title)
                            .font(.subheadline)
                            .strikethrough(subtask.isCompleted, color: .gray)
                            .foregroundColor(subtask.isCompleted ? .gray : .primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Text("\(subtask.estimatedMinutes)m")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain) // Prevents the whole card from highlighting when tapping one button
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        // Fade the whole card out slightly when the parent is totally finished
        .opacity(task.isCompleted ? 0.6 : 1.0)
    }
}

// Add a quick preview so you can design the card in isolation!
#Preview {
    TaskCardView(task: TaskItem(
        title: "Test Task",
        estimatedMinutes: 45,
        subtasks: [
            Subtask(title: "Step 1", estimatedMinutes: 15),
            Subtask(title: "Step 2", estimatedMinutes: 15, isCompleted: true)
        ]
    ))
    .environment(AppStore())
}
