# Zirkularer Kalender - Swift Playground für iPad

## Installation auf dem iPad

### Methode 1: Direkt aus GitHub (empfohlen)

1. **Swift Playgrounds App installieren**
   - Öffnen Sie den App Store auf Ihrem iPad
   - Suchen Sie nach "Swift Playgrounds"
   - Installieren Sie die kostenlose App von Apple

2. **Code herunterladen**
   - Öffnen Sie Safari auf dem iPad
   - Gehen Sie zu: `https://github.com/thomashalfmann/familie`
   - Navigieren Sie zur Datei `CircularCalendar.swift`
   - Tippen Sie oben rechts auf **"Raw"**
   - Der Code wird angezeigt

3. **Code kopieren**
   - Halten Sie lange auf den Text gedrückt
   - Wählen Sie "Alles auswählen"
   - Tippen Sie auf "Kopieren"

4. **In Swift Playgrounds einfügen**
   - Öffnen Sie Swift Playgrounds
   - Tippen Sie auf "+" (oben rechts)
   - Wählen Sie "Blank"
   - Löschen Sie den vorhandenen Code
   - Fügen Sie den kopierten Code ein (lange drücken → Einsetzen)
   - Tippen Sie auf "Run" (▶️)

### Methode 2: Via iCloud Drive

1. Laden Sie die Datei `CircularCalendar.swift` auf Ihren Computer herunter
2. Speichern Sie sie in iCloud Drive
3. Öffnen Sie Swift Playgrounds auf dem iPad
4. Importieren Sie die Datei aus iCloud Drive

## Features

✅ **Kreisförmige Monatsdarstellung** - Alle 12 Monate als farbige Segmente
✅ **Konfigurierbare Startposition** - Welcher Monat bei 12:00 Uhr steht
✅ **Jahresauswahl** - Jahr wird zentral angezeigt
✅ **Ereignisse hinzufügen** - Mit Titel, Start- und Enddatum
✅ **Visuelle Zeiträume** - Als farbige Bögen im Kreis
✅ **Ereignisliste** - Übersicht aller Ereignisse
✅ **Löschen-Funktion** - Ereignisse einzeln entfernen
✅ **Native iPad UI** - SwiftUI mit nativer Performance

## Bedienung

1. Wählen Sie den Monat für die 12:00 Uhr Position (Standard: Februar)
2. Stellen Sie das Jahr ein (Standard: 2025)
3. Geben Sie einen Titel für Ihr Ereignis ein
4. Wählen Sie Startdatum mit dem DatePicker
5. Wählen Sie Enddatum mit dem DatePicker
6. Tippen Sie auf "Zeitraum hinzufügen"
7. Der Zeitraum erscheint als farbiger Bogen im Kreis

## Vorteile gegenüber der Web-Version

- ⚡ Native Performance auf dem iPad
- 📱 Bessere Touch-Bedienung
- 🎨 Native iOS Design Language
- 🔄 Keine Internetverbindung nach dem Download nötig
- 📐 Optimiert für iPad-Bildschirme

## Technische Details

- **Sprache**: Swift 5.9+
- **Framework**: SwiftUI
- **Zeichnung**: Canvas API
- **Kompatibilität**: iPad mit iOS 15+
- **App**: Swift Playgrounds 4.0+

## Troubleshooting

**Problem**: Code läuft nicht
- Lösung: Stellen Sie sicher, dass Sie Swift Playgrounds 4.0 oder neuer verwenden

**Problem**: UI wird nicht angezeigt
- Lösung: Warten Sie einen Moment nach dem Drücken von Run

**Problem**: Datum-Picker funktioniert nicht richtig
- Lösung: Stellen Sie sicher, dass die Daten im ausgewählten Jahr liegen

## Screenshot-Beschreibung

Die App zeigt:
- Oben: Titel und Steuerelemente
- Mitte: Großer Kalenderkreis mit Monaten und Ereignissen
- Unten: Liste der hinzugefügten Ereignisse
- Alles scrollbar für kleinere iPad-Bildschirme
