import SwiftUI
import PlaygroundSupport

// MARK: - Data Models

struct CalendarEvent: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    var color: Color
}

// MARK: - Main App

struct CircularCalendarApp: View {
    @State private var events: [CalendarEvent] = []
    @State private var startMonth: Int = 1 // February (0-indexed)
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

                // Controls
                VStack(spacing: 15) {
                    // Start month and year
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Monat bei 12:00 Uhr:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Start Monat", selection: $startMonth) {
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
                            Picker("Jahr", selection: $selectedYear) {
                                ForEach(2020...2030, id: \.self) { year in
                                    Text(String(year)).tag(year)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }

                    Divider()

                    // Event input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Neues Ereignis:")
                            .font(.headline)

                        TextField("Titel", text: $eventTitle)
                            .textFieldStyle(.roundedBorder)

                        HStack(spacing: 15) {
                            VStack(alignment: .leading) {
                                Text("Startdatum:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: $startDate, displayedComponents: .date)
                                    .labelsHidden()
                            }

                            VStack(alignment: .leading) {
                                Text("Enddatum:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: $endDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                        }

                        Button(action: addEvent) {
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

                // Calendar Circle
                CircularCalendarView(
                    events: events,
                    startMonth: startMonth,
                    year: selectedYear
                )
                .frame(width: 500, height: 500)
                .padding()

                // Event List
                if !events.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ereignisse:")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(events) { event in
                            EventRow(event: event, onDelete: {
                                deleteEvent(event)
                            })
                        }
                    }
                }
            }
            .padding()
        }
        .alert("Hinweis", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    func addEvent() {
        guard !eventTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Bitte geben Sie einen Titel ein."
            showingAlert = true
            return
        }

        let calendar = Calendar.current
        guard calendar.component(.year, from: startDate) == selectedYear,
              calendar.component(.year, from: endDate) == selectedYear else {
            alertMessage = "Beide Daten müssen im Jahr \(selectedYear) liegen."
            showingAlert = true
            return
        }

        guard startDate <= endDate else {
            alertMessage = "Das Startdatum muss vor dem Enddatum liegen."
            showingAlert = true
            return
        }

        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .cyan, .mint]
        let color = colors[events.count % colors.count]

        let event = CalendarEvent(
            title: eventTitle,
            startDate: startDate,
            endDate: endDate,
            color: color
        )

        events.append(event)
        eventTitle = ""
    }

    func deleteEvent(_ event: CalendarEvent) {
        events.removeAll { $0.id == event.id }
    }
}

// MARK: - Event Row

struct EventRow: View {
    let event: CalendarEvent
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(event.color)

                Text("\(event.startDate, style: .date) - \(event.endDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onDelete) {
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

            // Draw month segments
            for i in 0..<12 {
                let monthIndex = (startMonth + i) % 12
                let startAngle = Angle.degrees(Double(i * 30) - 90)
                let endAngle = Angle.degrees(Double((i + 1) * 30) - 90)

                // Draw month arc
                let monthPath = createArcPath(
                    center: center,
                    innerRadius: innerRadius,
                    outerRadius: outerRadius,
                    startAngle: startAngle,
                    endAngle: endAngle
                )

                context.fill(monthPath, with: .color(monthColors[monthIndex].opacity(0.6)))
                context.stroke(monthPath, with: .color(.white), lineWidth: 2)

                // Draw month label
                let labelAngle = Angle.degrees(Double(i * 30 + 15) - 90)
                let labelRadius = (outerRadius + innerRadius) / 2
                let labelPoint = CGPoint(
                    x: center.x + cos(labelAngle.radians) * labelRadius,
                    y: center.y + sin(labelAngle.radians) * labelRadius
                )

                context.draw(
                    Text(monthNamesShort[monthIndex])
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary),
                    at: labelPoint
                )
            }

            // Draw events
            for (index, event) in events.enumerated() {
                let radius = eventRadius - CGFloat(index * 20)
                guard radius > innerRadius * 0.3 else { continue }

                let startAngle = dateToAngle(date: event.startDate)
                let endAngle = dateToAngle(date: event.endDate)

                // Draw event arc
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

                // Draw start and end markers
                let startPoint = CGPoint(
                    x: center.x + cos(startAngle.radians) * radius,
                    y: center.y + sin(startAngle.radians) * radius
                )
                let endPoint = CGPoint(
                    x: center.x + cos(endAngle.radians) * radius,
                    y: center.y + sin(endAngle.radians) * radius
                )

                context.fill(Circle().path(in: CGRect(x: startPoint.x - 6, y: startPoint.y - 6, width: 12, height: 12)), with: .color(event.color))
                context.fill(Circle().path(in: CGRect(x: endPoint.x - 6, y: endPoint.y - 6, width: 12, height: 12)), with: .color(event.color))
            }

            // Draw center circle
            let centerCircle = Circle()
                .path(in: CGRect(
                    x: center.x - 40,
                    y: center.y - 40,
                    width: 80,
                    height: 80
                ))

            context.fill(centerCircle, with: .color(.blue))
            context.stroke(centerCircle, with: .color(.white), lineWidth: 3)

            // Draw year in center
            context.draw(
                Text(String(year))
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
                x: center.x + cos(endAngle.radians) * innerRadius,
                y: center.y + sin(endAngle.radians) * innerRadius
            ))
            path.addArc(center: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            path.closeSubpath()
        }
    }

    func dateToAngle(date: Date) -> Angle {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let dayOfYear = calendar.dateComponents([.day], from: startOfYear, to: date).day ?? 0
        let daysInYear = isLeapYear(year) ? 366 : 365

        // Calculate angle (0 = top)
        var angle = Double(dayOfYear) / Double(daysInYear) * 360.0

        // Adjust for start month
        let startMonthDate = calendar.date(from: DateComponents(year: year, month: startMonth + 1, day: 1))!
        let startMonthDay = calendar.dateComponents([.day], from: startOfYear, to: startMonthDate).day ?? 0
        angle -= Double(startMonthDay) / Double(daysInYear) * 360.0

        return Angle.degrees(angle - 90)
    }

    func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
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

// MARK: - Playground Live View

PlaygroundPage.current.setLiveView(
    CircularCalendarApp()
        .frame(width: 800, height: 1200)
)
