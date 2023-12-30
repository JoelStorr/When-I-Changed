import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
   
    
    
    
    let allSpecialDays = StorageProvider.shared.loadAllSpecialDays()
    
    
    //Dummy data of what the widget will look like
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), configuration: allSpecialDays[0])
    }

    //How does the Widget look right now (is shown in the Gallary when the user selects the widget)
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> DayEntry {
        DayEntry(date: Date(), configuration: allSpecialDays[0])
    }
    
    // Array of entries when the Widgtes changes
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<DayEntry> {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of seve entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDay = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDay, configuration: allSpecialDays[0])
            entries.append(entry)
        }
        
        //The policy says when to update the Timline in this case every 5 hours
        return Timeline(entries: entries, policy: .atEnd)
    }
}

//Is the Data structure in the widget to populate it
struct DayEntry: TimelineEntry {
    let date: Date
    let configuration: SpecialDay
}

//Swift UI View of you widget
struct MonthlyWidgetEntryView : View {
    var entry: DayEntry
    var config: SpecialDay
    let dateFormatter = DateFormatter()
    init(entry: DayEntry) {
        self.entry = entry
        self.config = StorageProvider.shared.loadAllSpecialDays()[0]
    }
    
   @State var image = UIImage()
    @State var interval = Date() - Date()

    var body: some View {
       
      
        ZStack{
            
           ContainerRelativeShape()
                .fill(cardColorConverter(color: config.color!))
            ZStack{
                
                if config.image == nil {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(
                            config.image != nil ?  Color.black.opacity(0) : cardColorConverter(color: config.color ?? "green"))
                        
                        .frame(width: 200, height: 200)
                    
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    
                    
                }
                
                VStack{
                    Spacer()
                    
                    Text("\(interval.day!)")
                        .fontWeight(.black)
                        .font(.custom(config.font!, size: 80))
                        .foregroundStyle(config.image == nil ? Color.white : cardColorConverter(color: config.color!))
                    Spacer()
                    Text(config.name!)
                        .font(.custom(config.font!, size: 30))
                        .fontWeight(.black)
                        .foregroundStyle(config.image == nil ? Color.white : cardColorConverter(color: config.color!))
                    if !config.dateToggle {
                        Text(formatDate(date: config.date!))
                            .font(.custom(config.font!, size: 15))
                            .foregroundStyle(config.image == nil ? Color.white : cardColorConverter(color: config.color!))
                    }
                }
            }
            .onAppear{
                if config.image != nil {
                    image = UIImage(data: config.image!)!
                }
                interval = config.date! - Date()
            }
           
        }
    }
    
    
    func formatDate(date: Date)-> String {
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = Locale.autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
}

//The Actual Widget
struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ChangeDayIntent.self, provider: Provider()) { entry in
                    MonthlyWidgetEntryView(entry: entry)
                }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month")
        .supportedFamilies([.systemSmall])
    }
}

//Disspalys the Infos to the widget in the Gallery
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .systemSmall) {
//    MonthlyWidget()
//} timeline: {
//    DayEntry(date: .now, configuration: .smiley)
//    DayEntry(date: .now, configuration: .starEyes)
//}

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}
