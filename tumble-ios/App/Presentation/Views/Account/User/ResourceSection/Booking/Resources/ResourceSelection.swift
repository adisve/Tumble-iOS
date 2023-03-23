//
//  ResourceSelection.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-03-22.
//

import SwiftUI

struct ResourceSelection: View {
    
    @ObservedObject var parentViewModel: AccountViewModel
    @State private var selectedTimeIndex: Int = 0
    @State private var availabilityValues: [Response.AvailabilityValue] = [Response.AvailabilityValue]()
    
    let resource: Response.KronoxResourceElement
    let selectedPickerDate: Date
    
    var body: some View {
        if let timeslots = resource.timeSlots {
            VStack (alignment: .leading) {
                Text(selectedPickerDate.formatDate())
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.onBackground)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                ResourceTimeDropdownMenu(
                    resource: resource,
                    timeslots: timeslots,
                    selectedIndex: $selectedTimeIndex
                )
                Divider()
                    .foregroundColor(.onBackground)
                ResourceRoomSelection(
                    resourceId: resource.id ?? "",
                    bookResource: bookResource,
                    selectedPickerDate: selectedPickerDate,
                    availabilityValues: $availabilityValues
                )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .background(Color.background)
            .onAppear {
                for timeslot in timeslots {
                    if let timeslotId = timeslot.id,
                       resource.availabilities.timeslotHasAvailable(for: timeslotId) {
                        selectedTimeIndex = timeslotId
                        break
                    }
                }
                availabilityValues = resource.availabilities.getAvailabilityValues(for: selectedTimeIndex)
            }
            .onChange(of: selectedTimeIndex, perform: { _ in
                availabilityValues = resource.availabilities.getAvailabilityValues(for: selectedTimeIndex)
            })
        } else {
            Info(title: "No available timeslots", image: "clock.arrow.circlepath")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
        }
    }

    fileprivate func bookResource(
        resourceId: String,
        date: Date,
        availabilityValue: Response.AvailabilityValue) -> Void {
            parentViewModel.bookResource(
                resourceId: resourceId,
                date: date,
                availabilityValue: availabilityValue
            )
        }
    
}
