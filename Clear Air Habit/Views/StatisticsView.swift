import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 15) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.pink)
                            .symbolEffect(.bounce, value: viewModel.smokingFreeStreak)
                        
                        Text("\(viewModel.smokingFreeStreak)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())
                        
                        Text(daysText(viewModel.smokingFreeStreak))
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("smoke-free!")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                    
                    if viewModel.maxStreak > 0 {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(.yellow)
                                Text("Best Streak")
                                    .font(.headline)
                            }
                            
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("\(viewModel.maxStreak)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .contentTransition(.numericText())
                                
                                Text(daysText(viewModel.maxStreak))
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .padding(.horizontal)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                    }
                    
                    if let milestone = viewModel.getNextMilestone(),
                       let daysUntil = viewModel.getDaysUntilNextMilestone() {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.orange)
                                Text("Next Milestone")
                                    .font(.headline)
                            }
                            
                            Text(milestone.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("In \(achievementsDaysText(daysUntil))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            ProgressView(value: Double(viewModel.smokingFreeStreak), total: Double(milestone.daysRequired))
                                .tint(.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .padding(.horizontal)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Your Achievements")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        let facts = viewModel.getRelevantFacts()
                        
                        if facts.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.yellow)
                                
                                Text("Start your journey to health!")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                
                                Text("Mark your first smoke-free day in the calendar")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.secondarySystemBackground))
                            )
                            .padding(.horizontal)
                        } else {
                            ForEach(facts.reversed()) { fact in
                                HealthFactCard(fact: fact)
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.smokingFreeStreak)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.maxStreak)
            .onAppear {
                viewModel.updateStreak()
            }
        }
    }
    
    private func daysText(_ days: Int) -> String {
        days == 1 ? "day" : "days"
    }
    private func achievementsDaysText(_ days: Int) -> String {
        days == 1 ? "\(days) day" : "\(days) days"
    }
}

struct HealthFactCard: View {
    let fact: HealthFact
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(fact.icon)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(fact.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(fact.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

