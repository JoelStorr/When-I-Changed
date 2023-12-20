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
    
    @State var editMode: SpecialDayEditMode = SpecialDayEditMode.name
    @State var pageIndex = 0
    @State var isAnimating: Bool = false
    var viewWidth = UIScreen.main.bounds.width
    private let dotAppearance = UIPageControl.appearance()
    
    
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
            
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.orange)
                .frame(width: 120, height: 120)
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
                        .frame(width: 35, height: 35)
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
                        .frame(width: 35, height: 35)
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
                        .frame(width: 35, height: 35)
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
                        .frame(width: 35, height: 35)
                        .foregroundStyle(pageIndex == 3 ? .red : .blue)
                }
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            
            
            TabView(selection: $pageIndex){
                ForEach(0..<pageArray.count, id: \.self) { (index) in
                    
                    Text(pageArray[index])
                        .tag(index)
                    
                }
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
}

#Preview {
    SpecialDayAddView()
}
