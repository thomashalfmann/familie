import SwiftUI

struct CalendarEvent: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    var color: Color
}

let monthNames = ["Januar", "Februar", "März", "April", "Mai", "Juni",
                  "Juli", "August", "September", "Oktober", "November", "Dezember"]

let monthNamesShort = ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun",
                       "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]

let monthColors = [
    Color(red: 0.89, green: 0.95, blue: 0.99),
    Color(red: 0.73, green: 0.87, blue: 0.98),
    Color(red: 0.56, green: 0.79, blue: 0.98),
    Color(red: 0.39, green: 0.71, blue: 0.96),
    Color(red: 0.26, green: 0.65, blue: 0.96),
    Color(red: 0.13, green: 0.59, blue: 0.95),
    Color(red: 0.12, green: 0.53, blue: 0.90),
    Color(red: 0.10, green: 0.46, blue: 0.82),
    Color(red: 0.08, green: 0.40, blue: 0.75),
    Color(red: 0.05, green: 0.28, blue: 0.63),
    Color(red: 0.51, green: 0.69, blue: 1.00),
    Color(red: 0.27, green: 0.54, blue: 1.00)
]

func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.locale = Locale(identifier: "de_DE")
    return formatter.string(from: date)
}

struct ContentView: View {
    @State private var events = [CalendarEvent]()
    @State private var startMonth: Int = 1
    @State private var selectedYear: Int = 2025
    @State private var eventTitle: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(30 * 24 * 60 * 60)
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("📅 Zirkularer Jahreskalender")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top)

                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Monat bei 12:00 Uhr:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Start Monat", selection: self.$startMonth) {
                                ForEach(0..<12) { month in
                                    Text(monthNames[month]).tag(month)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        VStack(alignment: .leading) {
                            Text("Jahr:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Jahr", selection: self.$selectedYear) {
                                ForEach(2020...2030, id: \.self) { year in
                                    Text(String(year)).tag(year)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Neues Ereignis:")
                            .font(.headline)

                        TextField("Titel", text: self.$eventTitle)
                            .textFieldStyle(.roundedBorder)

                        HStack(spacing: 15) {
                            VStack(alignment: .leading) {
                                Text("Startdatum:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: self.$startDate, displayedComponents: .date)
                                    .labelsHidden()
                            }

                            VStack(alignment: .leading) {
                                Text("Enddatum:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: self.$endDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                        }

                        Button(action: self.addEvent) {
                            Text("Zeitraum hinzufügen")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)

                CircularCalendarView(
                    events: self.events,
                    startMonth: self.startMonth,
                    year: self.selectedYear
                )
                .frame(width: 500, height: 500)
                .padding()

                if self.events.count > 0 {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ereignisse:")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(Array(self.events.enumerated()), id: \.element.id) { index, event in
                            EventRow(
                                event: event,
                                onDelete: {
                                    self.deleteEvent(atIndex: index)
                                }
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .alert("Hinweis", isPresented: self.$showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(self.alertMessage)
        }
    }

    func addEvent() {
        let trimmedTitle = self.eventTitle.trimmingCharacters(in: .whitespaces)
        let titleIsEmpty = trimmedTitle.isEmpty

        if titleIsEmpty {
            self.alertMessage = "Bitte geben Sie einen Titel ein."
            self.showingAlert = true
            return
        }

        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: self.startDate)
        let endYear = calendar.component(.year, from: self.endDate)

        let startYearMatches = (startYear == self.selectedYear)
        let endYearMatches = (endYear == self.selectedYear)

        if startYearMatches == false {
            let yearStr = String(self.selectedYear)
            self.alertMessage = "Beide Daten müssen im Jahr " + yearStr + " liegen."
            self.showingAlert = true
            return
        }

        if endYearMatches == false {
            let yearStr = String(self.selectedYear)
            self.alertMessage = "Beide Daten müssen im Jahr " + yearStr + " liegen."
            self.showingAlert = true
            return
        }

        let datesAreValid = (self.startDate <= self.endDate)
        if datesAreValid == false {
            self.alertMessage = "Das Startdatum muss vor dem Enddatum liegen."
            self.showingAlert = true
            return
        }

        let colors = [Color.red, Color.blue, Color.green, Color.orange, Color.purple, Color.pink, Color.cyan, Color.mint]
        let colorIndex = self.events.count % colors.count
        let color = colors[colorIndex]

        let event = CalendarEvent(
            title: trimmedTitle,
            startDate: self.startDate,
            endDate: self.endDate,
            color: color
        )

        self.events.append(event)
        self.eventTitle = ""
    }

    func deleteEvent(atIndex index: Int) {
        self.events.remove(at: index)
    }
}

struct EventRow: View {
    let event: CalendarEvent
    let onDelete: () -> Void

    var body: some View {
        let startStr = formatDate(date: self.event.startDate)
        let endStr = formatDate(date: self.event.endDate)
        let dateText = startStr + " - " + endStr

        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(self.event.title)
                    .font(.headline)
                    .foregroundColor(self.event.color)

                Text(dateText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: self.onDelete) {
                Text("Löschen")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CircularCalendarView: View {
    let events: Array<CalendarEvent>
    let startMonth: Int
    let year: Int

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let outerRadius: CGFloat = min(size.width, size.height) / 2 - 20
            let innerRadius: CGFloat = outerRadius * 0.6
            let eventRadius: CGFloat = innerRadius * 0.8

            for i in 0..<12 {
                let monthIndex = (self.startMonth + i) % 12
                let startDegrees = Double(i * 30) - 90
                let endDegrees = Double((i + 1) * 30) - 90
                let startAngle = Angle.degrees(startDegrees)
                let endAngle = Angle.degrees(endDegrees)

                let monthPath = self.createArcPath(
                    center: center,
                    innerRadius: innerRadius,
                    outerRadius: outerRadius,
                    startAngle: startAngle,
                    endAngle: endAngle
                )

                let monthColor = monthColors[monthIndex]
                context.fill(monthPath, with: .color(monthColor.opacity(0.6)))
                context.stroke(monthPath, with: .color(.white), lineWidth: 2)

                let labelDegrees = Double(i * 30 + 15) - 90
                let labelAngle = Angle.degrees(labelDegrees)
                let labelRadius = (outerRadius + innerRadius) / 2
                let labelX = center.x + Foundation.cos(labelAngle.radians) * labelRadius
                let labelY = center.y + Foundation.sin(labelAngle.radians) * labelRadius
                let labelPoint = CGPoint(x: labelX, y: labelY)

                context.draw(
                    Text(monthNamesShort[monthIndex])
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary),
                    at: labelPoint
                )
            }

            let eventCount = self.events.count
            for i in 0..<eventCount {
                let event = self.events[i]
                let radiusOffset = CGFloat(i * 20)
                let radius = eventRadius - radiusOffset

                let radiusIsValid = (radius > innerRadius * 0.3)
                if radiusIsValid == false {
                    continue
                }

                let startAngle = self.dateToAngle(date: event.startDate)
                let endAngle = self.dateToAngle(date: event.endDate)

                let eventPath = Path { path in
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                }

                context.stroke(eventPath, with: .color(event.color), lineWidth: 12)

                let startX = center.x + Foundation.cos(startAngle.radians) * radius
                let startY = center.y + Foundation.sin(startAngle.radians) * radius
                let startPoint = CGPoint(x: startX, y: startY)

                let endX = center.x + Foundation.cos(endAngle.radians) * radius
                let endY = center.y + Foundation.sin(endAngle.radians) * radius
                let endPoint = CGPoint(x: endX, y: endY)

                let startCircleRect = CGRect(x: startPoint.x - 6, y: startPoint.y - 6, width: 12, height: 12)
                let startCircle = Circle().path(in: startCircleRect)
                context.fill(startCircle, with: .color(event.color))

                let endCircleRect = CGRect(x: endPoint.x - 6, y: endPoint.y - 6, width: 12, height: 12)
                let endCircle = Circle().path(in: endCircleRect)
                context.fill(endCircle, with: .color(event.color))
            }

            let centerCircleRect = CGRect(x: center.x - 40, y: center.y - 40, width: 80, height: 80)
            let centerCircle = Circle().path(in: centerCircleRect)

            context.fill(centerCircle, with: .color(.blue))
            context.stroke(centerCircle, with: .color(.white), lineWidth: 3)

            let yearText = String(self.year)
            context.draw(
                Text(yearText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white),
                at: center
            )
        }
    }

    func createArcPath(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, startAngle: Angle, endAngle: Angle) -> Path {
        return Path { path in
            path.addArc(center: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

            let endX = center.x + Foundation.cos(endAngle.radians) * innerRadius
            let endY = center.y + Foundation.sin(endAngle.radians) * innerRadius
            let endPoint = CGPoint(x: endX, y: endY)
            path.addLine(to: endPoint)

            path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            path.closeSubpath()
        }
    }

    func dateToAngle(date: Date) -> Angle {
        let calendar = Calendar.current
        let yearComponents = DateComponents(year: self.year, month: 1, day: 1)
        guard let startOfYear = calendar.date(from: yearComponents) else {
            return Angle.degrees(0)
        }

        let dayComponents = calendar.dateComponents([.day], from: startOfYear, to: date)
        let dayOfYear = dayComponents.day ?? 0
        let daysInYear = self.isLeapYear(year: self.year) ? 366 : 365

        var angle = Double(dayOfYear) / Double(daysInYear) * 360.0

        let startMonthComponents = DateComponents(year: self.year, month: self.startMonth + 1, day: 1)
        guard let startMonthDate = calendar.date(from: startMonthComponents) else {
            return Angle.degrees(angle - 90)
        }

        let startMonthDayComponents = calendar.dateComponents([.day], from: startOfYear, to: startMonthDate)
        let startMonthDay = startMonthDayComponents.day ?? 0
        let startMonthAngleOffset = Double(startMonthDay) / Double(daysInYear) * 360.0
        angle = angle - startMonthAngleOffset

        return Angle.degrees(angle - 90)
    }

    func isLeapYear(year: Int) -> Bool {
        let divisibleBy4 = (year % 4 == 0)
        let divisibleBy100 = (year % 100 == 0)
        let divisibleBy400 = (year % 400 == 0)

        if divisibleBy400 {
            return true
        }
        if divisibleBy100 {
            return false
        }
        if divisibleBy4 {
            return true
        }
        return false
    }
}
