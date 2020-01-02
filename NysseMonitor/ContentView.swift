//
//  ContentView.swift
//  NysseMonitor
//
//  Created by tuomas.granlund on 2.1.2020.
//  Copyright © 2020 tuomas.granlund. All rights reserved.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var stopPoints = [String]()

    var body: some View {
        NavigationView {
            MasterView(stopPoints: $stopPoints)
                .navigationBarTitle(Text("Pysäkit"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            //withAnimation { self.stopPoints.insert(Date(), at: 0) }
                            AF.request("http://data.itsfactory.fi/journeys/api/1/stop-points/2524").responseString {
                                response in self.stopPoints.insert(response.value ?? "response nil", at: 0)
                            }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
            DetailView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var stopPoints: [String]

    var body: some View {
        List {
            ForEach(stopPoints, id: \.self) { stopPoint in
                NavigationLink(
                    destination: DetailView(selectedStopPoint: stopPoint)
                ) {
                    Text(stopPoint)
                }
            }.onDelete { indices in
                indices.forEach { self.stopPoints.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedStopPoint: String?

    var body: some View {
        Group {
            if selectedStopPoint != nil {
                Text(selectedStopPoint!)
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
