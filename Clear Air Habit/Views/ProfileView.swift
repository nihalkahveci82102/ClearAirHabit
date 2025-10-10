import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingThemeSelection = false
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case name
        case age
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Enter name", text: $viewModel.name)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .name)
                    }
                    
                    Picker("Gender", selection: $viewModel.gender) {
                        Text("Not specified").tag(nil as Gender?)
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender as Gender?)
                        }
                    }
                    
                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("Enter age", text: $viewModel.age)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .focused($focusedField, equals: .age)
                            .onChange(of: viewModel.age) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    viewModel.age = filtered
                                }
                            }
                    }
                }
                
                Section(header: Text("Settings")) {
                    Button(action: {
                        showingThemeSelection = true
                    }) {
                        HStack {
                            Label("App Theme", systemImage: "paintbrush.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(viewModel.selectedTheme.rawValue)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Feedback")) {
                    Button(action: {
                        viewModel.requestAppReview()
                    }) {
                        HStack {
                            Label("Rate App", systemImage: "star.fill")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Made with")
                        Spacer()
                        Text("❤️")
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingThemeSelection) {
                ThemeSelectionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadProfile()
            }
            .onDisappear {
                viewModel.saveProfile()
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct ThemeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Button(action: {
                        viewModel.selectedTheme = theme
                        viewModel.saveProfile()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: themeIcon(for: theme))
                                .font(.title3)
                                .foregroundColor(themeColor(for: theme))
                                .frame(width: 30)
                            
                            Text(theme.rawValue)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if viewModel.selectedTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Theme Selection")
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
    
    private func themeIcon(for theme: AppTheme) -> String {
        switch theme {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
    
    private func themeColor(for theme: AppTheme) -> Color {
        switch theme {
        case .system:
            return .blue
        case .light:
            return .orange
        case .dark:
            return .indigo
        }
    }
}

