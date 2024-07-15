//
//  ArrivedBackView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 14/06/23.
//

import SwiftUI
import SunKit

struct ArrivedBackView: View {
    
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    var ns: Namespace.ID
    var day: DayPhase
    
    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                Color(day.getClosestPhase(currentTime: Date()).color.backgroundColor).ignoresSafeArea()
                VStack{
                    Image(systemName: "flag.checkered.2.crossed")
                        .resizable()
                        .frame(width: geo.size.width * 0.23, height: geo.size.width * 0.15)
                        .foregroundColor(Color("white"))
                    
                    Text(LocalizedStringKey(".Congratulation"))
                        .bold()
                        .foregroundColor(Color("white"))
                        .font(.system(size: 40))
                    Text(LocalizedStringKey(".YouArrived"))
                        .foregroundColor(Color("white"))
                        .font(.system(size: 25))
                        .frame(maxWidth: geo.size.width * 0.7)
                        .multilineTextAlignment(.center)
                }.position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
                VStack{
                    Button {
                        defaults.set(false, forKey: "IS_STARTED")
                        withAnimation {
                            screen = .startView
                            mapScreen = .mapView
                            activity = .map
                        }
                    } label: {
                        VStack{
                            Text(LocalizedStringKey(".Okay"))
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundColor(Color(day.getClosestPhase(currentTime: .now).color.backgroundColor))
                        }
                        .frame(minWidth: geo.size.width * 0.4 ,minHeight: geo.size.width * 0.11)
                        .background(){
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: geo.size.width * 0.11)
                                .foregroundColor(Color("white"))
                        }
                    }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
               
            }
        }
       
    }
}
//
//struct ArrivedBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArrivedBackView(screen: .constant(.activity), activity: .constant(.map), mapScreen: .constant(.mapView), ns: Namespace.init().wrappedValue, day: dayFase(sunrise: 06, sunset: 19))
//    }
//}
