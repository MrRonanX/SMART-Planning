//
//  AddEventsSheet.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 6/26/21.
//

import SwiftUI


struct AddEventsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var eventName = ""
    @State var startTime = Date()
    @State var endTime = Date()
    
    
    var body: some View {
        VStack {
            DismissButton()
            Text("What's it?")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            TextField("Type here", text: $eventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Text("Start Time")
                    .font(.title3)
                    .fontWeight(.semibold)
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            HStack {
                Text("End Time")
                    .font(.title3)
                    .fontWeight(.semibold)
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            
            Button("Add") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title3)
            
            Spacer()
        }
        
        .padding()
    }
}

struct AddEventsSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddEventsSheet()
    }
}
