import SwiftUI

struct RelaxationView: View {
    @State private var selectedExercise: BreathingExercise?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "wind")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text("Breathing Exercises")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Text("Practice breathing techniques to relieve stress and cravings")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    ForEach(BreathingExercise.exercises) { exercise in
                        BreathingExerciseCard(exercise: exercise)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    selectedExercise = exercise
                                }
                            }
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.title)
                                .foregroundColor(.purple)
                            Text("Meditation Tips")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        
                        MeditationTip(
                            icon: "sun.max.fill",
                            title: "Morning Meditation",
                            description: "Start your day with 5-10 minutes of meditation. Focus on breathing and set a positive intention for the day.",
                            color: .orange
                        )
                        .padding(.horizontal)
                        
                        MeditationTip(
                            icon: "moon.stars.fill",
                            title: "Evening Practice",
                            description: "Before bed, practice mindful breathing. This helps you relax and improves sleep quality.",
                            color: .indigo
                        )
                        .padding(.horizontal)
                        
                        MeditationTip(
                            icon: "figure.walk",
                            title: "Walking Meditation",
                            description: "When cravings arise, go for a walk. Focus on each step and your breathing.",
                            color: .green
                        )
                        .padding(.horizontal)
                        
                        MeditationTip(
                            icon: "heart.text.square.fill",
                            title: "Gratitude",
                            description: "Daily write down 3 things you're grateful for. This helps maintain a positive mindset.",
                            color: .pink
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                }
                .padding(.vertical)
            }
            .navigationTitle("Relaxation")
            .sheet(item: $selectedExercise) { exercise in
                BreathingExerciseDetailView(exercise: exercise)
            }
        }
    }
}

struct BreathingExerciseCard: View {
    let exercise: BreathingExercise
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: exercise.icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(exercise.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(exercise.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(exercise.duration / 60) min")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct MeditationTip: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct BreathingExerciseDetailView: View {
    @Environment(\.dismiss) var dismiss
    let exercise: BreathingExercise
    
    @State private var isBreathing = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 20)
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]),
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 150
                                )
                            )
                            .frame(width: 200, height: 200)
                            .scaleEffect(scale)
                            .animation(
                                isBreathing ?
                                    .easeInOut(duration: 4).repeatForever(autoreverses: true) :
                                    .default,
                                value: scale
                            )
                        
                        Image(systemName: exercise.icon)
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Instructions")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        ForEach(Array(exercise.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1).")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentColor)
                                
                                Text(step)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                    
                    Button(action: {
                        isBreathing.toggle()
                        if isBreathing {
                            scale = 1.5
                        } else {
                            scale = 1.0
                        }
                    }) {
                        Text(isBreathing ? "Stop" : "Start")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isBreathing ? Color.red : Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(exercise.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

