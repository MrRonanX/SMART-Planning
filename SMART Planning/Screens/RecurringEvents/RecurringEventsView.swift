//
//  SwiftUIView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 5/31/21.
//

import SwiftUI

struct RecurringEventsView: View {
    
    #warning("setup viewmodel")

    @State var wakeUpTime = Date()
    @State var bedtime = Date()
    
    @State private var addMoreEventsAlert = false
    
    var body: some View {
        VStack {
            Text("Providing your recurrent events will help us give you a more personalized schedule")
                .font(.title3)
                .padding(.horizontal)
            Divider()
            HStack {
                Image(systemName: "circlebadge.fill")
                    .foregroundColor(.blue)
                Text("Sleeping cycle")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
            }
            HStack {
                Text("Wakeup Time")
                    .font(.title3)
                    .fontWeight(.semibold)
                DatePicker("Wakeup Time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            HStack {
                Text("Bedtime")
                    .font(.title3)
                    .fontWeight(.semibold)
                DatePicker("Bedtime", selection: $bedtime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            
            Button { showMoreEventsSheet() }
                label: {
                Text("Add more events")
                    .font(.body)
                    .padding()
            }
            
            Spacer()
            
            NavigationLink(destination: ChooseGoalView(),
                           label: { Text("Next")
                            .foregroundColor(.blue)
                            .font(.title3) })
            
        }
        .padding()
        .navigationTitle("Personalization")
        .sheet(isPresented: $addMoreEventsAlert) {
            AddEventsSheet()
        }
    }
    
    func showMoreEventsSheet() {
        addMoreEventsAlert = true
    }
    
    func saveSleepingCycleAndOtherEvents() {
        #warning("Save events")
        // setup viewmodel
        
        // create a event struct
        
        // add it to events array
        
        // save it to CD
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RecurringEventsView()
    }
}
