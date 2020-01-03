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
    @State private var stopPoints = DomainModel().stopPoints

    var body: some View {
        NavigationView {
            MasterView(stopPoints: $stopPoints)
                .navigationBarTitle(Text("Pysäkit"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            
                            self.stopPoints.forEach { stopPoint in
                                AF.request(stopPoint.getMonitoringUrl).responseString {
                                    response in stopPoint.setJson(json: response.value ?? "EMPTY")
                                }
                            }
                        }
                    ) {
                        Image(systemName: "arrow.clockwise")
                    }
                )
            DetailView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var stopPoints: [StopPoint]

    var body: some View {
        List {
            ForEach(stopPoints, id: \.self) { stopPoint in
                NavigationLink(
                    destination: DetailView(selectedStopPoint: stopPoint)
                ) {
                    Text(stopPoint.getName)
                }
            }.onDelete { indices in
                indices.forEach { self.stopPoints.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedStopPoint: StopPoint?

    var body: some View {
        Group {
            if selectedStopPoint != nil {
                Text(selectedStopPoint!.getDepartures!.body!.lines![0].getInfo)
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text(selectedStopPoint?.getName ?? "Tuntematon pysäkki"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
