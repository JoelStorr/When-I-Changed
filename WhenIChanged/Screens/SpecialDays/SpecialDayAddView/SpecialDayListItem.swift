//
//  SpecialDayListItem.swift
//  WhenIChanged
//
//  Created by Joel Storr on 23.12.23.
//

import SwiftUI

struct SpecialDayListItem: View {
    
    
    @Binding var specialDay: SpecialDay
    
    @State var interval = Date() - Date()
    
    let dateFormatter = DateFormatter()
    
    @State var image: UIImage = UIImage()
    
    var body: some View {
        ZStack{
            
            if specialDay.image == nil {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(
                        specialDay.image != nil ?  Color.black.opacity(0) : cardColorConverter(color: specialDay.color ?? "green"))
                    
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
                    .font(.custom(specialDay.font!, size: 80))
                    .foregroundStyle(specialDay.image == nil ? Color.white : cardColorConverter(color: specialDay.color!))
                Spacer()
                Text(specialDay.name!)
                    .font(.custom(specialDay.font!, size: 30))
                    .fontWeight(.black)
                    .foregroundStyle(specialDay.image == nil ? Color.white : cardColorConverter(color: specialDay.color!))
                if !specialDay.dateToggle {
                    Text(formatDate(date: specialDay.date!))
                        .font(.custom(specialDay.font!, size: 15))
                        .foregroundStyle(specialDay.image == nil ? Color.white : cardColorConverter(color: specialDay.color!))
                }
            }
        }
        .frame(width: 200, height: 200)
        .onAppear{
            
            if specialDay.image != nil {
                image = UIImage(data: specialDay.image!)!
            }
            
            interval = specialDay.date! - Date()
            
        }
    }
    
    
    func formatDate(date: Date)-> String {
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = Locale.autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
}


