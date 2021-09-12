//
//  CalendarView.swift
//  SMART Planning
//
//  Created by Roman Kavinskyi on 9/12/21.
//

import SwiftUI
import JTAppleCalendar

struct CalendarView: UIViewRepresentable {
    var goalModel: GoalModel
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> JTACMonthView {
        let calendar = JTACMonthView()
        calendar.calendarDelegate = context.coordinator
        calendar.calendarDataSource = context.coordinator
        calendar.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseID)
        calendar.register(DateHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: "DateHeader")
        calendar.backgroundColor = .systemBackground
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.scrollDirection = .horizontal
//        calendar.allowsSelection = false
        calendar.showsHorizontalScrollIndicator = false
        
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        
        calendar.selectDates(goalModel.tasks.filter { $0.isCompleted }.map { $0.wrappedDate.midday() } )
        
        return calendar
    }
    
    func updateUIView(_ uiView: JTACMonthView, context: Context) {}
    
    class Coordinator: JTACMonthViewDelegate, JTACMonthViewDataSource {
        let formatter = DateFormatter()
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
            let startDate = parent.goalModel.startDate.midday()
            let endDate = parent.goalModel.goal.wrappedDeadline.midday()
            return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow)
        }
        
        func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
            configureCell(view: cell, cellState: cellState)
        }
        
        func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
            self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
            return cell
        }
        
        func configureCell(view: JTACDayCell?, cellState: CellState) {
            guard let cell = view as? DateCell  else { return }
            cell.dateLabel.text = cellState.text
            handleCellTextColor(cell: cell, cellState: cellState)
            handleCellSelected(cell: cell, cellState: cellState)
        }
        
        func handleCellTextColor(cell: DateCell, cellState: CellState) {
            cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
        }
        
        func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
            configureCell(view: cell, cellState: cellState)
        }
        
        func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
            parent.goalModel.tasks.filter { $0.isCompleted }.map { $0.wrappedDate.midday() }.contains(date.midday()) ? true : false
        }
        
        func calendar(_ calendar: JTACMonthView, didHighlightDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
            print("✅ Highliting")
        }
        
        //        func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        //            configureCell(view: cell, cellState: cellState)
        //        }
        

        
        func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
            return MonthSize(defaultSize: 60)
        }
        
        
        func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
            formatter.dateFormat = "MMMM"
            
            let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
            header.monthTitle.text = formatter.string(from: range.start)
            return header
        }
        
        
        func handleCellSelected(cell: DateCell, cellState: CellState) {
            if cellState.isSelected {
                cell.selectedView.layer.cornerRadius =  20
                cell.selectedView.isHidden = false
            } else {
                cell.selectedView.isHidden = true
            }
        }
        
        let parent: CalendarView
    }
}


final class DateCell: JTACDayCell {
    static let reuseID = "dateCell"
    
    let dateLabel = UILabel()
    let selectedView = UIView()
    let padding: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.backgroundColor = .systemBlue
        contentView.addSubview(selectedView)
        
        NSLayoutConstraint.activate([
            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedView.widthAnchor.constraint(equalToConstant: padding * 2),
            selectedView.heightAnchor.constraint(equalToConstant: padding * 2)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: selectedView.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: selectedView.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: padding * 1.5),
            dateLabel.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
}

final class DateHeader: JTACMonthReusableView {
    static let reuseID = "DateHeader"
    private let padding: CGFloat = 20
    let monthTitle = UILabel()
    private let daysView = UIView()
    private let day1 = UILabel()
    private let day2 = UILabel()
    private let day3 = UILabel()
    private let day4 = UILabel()
    private let day5 = UILabel()
    private let day6 = UILabel()
    private let day7 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        monthTitle.translatesAutoresizingMaskIntoConstraints = false
        
        monthTitle.textColor = .label
        monthTitle.textAlignment = .center
        monthTitle.font = UIFont.preferredFont(forTextStyle: .title3)
        
        self.addSubview(monthTitle)
        NSLayoutConstraint.activate([
            monthTitle.topAnchor.constraint(equalTo: self.topAnchor),
            monthTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            monthTitle.heightAnchor.constraint(equalToConstant: padding * 1.5),
            monthTitle.widthAnchor.constraint(equalToConstant: self.frame.width / 2),
            
        ])
        
        daysView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(daysView)
        NSLayoutConstraint.activate([
            daysView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            daysView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            daysView.topAnchor.constraint(equalTo: monthTitle.bottomAnchor, constant: 10),
            daysView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        configureDays()
    }
    
    func configureDays() {
        let weekDays = [day1, day2, day3, day4, day5, day6, day7]
        daysView.addSubviews(weekDays)
        
        var weekDay = 0
        for subview in weekDays {
            subview.textAlignment = .center
            subview.textColor = .orange
            subview.text = Calendar.current.veryShortWeekdaySymbols[weekDay]
            weekDay += 1
            
            NSLayoutConstraint.activate([
                subview.widthAnchor.constraint(equalToConstant: self.frame.width / 7),
                subview.heightAnchor.constraint(equalToConstant: padding),
                subview.centerYAnchor.constraint(equalTo: daysView.centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            day1.leadingAnchor.constraint(equalTo: daysView.leadingAnchor),
            day2.leadingAnchor.constraint(equalTo: day1.trailingAnchor),
            day3.leadingAnchor.constraint(equalTo: day2.trailingAnchor),
            day4.leadingAnchor.constraint(equalTo: day3.trailingAnchor),
            day5.leadingAnchor.constraint(equalTo: day4.trailingAnchor),
            day6.leadingAnchor.constraint(equalTo: day5.trailingAnchor),
            day7.leadingAnchor.constraint(equalTo: day6.trailingAnchor),
            
        ])
    }
}


//class CalendarViewWithHeader: UIView {
//
//    var headerView: DateHeader!
//    var goalModel: GoalModel!
//    let calendar = JTACMonthView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        headerView = DateHeader(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width * 0.16))
//        configureConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configureConstraints() {
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        calendar.translatesAutoresizingMaskIntoConstraints = false
//
//        self.addSubview(headerView)
//        self.addSubview(calendar)
//
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: self.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: self.frame.width * 0.16),
//
//            calendar.topAnchor.constraint(equalTo: headerView.bottomAnchor),
//            calendar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            calendar.widthAnchor.constraint(equalToConstant: self.bounds.width),
//            calendar.heightAnchor.constraint(equalToConstant: self.bounds.width)
//        ])
//    }
//}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
