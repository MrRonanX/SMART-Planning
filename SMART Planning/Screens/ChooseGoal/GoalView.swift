//
//  GoalView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/28/21.
//

//GraphicalDatePickerStyle
//WheelDatePickerStyle


import SwiftUI

struct GoalView: View {
    
    @State var numberOfBooks = 2
    @State var numberOfPages = 100
    @State var deadlineDate  = Date()
    
    
    var dateRange: ClosedRange<Date> {
        let now = Date()
        let nextYear = Date().addingTimeInterval(31536000)
        let range = now ... nextYear
        return range
    }
    
    var pages = [50, 75, 100, 150, 200, 250, 300]
    
    var body: some View {
        VStack {
            DismissButton()
            HStack {
                Text("How many books do you want to read?")
                Picker("", selection: $numberOfBooks) {
                    ForEach(1..<11) {
                        Text("\($0)")
                    }
                }
                .frame(width: 50, height: 75)
                .clipped()
            }
            
            HStack {
                Text("How much is the average number of pages in each book?")
                Picker("", selection: $numberOfPages) {
                    ForEach(pages, id:\.self) {
                        Text("\($0)")
                    }
                }
                .frame(width: 50, height: 75)
                .clipped()
            }
            
            Text("It's important to set a deadline. /n By what date do you want to read \(numberOfBooks + 1) books")
            DatePicker("Deadline", selection: $deadlineDate, in: dateRange, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            
            Button("Save") {
                let goal = GoalModel(name: "Reading", metric1: numberOfBooks + 1, metric2: numberOfPages, startDate: Date(), deadline: deadlineDate)
                
                
            }
            
            NavigationLink(destination: TimelineView(),
                           label: { Text("Save") })
            .font(.title2)
            Spacer()
        }.padding()
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
