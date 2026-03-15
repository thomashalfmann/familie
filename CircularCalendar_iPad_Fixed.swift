import SwiftUI

// MARK: - Data Models

struct CalendarEvent: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    var color: Color
}

// MARK: - Constants

let monthNames = ["Januar", "Februar", "März", "April", "Mai", "Juni",
                  "Juli", "August", "September", "Oktober", "November", "Dezember"]

let monthNamesShort = ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun",
                       "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]

let monthColors: [Color] = [
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

// MARK: - Date Formatter Helper

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.locale = Locale(identifier: "de_DE")
    return formatter.string(from: date)
}

// MARK: - Main View

struct ContentView: View {
    @State private var events: [CalendarEvent] = []
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

                if !self.events.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ereignisse:")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(self.events) { event in
                            EventRow(event: event) {
                                self.deleteEvent(event)
                            }
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
        guard !self.eventTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.alertMessage = "Bitte geben Sie einen Titel ein."
            self.showingAlert = true
            return
        }

        let calendar = Calendar.current
        guard calendar.component(.year, from: self.startDate) == self.selectedYear,
              calendar.component(.year, from: self.endDate) == self.selectedYear else {
            self.alertMessage = "Beide Daten müssen im Jahr \(self.selectedYear) liegen."
            self.showingAlert = true
            return
        }

        guard self.startDate <= self.endDate else {
            self.alertMessage = "Das Startdatum muss vor dem Enddatum liegen."
            self.showingAlert = true
            return
        }

        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .cyan, .mint]
        let color = colors[self.events.count % colors.count]

        let event = CalendarEvent(
            title: self.eventTitle,
            startDate: self.startDate,
            endDate: self.endDate,
            color: color
        )

        self.events.append(event)
        self.eventTitle = ""
    }

    func deleteEvent(_ event: CalendarEvent) {
        self.events.removeAll { item in
            item.id == event.id
        }
    }
}

// MARK: - Event Row

struct EventRow: View {
    let event: CalendarEvent
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(self.event.title)
                    .font(.headline)
                    .foregroundColor(self.event.color)

                Text(formatDate(self.event.startDate) + " - " + formatDate(self.event.endDate))
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

// MARK: - Circular Calendar View

struct CircularCalendarView: View {
    let events: [CalendarEvent]
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
                let startAngle = Angle.degrees(Double(i * 30) - 90)
                let endAngle = Angle.degrees(Double((i + 1) * 30) - 90)

                let monthPath = self.createArcPath(
                    center: center,
                    innerRadius: innerRadius,
                    outerRadius: outerRadius,
                    startAngle: startAngle,
                    endAngle: endAngle
                )

                context.fill(monthPath, with: .color(monthColors[monthIndex].opacity(0.6)))
                context.stroke(monthPath, with: .color(.white), lineWidth: 2)

                let labelAngle = Angle.degrees(Double(i * 30 + 15) - 90)
                let labelRadius = (outerRadius + innerRadius) / 2
                let labelPoint = CGPoint(
                    x: center.x + Foundation.cos(labelAngle.radians) * labelRadius,
                    y: center.y + Foundation.sin(labelAngle.radians) * labelRadius
                )

                context.draw(
                    Text(monthNamesShort[monthIndex])
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary),
                    at: labelPoint
                )
            }

            for (index, event) in self.events.enumerated() {
                let radius = eventRadius - CGFloat(index * 20)
                guard radius > innerRadius * 0.3 else { continue }

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

                let startPoint = CGPoint(
                    x: center.x + Foundation.cos(startAngle.radians) * radius,
                    y: center.y + Foundation.sin(startAngle.radians) * radius
                )
                let endPoint = CGPoint(
                    x: center.x + Foundation.cos(endAngle.radians) * radius,
                    y: center.y + Foundation.sin(endAngle.radians) * radius
                )

                context.fill(Circle().path(in: CGRect(x: startPoint.x - 6, y: startPoint.y - 6, width: 12, height: 12)), with: .color(event.color))
                context.fill(Circle().path(in: CGRect(x: endPoint.x - 6, y: endPoint.y - 6, width: 12, height: 12)), with: .color(event.color))
            }

            let centerCircle = Circle()
                .path(in: CGRect(
                    x: center.x - 40,
                    y: center.y - 40,
                    width: 80,
                    height: 80
                ))

            context.fill(centerCircle, with: .color(.blue))
            context.stroke(centerCircle, with: .color(.white), lineWidth: 3)

            context.draw(
                Text(String(self.year))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white),
                at: center
            )
        }
    }

    func createArcPath(center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, startAngle: Angle, endAngle: Angle) -> Path {
        Path { path in
            path.addArc(center: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.addLine(to: CGPoint(
                x: center.x + Foundation.cos(endAngle.radians) * innerRadius,
                y: center.y + Foundation.sin(endAngle.radians) * innerRadius
            ))
            path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            path.closeSubpath()
        }
    }

    func dateToAngle(date: Date) -> Angle {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: self.year, month: 1, day: 1))!
        let dayOfYear = calendar.dateComponents([.day], from: startOfYear, to: date).day ?? 0
        let daysInYear = self.isLeapYear(self.year) ? 366 : 365

        var angle = Double(dayOfYear) / Double(daysInYear) * 360.0

        let startMonthDate = calendar.date(from: DateComponents(year: self.year, month: self.startMonth + 1, day: 1))!
        let startMonthDay = calendar.dateComponents([.day], from: startOfYear, to: startMonthDate).day ?? 0
        angle -= Double(startMonthDay) / Double(daysInYear) * 360.0

        return Angle.degrees(angle - 90)
    }

    func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
}
