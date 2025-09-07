//
//  Testing New Goals.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 2025-09-06.
//

import SwiftUI

struct GoalSetupView: View {
    @State private var goalTitle: String = ""
    @State private var goalDescription: String = ""
    @State private var selectedIcon: String = "book.closed.fill" // Default icon
    @State private var selectedColor: Color = .blue // Default color
    @State private var exerciseUnits: String = ""
    @State private var deadline: Date = Date()
    @State private var startDate: Date = Date()
    @State private var notificationEnabled: Bool = true
    @State private var notificationTime: Date = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()

    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    @State private var selectedDays: [String] = []


    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Goal Title (e.g., Reading)", text: $goalTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                    TextField("Description (e.g., Read 'Death On Nile')", text: $goalDescription)
                        .font(.body)
                }

                Section("Visuals") {
                    HStack {
                        Text("Icon")
                        Spacer()
                        Image(systemName: selectedIcon)
                            .font(.title2)
                            .foregroundColor(selectedColor)
                            .padding(8)
                            .background(Circle().fill(selectedColor.opacity(0.2)))
                            .onTapGesture {
                                // TODO: Implement icon picker
                                print("Open icon picker")
                            }
                    }

                    ColorPicker("Goal Color", selection: $selectedColor)
                }

                Section(header: Text("Frequency").font(.headline)) {
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedDays.contains(day) ? selectedColor.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    if selectedDays.contains(day) {
                                        selectedDays.removeAll { $0 == day }
                                    } else {
                                        selectedDays.append(day)
                                    }
                                }
                        }
                    }

                    TextField("Exercise Units (e.g., 400 pages)", text: $exerciseUnits)
                }

                Section("Deadline & Notifications") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("Deadline Date", selection: $deadline, displayedComponents: .date)
                        .accentColor(selectedColor)

                    Toggle("Enable Notifications", isOn: $notificationEnabled)
                        .tint(selectedColor)

                    if notificationEnabled {
                        DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                            .accentColor(selectedColor)
                    }
                }

                Button(action: {
                    // TODO: Implement save goal action
                    print("Goal Saved!")
                    print("Title: \(goalTitle)")
                    print("Description: \(goalDescription)")
                    print("Icon: \(selectedIcon)")
                    print("Color: \(selectedColor)")
                    print("Days: \(selectedDays.joined(separator: ", "))")
                    print("Units: \(exerciseUnits)")
                    print("Deadline: \(deadline)")
                    print("Notifications: \(notificationEnabled ? "Enabled at \(notificationTime)" : "Disabled")")
                }) {
                    Text("Save Goal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedColor)
                        .cornerRadius(10)
                }
                .listRowBackground(Color.clear) // Remove background for button
            }
            .navigationTitle("Set Your Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GoalSetterView()
}

#Preview {
    GoalSettingScreen()
}

#Preview {
    GoalSetupView()
}

struct GoalSettingScreen: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedIcon: String = "book.fill"
    @State private var selectedColor: Color = .blue
    @State private var selectedDays: [String] = []
    @State private var goalUnit: String = ""
    @State private var deadline = Date()
    @State private var notificationsOn = true

    let icons = ["book.fill", "figure.walk", "pencil.and.outline", "music.note", "paintbrush.fill"]
    let colors: [Color] = [.blue, .green, .orange, .purple, .pink]
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details").font(.headline)) {
                    TextField("Title (e.g., Reading)", text: $title)
                    TextField("Description (e.g., I want to read 'Death On The Nile')", text: $description)
                }

                Section(header: Text("Icon & Color").font(.headline)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(icons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .font(.title)
                                    .padding()
                                    .background(selectedIcon == icon ? selectedColor.opacity(0.3) : Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                            }
                        }
                        .padding(.vertical)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary.opacity(0.5), lineWidth: selectedColor == color ? 2 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                        .padding(.vertical)
                    }
                }

                Section(header: Text("Frequency").font(.headline)) {
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedDays.contains(day) ? selectedColor.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    if selectedDays.contains(day) {
                                        selectedDays.removeAll { $0 == day }
                                    } else {
                                        selectedDays.append(day)
                                    }
                                }
                        }
                    }
                }

                Section(header: Text("Goal Units").font(.headline)) {
                    TextField("e.g., 400 pages", text: $goalUnit)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Deadline").font(.headline)) {
                    DatePicker("Select a date", selection: $deadline, in: Date()..., displayedComponents: .date)
                }

                Section(header: Text("Notifications").font(.headline)) {
                    Toggle("Enable Notifications", isOn: $notificationsOn)
                }

                Button(action: {
                    // Save goal action
                }) {
                    Text("Create Goal")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("New Goal")
        }
    }
}

struct GoalSetterView: View {
    @State private var goalTitle: String = ""
    @State private var goalDescription: String = ""
    @State private var selectedIcon: String = "book.fill"
    @State private var selectedColor: Color = .blue
    @State private var selectedDays: [String] = []
    @State private var goalUnit: String = ""
    @State private var deadline = Date()
    @State private var notificationsOn: Bool = true

    let icons = ["book.fill", "figure.walk", "pencil.and.outline", "leaf.fill", "paintbrush.fill", "music.note"]
    let days = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details").font(.headline)) {
                    TextField("Title (e.g., Reading)", text: $goalTitle)
                    TextField("Description", text: $goalDescription)
                }

                Section(header: Text("Personalize").font(.headline)) {
                    VStack(alignment: .leading) {
                        Text("Icon")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(icons, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .font(.title)
                                        .padding()
                                        .background(selectedIcon == icon ? selectedColor.opacity(0.3) : Color(UIColor.systemGray6))
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            selectedIcon = icon
                                        }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    ColorPicker("Goal Color", selection: $selectedColor)
                }

                Section(header: Text("Frequency").font(.headline)) {
                    VStack(alignment: .leading) {
                        Text("On Which Days?")
                        HStack(spacing: 10) {
                            ForEach(days.indices, id: \.self) { index in
                                Text(days[index])
                                    .fontWeight(.bold)
                                    .frame(width: 35, height: 35)
                                    .background(selectedDays.contains(days[index] + "\(index)") ? selectedColor : Color(UIColor.systemGray6))
                                    .foregroundColor(selectedDays.contains(days[index] + "\(index)") ? .white : .primary)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        let dayIdentifier = days[index] + "\(index)"
                                        if selectedDays.contains(dayIdentifier) {
                                            selectedDays.removeAll { $0 == dayIdentifier }
                                        } else {
                                            selectedDays.append(dayIdentifier)
                                        }
                                    }
                            }
                        }
                    }
                }

                Section(header: Text("Measurement").font(.headline)) {
                    TextField("Exercise Units (e.g., 400 pages)", text: $goalUnit)
                }

                Section(header: Text("Deadline").font(.headline)) {
                    DatePicker("Deadline", selection: $deadline, in: Date()..., displayedComponents: .date)
                }

                Section(header: Text("Stay on Track").font(.headline)) {
                    Toggle("Notifications", isOn: $notificationsOn)
                }

                Button(action: {
                    // Save goal action
                }) {
                    Text("Save Goal")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(selectedColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets())

            }
            .navigationTitle("New Goal")
        }
    }
}
