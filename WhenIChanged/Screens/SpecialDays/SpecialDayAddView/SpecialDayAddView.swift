//
//  SpecialDayAddView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 20.12.23.
//

import SwiftUI



enum SpecialDayEditMode {
    case name, design, color, font
}

enum WidgetSize: String {
    case small, medium
}


struct SpecialDayAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let pageArray = ["Name", "Design", "Color", "Font"]
    private let iconSize: CGFloat = 30.0
    
    let specialDay: SpecialDay?
    
    
    @State var editMode: SpecialDayEditMode = SpecialDayEditMode.name
    @State var pageIndex = 0
    @State var isAnimating: Bool = false
    var viewWidth = UIScreen.main.bounds.width
    private let dotAppearance = UIPageControl.appearance()
    
    
    // NOTE: Form Varaibles
    @State var name: String = ""
    @State var selectedDate: Date = .now
    @State var interval = Date() - Date()
    @State var toggleDate: Bool = false

    
    @State var selectedColor: String = CardColor.orange.rawValue
    @State var selectedImageData: Data? 
    @State var repeatNextYear: Bool = true // TODO: Implement
    
    @State var bgImage: Image?
    @State var selectedFont: String = "SF Pro"
    
        
    @State var widgetSize: WidgetSize = WidgetSize.small
    
    let dateFormatter = DateFormatter()
    
    
    
    var body: some View {
        
        
        
        VStack(alignment: .center) {
            HStack{
                Button{}label: {
                    Text("Small")
                }
                Button{}label: {
                    Text("Medium")
                }
            }
            Spacer()
                .frame(height: 10)
            
            
            ZStack{
                
                if bgImage == nil {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(
                            bgImage != nil ?  Color.black.opacity(0) : cardColorConverter(color: selectedColor))
                        
                        .frame(width: 200, height: 200)
                    
                } else {
                    bgImage!
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                
                VStack{
                    Spacer()
                    
                    Text("\(interval.day!)")
                        .fontWeight(.black)
                        .font(.custom(selectedFont, size: 80))
                        .foregroundStyle(bgImage == nil ? Color.white : cardColorConverter(color: selectedColor))
                    Spacer()
                    Text(name)
                        .font(.custom(selectedFont, size: 30))
                        .fontWeight(.black)
                        .foregroundStyle(bgImage == nil ? Color.white : cardColorConverter(color: selectedColor))
                    if !toggleDate {
                        Text(formatDate(date:selectedDate))
                            .font(.custom(selectedFont, size: 15))
                            .foregroundStyle(bgImage == nil ? Color.white : cardColorConverter(color: selectedColor))                        
                    }
                }
            }
            .frame(width: 200, height: 200)
            
            
            Spacer()
                .frame(height: 50)
            HStack() {
                Spacer()
                Button{
                    editMode = SpecialDayEditMode.name
                    pageIndex = 0
                    isAnimating = true
                }label: {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(pageIndex == 0 ? .red : .blue)
                    
                }
                Spacer()
                Button {
                    editMode = SpecialDayEditMode.design
                    pageIndex = 1
                } label: {
                    Image(systemName: "paintpalette")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(pageIndex == 1 ? .red : .blue)
                }
                Spacer()
                Button{
                    editMode = SpecialDayEditMode.color
                    pageIndex = 2
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(pageIndex == 2 ? .red : .blue)
                }
                Spacer()
                Button{
                    editMode = SpecialDayEditMode.font
                    pageIndex = 3
                } label: {
                    Image(systemName: "character.textbox")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(pageIndex == 3 ? .red : .blue)
                }
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            
            
            TabView(selection: $pageIndex){
                
                
                
                SpecialDayNameView(name: $name, date: $selectedDate, toggleDate: $toggleDate)
                    .tag(0)
                
                SpecialDayDesignView()
                    .tag(1)
                
                
                SpecialDayColorView(
                    selectedColor: $selectedColor,
                    selectedImageData: $selectedImageData,
                    image: $bgImage
                )
                    .tag(2)
                
                SpecialDayFontView(selectedFont: $selectedFont)
                    .tag(3)
                
            }
            .animation(.easeInOut, value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            
            
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    
                    
                    // NOTE: Handles both existing and new Habits
                   // TODO: add propper validation
                   let trim =  name.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if trim.count == 0 {
                        return
                    }
                    
                    
                    if specialDay == nil {
                        // Make new speical day
//                        if selectedImageData == nil {return}

                        let _ = StorageProvider.shared.saveSpecialDay(
                            name: name,
                            date: selectedDate,
                            color: selectedColor,
                            repeatNextYear: repeatNextYear,
                            dateToggle: toggleDate,
                            font: selectedFont,
                            image: selectedImageData,
                            widgetSize: widgetSize.rawValue
                        )
                        
                    } else {
                        // TODO: Change enxiting habit
                    }
                    
                    
                    dismiss()
                    
                }label: {
                    Text("Save")
                }
            }
        }
        .onAppear{
            isAnimating.toggle()
            // dotAppearance.currentPageIndicatorTintColor = .blue
            dotAppearance.isHidden = true
            
            
            // TODO: Add the getters and setters for SpecialDay class
            if specialDay != nil {
                name = specialDay!.name!
                selectedDate = specialDay!.date!
                toggleDate = specialDay!.dateToggle
                selectedColor = specialDay!.color!
                selectedImageData = specialDay!.image
                repeatNextYear = specialDay!.repeatNextYear
                
                if specialDay!.image != nil {
                    let uiImage = UIImage(data: specialDay!.image!)
                    bgImage = Image(uiImage: uiImage!)
                }
                selectedFont =  specialDay!.font!
                widgetSize = WidgetSize(rawValue: specialDay!.widgetSize!)!
                
                
                
            }
            
            interval = Date() - selectedDate
            
        }
        .onChange(of: selectedDate){ newDate in
            interval = newDate - Date()
        }
    }
    
    
    func formatDate(date: Date)-> String {
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = Locale.autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
    
    
    
}


#Preview {
    SpecialDayAddView(specialDay: nil)
}
