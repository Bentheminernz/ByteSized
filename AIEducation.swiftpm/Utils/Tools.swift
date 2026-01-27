//
//  Tools.swift
//  ByteSized
//
//  Created by Ben Lawrence on 11/01/2026.
//

@preconcurrency import Contacts
@preconcurrency import EventKit
import Foundation
import FoundationModels

// MARK: - Weather
/// A mock weather tool that simulates fetching current weather data for a specified city.
/// For some reason WeatherKit refused to work in my app playground so i have to simulate it instead.
struct WeatherTool: Tool {
  let name = "get_weather"
  let description =
    "Get the current weather conditions for a specified city including temperature, condition, and humidity."

  /// Arguments for the weather tool
  @Generable
  struct Arguments {
    /// The city to get the weather for
    let city: String
  }

  /// Simulated weather data for common cities
  private let mockWeatherData:
    [String: (temp: Double, condition: String, humidity: Double, wind: Double)] =
      [
        "san francisco": (16.5, "Partly Cloudy", 0.72, 12.5),
        "new york": (8.0, "Clear", 0.45, 15.2),
        "london": (7.5, "Rainy", 0.88, 18.0),
        "tokyo": (12.0, "Cloudy", 0.65, 8.3),
        "paris": (9.5, "Overcast", 0.78, 10.5),
        "sydney": (25.0, "Sunny", 0.55, 14.0),
        "seattle": (11.0, "Rainy", 0.85, 16.8),
        "miami": (28.0, "Sunny", 0.68, 9.2),
        "chicago": (3.0, "Snow", 0.70, 22.0),
        "los angeles": (20.0, "Sunny", 0.50, 7.5),
      ]

  /// Fetches simulated weather data for the specified city
  func call(arguments: Arguments) async throws -> GeneratedContent {
    let cityKey = arguments.city.lowercased()

    if let weatherData = mockWeatherData[cityKey] {
      let weatherInfo = """
        Weather for \(arguments.city):
        - Temperature: \(String(format: "%.1f", weatherData.temp))°C
        - Condition: \(weatherData.condition)
        - Humidity: \(Int(weatherData.humidity * 100))%
        - Wind Speed: \(String(format: "%.1f", weatherData.wind)) km/h

        (Note: This is simulated weather data for demonstration purposes. Please state to the user that this is not real data.)
        """
      return GeneratedContent(weatherInfo)
    }

    let randomTemp = Double.random(in: -5...35)
    let conditions = [
      "Sunny", "Partly Cloudy", "Cloudy", "Rainy", "Clear", "Overcast",
    ]
    let randomCondition = conditions.randomElement()!
    let randomHumidity = Int.random(in: 40...90)
    let randomWind = Double.random(in: 5...25)

    let weatherInfo = """
      Weather for \(arguments.city):
      - Temperature: \(String(format: "%.1f", randomTemp))°C
      - Condition: \(randomCondition)
      - Humidity: \(randomHumidity)%
      - Wind Speed: \(String(format: "%.1f", randomWind)) km/h

      (Note: This is simulated weather data for demonstration purposes. Please state to the user that this is not real data.)
      """

    return GeneratedContent(weatherInfo)
  }
}

// MARK: - Contacts Tool
/// A tool to search the user's contacts by name and retrieve contact information.
/// Contacts API actually works here?????
/// Not sure why this is 270~ lines but oh well.
struct ContactsTool: Tool {
  let name = "search_contacts"
  let description =
    "Search for contacts by name and retrieve their contact information including phone numbers and email addresses."

  private let contactStore = CNContactStore()

  @Generable
  struct Arguments {
    let name: String
    let limit: Int?
  }

  func call(arguments: Arguments) async throws -> GeneratedContent {
    // check contacts access
    guard try await ensureContactsAccess() else {
      return GeneratedContent(
        "Contact access is not authorized. Please enable contacts access in Settings."
      )
    }

    do {
      let contacts = try fetchContacts(
        matching: arguments.name,
        limit: arguments.limit ?? 5
      )

      if contacts.isEmpty {
        return GeneratedContent(
          "No contacts found matching '\(arguments.name)'."
        )
      }

      let formatted = contacts.enumerated().map { index, contact in
        formatContact(contact, number: index + 1)
      }.joined(separator: "\n\n")

      let header =
        "Found \(contacts.count) contact(s) matching '\(arguments.name)':\n\n"
      return GeneratedContent(header + formatted)

    } catch {
      return GeneratedContent(
        "Error searching contacts: \(error.localizedDescription)"
      )
    }
  }

  /// Ensure the app has access to contacts
  private func ensureContactsAccess() async throws -> Bool {
    let authStatus = CNContactStore.authorizationStatus(for: .contacts)

    switch authStatus {
    case .authorized:
      return true
    case .notDetermined:
      return try await contactStore.requestAccess(for: .contacts)
    default:
      return false
    }
  }

  /// fetches the contacts!!!
  private func fetchContacts(matching name: String, limit: Int) throws
    -> [CNContact]
  {
    let keysToFetch: [CNKeyDescriptor] = [
      CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey,
      CNContactNamePrefixKey,
      CNContactNameSuffixKey, CNContactNicknameKey,
      CNContactPhoneticGivenNameKey,
      CNContactPhoneticMiddleNameKey, CNContactPhoneticFamilyNameKey,
      CNContactOrganizationNameKey,
      CNContactDepartmentNameKey, CNContactJobTitleKey,
      CNContactPhoneNumbersKey,
      CNContactEmailAddressesKey, CNContactPostalAddressesKey,
      CNContactUrlAddressesKey,
      CNContactBirthdayKey, CNContactNonGregorianBirthdayKey, CNContactDatesKey,
      CNContactInstantMessageAddressesKey, CNContactSocialProfilesKey,
      CNContactRelationsKey,
    ].map { $0 as CNKeyDescriptor }

    let predicate = CNContact.predicateForContacts(matchingName: name)
    let contacts = try contactStore.unifiedContacts(
      matching: predicate,
      keysToFetch: keysToFetch
    )
    return Array(contacts.prefix(limit))
  }

  /// formats the response into a nice string
  private func formatContact(_ contact: CNContact, number: Int) -> String {
    var sections: [String] = []

    sections.append("CONTACT \(number)")

    if let nameSection = formatNameSection(contact) {
      sections.append(nameSection)
    }

    if let workSection = formatWorkSection(contact) {
      sections.append(workSection)
    }

    // Contact methods
    sections.append(
      contentsOf: [
        formatLabeledValues(contact.phoneNumbers, title: "Phone Numbers") {
          $0.stringValue
        },
        formatLabeledValues(contact.emailAddresses, title: "Email Addresses") {
          $0 as String
        },
        formatAddresses(contact.postalAddresses),
        formatLabeledValues(contact.urlAddresses, title: "Websites") {
          $0 as String
        },
        formatSocialProfiles(contact.socialProfiles),
        formatInstantMessages(contact.instantMessageAddresses),
      ].compactMap { $0 }
    )

    sections.append(
      contentsOf: [
        formatBirthday(contact.birthday),
        formatDates(contact.dates),
        formatRelations(contact.contactRelations),
      ].compactMap { $0 }
    )

    return sections.joined(separator: "\n\n")
  }

  private func formatNameSection(_ contact: CNContact) -> String? {
    var lines: [String] = []

    let nameParts = [
      contact.namePrefix, contact.givenName, contact.middleName,
      contact.familyName, contact.nameSuffix,
    ].filter { !$0.isEmpty }

    if !nameParts.isEmpty {
      lines.append("Name: \(nameParts.joined(separator: " "))")
    }

    if !contact.nickname.isEmpty {
      lines.append("   Nickname: \(contact.nickname)")
    }

    let phoneticParts = [
      contact.phoneticGivenName, contact.phoneticMiddleName,
      contact.phoneticFamilyName,
    ].filter { !$0.isEmpty }

    if !phoneticParts.isEmpty {
      lines.append("   Phonetic: \(phoneticParts.joined(separator: " "))")
    }

    return lines.isEmpty ? nil : lines.joined(separator: "\n")
  }

  private func formatWorkSection(_ contact: CNContact) -> String? {
    var lines: [String] = []

    if !contact.organizationName.isEmpty {
      lines.append("   Company: \(contact.organizationName)")
    }
    if !contact.departmentName.isEmpty {
      lines.append("   Department: \(contact.departmentName)")
    }
    if !contact.jobTitle.isEmpty {
      lines.append("   Job Title: \(contact.jobTitle)")
    }

    guard !lines.isEmpty else { return nil }
    return "Work:\n" + lines.joined(separator: "\n")
  }

  private func formatLabeledValues<T>(
    _ values: [CNLabeledValue<T>],
    title: String,
    transform: (T) -> String
  ) -> String? {
    guard !values.isEmpty else { return nil }

    let lines = values.map { value in
      let label = CNLabeledValue<NSString>.localizedString(
        forLabel: value.label ?? ""
      )
      return "   \(label): \(transform(value.value))"
    }

    return "\(title):\n" + lines.joined(separator: "\n")
  }

  private func formatAddresses(_ addresses: [CNLabeledValue<CNPostalAddress>])
    -> String?
  {
    guard !addresses.isEmpty else { return nil }

    let lines = addresses.map { address in
      let label = CNLabeledValue<NSString>.localizedString(
        forLabel: address.label ?? ""
      )
      let postal = address.value

      var parts = ["   \(label):"]
      if !postal.street.isEmpty { parts.append("      \(postal.street)") }

      let cityLine = [postal.city, postal.state, postal.postalCode]
        .filter { !$0.isEmpty }
        .joined(separator: " ")
      if !cityLine.isEmpty { parts.append("      \(cityLine)") }

      if !postal.country.isEmpty { parts.append("      \(postal.country)") }

      return parts.joined(separator: "\n")
    }

    return "Addresses:\n" + lines.joined(separator: "\n")
  }

  private func formatSocialProfiles(
    _ profiles: [CNLabeledValue<CNSocialProfile>]
  ) -> String? {
    guard !profiles.isEmpty else { return nil }

    let lines = profiles.map { profile in
      let service = profile.value.service
      let username = profile.value.username
      return "   \(service): \(username)"
    }

    return "Social Profiles:\n" + lines.joined(separator: "\n")
  }

  private func formatInstantMessages(
    _ messages: [CNLabeledValue<CNInstantMessageAddress>]
  ) -> String? {
    guard !messages.isEmpty else { return nil }

    let lines = messages.map { im in
      let service = im.value.service
      let username = im.value.username
      return "   \(service): \(username)"
    }

    return "Instant Messaging:\n" + lines.joined(separator: "\n")
  }

  private func formatBirthday(_ birthday: DateComponents?) -> String? {
    guard let birthday = birthday,
      let month = birthday.month,
      let day = birthday.day
    else { return nil }

    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d"

    var components = DateComponents(month: month, day: day)
    if let year = birthday.year {
      components.year = year
    }

    guard let date = Calendar.current.date(from: components) else { return nil }

    var result = "Birthday: \(formatter.string(from: date))"
    if let year = birthday.year {
      result += ", \(year)"
    }

    return result
  }

  private func formatDates(_ dates: [CNLabeledValue<NSDateComponents>])
    -> String?
  {
    guard !dates.isEmpty else { return nil }

    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"

    let lines = dates.compactMap { date -> String? in
      let dc: DateComponents = date.value as DateComponents
      guard let year = dc.year, let month = dc.month, let day = dc.day else {
        return nil
      }

      var components = DateComponents()
      components.year = year
      components.month = month
      components.day = day
      guard let dateObj = Calendar.current.date(from: components) else {
        return nil
      }

      let label = CNLabeledValue<NSString>.localizedString(
        forLabel: date.label ?? ""
      )
      return "   \(label): \(formatter.string(from: dateObj))"
    }

    guard !lines.isEmpty else { return nil }
    return "Important Dates:\n" + lines.joined(separator: "\n")
  }

  private func formatRelations(_ relations: [CNLabeledValue<CNContactRelation>])
    -> String?
  {
    guard !relations.isEmpty else { return nil }

    let lines = relations.map { relation in
      let label = CNLabeledValue<NSString>.localizedString(
        forLabel: relation.label ?? ""
      )
      return "   \(label): \(relation.value.name)"
    }

    return "Relations:\n" + lines.joined(separator: "\n")
  }
}

// MARK: - Calendar Tool
struct CalendarTool: Tool {
  let name = "fetch_calendar_events"
  let description =
    "Fetch calendar events within a specified date range. Can retrieve upcoming events, past events, or events within a custom date range."

  nonisolated(unsafe) private let eventStore = EKEventStore()

  @Generable
  struct Arguments {
    /// Number of days to look ahead (default: 7). Use negative values to look back in time.
    let daysAhead: Int?

    /// Start date in ISO 8601 format (e.g., "2024-01-15"). If provided, overrides daysAhead.
    let startDate: String?

    /// End date in ISO 8601 format (e.g., "2024-01-20"). Required if startDate is provided.
    let endDate: String?

    /// Maximum number of events to return (default: 20)
    let limit: Int?

    /// Filter by calendar name (optional)
    let calendarName: String?
  }

  func call(arguments: Arguments) async throws -> GeneratedContent {
    // Check authorization
    guard try await ensureCalendarAccess() else {
      return GeneratedContent(
        "Calendar access is not authorized. Please enable calendar access in Settings."
      )
    }

    do {
      // Determine date range
      let (startDate, endDate) = try determineDateRange(arguments)

      // Fetch events
      let events = fetchEvents(
        from: startDate,
        to: endDate,
        calendarName: arguments.calendarName
      )

      if events.isEmpty {
        return GeneratedContent("No events found in the specified date range.")
      }

      // Apply limit
      let limitedEvents = Array(events.prefix(arguments.limit ?? 20))

      // Format output
      let formatted = formatEvents(
        limitedEvents,
        startDate: startDate,
        endDate: endDate
      )
      return GeneratedContent(formatted)

    } catch {
      return GeneratedContent(
        "Error fetching calendar events: \(error.localizedDescription)"
      )
    }
  }

  // MARK: - Helper Methods

  private func ensureCalendarAccess() async throws -> Bool {
    let status = EKEventStore.authorizationStatus(for: .event)

    switch status {
    case .authorized, .fullAccess:
      return true
    case .notDetermined:
      return try await eventStore.requestFullAccessToEvents()
    default:
      return false
    }
  }

  private func determineDateRange(_ arguments: Arguments) throws -> (Date, Date)
  {
    let calendar = Calendar.current
    let now = Date()

    // Custom date range
    if let startDateStr = arguments.startDate {
      guard let endDateStr = arguments.endDate else {
        throw NSError(
          domain: "CalendarTool",
          code: 1,
          userInfo: [
            NSLocalizedDescriptionKey:
              "endDate is required when startDate is provided"
          ]
        )
      }

      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withFullDate]

      guard let start = formatter.date(from: startDateStr) else {
        throw NSError(
          domain: "CalendarTool",
          code: 2,
          userInfo: [
            NSLocalizedDescriptionKey:
              "Invalid startDate format. Use ISO 8601 (e.g., 2024-01-15)"
          ]
        )
      }

      guard let end = formatter.date(from: endDateStr) else {
        throw NSError(
          domain: "CalendarTool",
          code: 3,
          userInfo: [
            NSLocalizedDescriptionKey:
              "Invalid endDate format. Use ISO 8601 (e.g., 2024-01-20)"
          ]
        )
      }

      // Set end date to end of day
      let endOfDay = calendar.startOfDay(for: end).addingTimeInterval(86400 - 1)
      return (calendar.startOfDay(for: start), endOfDay)
    }

    // Days ahead/behind
    let days = arguments.daysAhead ?? 7
    let startOfToday = calendar.startOfDay(for: now)

    if days >= 0 {
      // Looking forward
      let endDate = calendar.date(
        byAdding: .day,
        value: days,
        to: startOfToday
      )!
      .addingTimeInterval(86400 - 1)  // End of the last day
      return (startOfToday, endDate)
    } else {
      // Looking backward
      let startDate = calendar.date(
        byAdding: .day,
        value: days,
        to: startOfToday
      )!
      let endOfToday = startOfToday.addingTimeInterval(86400 - 1)
      return (startDate, endOfToday)
    }
  }

  private func fetchEvents(
    from startDate: Date,
    to endDate: Date,
    calendarName: String?
  ) -> [EKEvent] {
    // Filter calendars if needed
    let calendars: [EKCalendar]
    if let calendarName = calendarName {
      calendars = eventStore.calendars(for: .event).filter {
        $0.title.localizedCaseInsensitiveContains(calendarName)
      }
      if calendars.isEmpty {
        return []
      }
    } else {
      calendars = eventStore.calendars(for: .event)
    }

    // Create predicate and fetch
    let predicate = eventStore.predicateForEvents(
      withStart: startDate,
      end: endDate,
      calendars: calendars
    )

    return eventStore.events(matching: predicate).sorted {
      $0.startDate < $1.startDate
    }
  }

  private func formatEvents(_ events: [EKEvent], startDate: Date, endDate: Date)
    -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none

    var output =
      "Calendar Events (\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate)))"
    output += "Found \(events.count) event(s)"

    let groupedEvents = Dictionary(grouping: events) { event -> Date in
      Calendar.current.startOfDay(for: event.startDate)
    }

    let sortedDays = groupedEvents.keys.sorted()

    for day in sortedDays {
      guard let dayEvents = groupedEvents[day] else { continue }

      output += formatDay(day, events: dayEvents)
      output += "\n"
    }

    return output.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func formatDay(_ day: Date, events: [EKEvent]) -> String {
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "EEEE, MMMM d, yyyy"

    var output = "▸ \(dayFormatter.string(from: day))\n"

    for event in events {
      output += formatEvent(event)
      output += "\n"
    }

    return output
  }

  private func formatEvent(_ event: EKEvent) -> String {
    var lines: [String] = []

    // Time and title
    let timeStr = formatEventTime(event)
    lines.append("\(timeStr)")
    lines.append("\(event.title ?? "Untitled Event")")

    // Calendar
    if let calendar = event.calendar {
      lines.append("Calendar: \(calendar.title)")
    }

    // Location
    if let location = event.location, !location.isEmpty {
      lines.append("Location: \(location)")
    }

    // Attendees
    if let attendees = event.attendees, !attendees.isEmpty {
      let names = attendees.compactMap { participant -> String? in
        if let name = participant.name, !name.isEmpty {
          return name
        }
        // In newer SDKs, `participant.url` is non-optional. Handle it directly.
        let url = participant.url
        if url.scheme?.lowercased() == "mailto" {
          // For mailto:john@example.com, extract the email from the URL
          if let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
          ) {
            let email = components.path
            if !email.isEmpty { return email }
          }
          // Fallbacks: try path directly, then strip the scheme manually
          let pathEmail = url.path
          if !pathEmail.isEmpty { return pathEmail }
          let absolute = url.absoluteString
          let stripped = absolute.replacingOccurrences(of: "mailto:", with: "")
          return stripped.isEmpty ? nil : stripped
        }
        return nil
      }.prefix(3)
      let attendeeStr = names.joined(separator: ", ")
      let suffix = attendees.count > 3 ? " (+\(attendees.count - 3) more)" : ""
      lines.append("  👥 Attendees: \(attendeeStr)\(suffix)")
    }

    // Notes
    if let notes = event.notes, !notes.isEmpty {
      let preview = notes.prefix(100)
      let suffix = notes.count > 100 ? "..." : ""
      lines.append("  📄 Notes: \(preview)\(suffix)")
    }

    // Status
    if event.status == .canceled {
      lines.append("  ❌ Status: CANCELED")
    }

    // URL
    if let url = event.url {
      lines.append("  🔗 URL: \(url.absoluteString)")
    }

    return lines.joined(separator: "\n")
  }

  private func formatEventTime(_ event: EKEvent) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .short

    if event.isAllDay {
      return "All Day"
    }

    let start = timeFormatter.string(from: event.startDate)
    let end = timeFormatter.string(from: event.endDate)

    // Calculate duration
    let duration = event.endDate.timeIntervalSince(event.startDate)
    let hours = Int(duration) / 3600
    let minutes = (Int(duration) % 3600) / 60

    var durationStr = ""
    if hours > 0 && minutes > 0 {
      durationStr = " (\(hours)h \(minutes)m)"
    } else if hours > 0 {
      durationStr = " (\(hours)h)"
    } else if minutes > 0 {
      durationStr = " (\(minutes)m)"
    }

    return "\(start) - \(end)\(durationStr)"
  }
}
