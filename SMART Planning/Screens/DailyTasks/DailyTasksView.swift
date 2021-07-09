//
//  DailyTasksView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 7/6/21.
//

import SwiftUI

struct DailyTasksView: View {
    
    @State var tasks = MocGoals.goals
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(title: "Today")) {
                    ForEach(tasks) { task in
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .font(.headline)
                                .imageScale(.large)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 5)
                            Text(task.name)
                            Spacer()
                            Text("Today")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }
                }
                Section(header: SectionHeader(title: "Upcoming")) {          
                }
            }
            .navigationTitle("Daily Tasks")
        }
    }
}


struct SectionHeader: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.down")
            Text(title)
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct DailyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTasksView()
    }
}
