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


struct SpecialDayAddView: View {
    
    let pageArray = ["Name", "Design", "Color", "Font"]
    private let iconSize: CGFloat = 30.0
    
    
    
    @State var editMode: SpecialDayEditMode = SpecialDayEditMode.name
    @State var pageIndex = 0
    @State var isAnimating: Bool = false
    var viewWidth = UIScreen.main.bounds.width
    private let dotAppearance = UIPageControl.appearance()
    
    
    // NOTE: Form Varaibles
    @State var name: String = ""
    @State var date: Date = .now
    
    @State var selectedColor: String = CardColor.orange.rawValue
    
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
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(cardColorConverter(color: selectedColor))
                    .frame(width: 200, height: 200)
                
                VStack{
                    Spacer()
                    Text(name)
                    Text(formatDate(date:date))
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
                
                
                
                SpecialDayNameView(name: $name, date: $date)
                    .tag(0)
                
                SpecialDayDesignView()
                    .tag(1)
                
                
                SpecialDayColorView(selectedColor: $selectedColor)
                    .tag(2)
                
                SpecialDayFontView()
                    .tag(3)
                
            }
            .animation(.easeInOut, value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            
            
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{}label: {
                    Text("Save")
                }
            }
        }
        .onAppear{
            isAnimating.toggle()
            //            dotAppearance.currentPageIndicatorTintColor = .blue
            dotAppearance.isHidden = true
        }
    }
    
    
    func formatDate(date: Date)-> String {
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = Locale.autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
    
    
    
}

#Preview {
    SpecialDayAddView()
}
