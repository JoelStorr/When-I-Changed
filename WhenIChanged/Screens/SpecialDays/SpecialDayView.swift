//
//  SpecialDayView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 17.12.23.
//

import SwiftUI

struct SpecialDayView: View {
    
    @State var allSpecialDay: [SpecialDay] = []
    @State var path: [SpecialDay] = []
    @State var goToChangeOder: Bool = false
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                
                // TODO: Handle list propperly
                ForEach(allSpecialDay) {item in
                    SpecialDayListItem(specialDay: item)
                        .onTapGesture {
                            path.append(item)
                        }
                        .onLongPressGesture{
                            goToChangeOder = true
                        }
                        
                }
                
                
            }
            .listSectionSeparator(.hidden)
            .navigationDestination(for: SpecialDay.self){ value in
                    
                    
                if goToChangeOder {
                    
//                    ActiveHabitOrderView(habitArray: $viewModel.activeHabits)
                } else {
                    SpecialDayAddView(specialDay: value ) // TODO: Feed habit back in
                }
                
            }
            .navigationTitle("Special Day")
        .listStyle(DefaultListStyle())
        .toolbar {
            ToolbarAddHabitButton()
        }
        .onAppear {
            allSpecialDay = StorageProvider.shared.loadAllSpecialDays()
            goToChangeOder = false
        }
        }
    }
}

#Preview {
    SpecialDayView()
}
