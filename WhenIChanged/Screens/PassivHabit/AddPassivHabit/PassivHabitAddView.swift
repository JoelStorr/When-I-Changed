//
//  PassivHabitAddView.swift
//  WhenIChanged
//
//  Created by Joel Storr on 08.11.23.
//

import SwiftUI

struct PassivHabitAddView: View {

    @Environment(\.dismiss) var dismiss

    @State var nameField: String = ""
    @State var startDate: Date = .now
    @State var showColorSheet = false
    @State var selectedColor: String = CardColor.green.rawValue

    var body: some View {
            Form {
                TextField("New Habit name", text: $nameField)
                DatePicker("When did you start", selection: $startDate, displayedComponents: [.date])
                HStack {
                    Button("Select Color") {
                        showColorSheet.toggle()
                    }
                    Spacer()
                        .frame(minWidth: 20)
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(cardColorConverter(color: selectedColor))
                }
                Button("Save") {
                    StorageProvider.shared.savePassiveHabit(name: nameField, startDate: startDate, cardColor: selectedColor)
                   dismiss()
                }
            }
            .navigationTitle("Edit")
            .sheet(isPresented: $showColorSheet) {
                VStack {
                    HStack {
                        Spacer()
                        Button("Cancle") {
                            showColorSheet.toggle()
                        }.padding()
                    }
                    List {
                        ForEach(CardColor.allCases, id: \.rawValue) {color in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(cardColorConverter(color: color.rawValue))
                                .onTapGesture {
                                    showColorSheet.toggle()
                                    selectedColor = color.rawValue
                                }
                        }
                    }
                }
            }
    }
}
