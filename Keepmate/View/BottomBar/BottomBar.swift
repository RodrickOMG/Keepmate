//
//  BottomBar.swift
//  BottomBar
//
//  Created by Bezhan Odinaev on 7/2/19.
//  Copyright © 2019 Bezhan Odinaev. All rights reserved.
//

import SwiftUI

public struct BottomBar : View {
    @Binding public var selectedIndex: Int
    @State var isSelected = [true, false, false, false]
    
    public let items: [BottomBarItem]
    
    public init(selectedIndex: Binding<Int>, items: [BottomBarItem]) {
        self._selectedIndex = selectedIndex
        self.items = items
    }
    
    func itemView(at index: Int) -> some View {
        Button(action: {
            withAnimation {
                self.selectedIndex = index
                for i in 0...self.isSelected.count-1 {
                    if(i != index) {
                        self.isSelected[i] = false
                    } else {
                        self.isSelected[i] = true
                    }
                }
            }
        }) {
            BottomBarItemView(isSelected: $isSelected[index], item: items[index])
        }
    }
    
    public var body: some View {
        HStack(alignment: .bottom) {
            ForEach(0..<items.count) { index in
                self.itemView(at: index)
                if index != self.items.count-1 {
                    Spacer()
                }
            }
        }
        .padding()
        .animation(.default)
    }
}

#if DEBUG
struct BottomBar_Previews : PreviewProvider {
    static var previews: some View {
        BottomBar(selectedIndex: .constant(0), items: [
            BottomBarItem(icon: "house.fill", title: "Home", color: .purple),
            BottomBarItem(icon: "heart", title: "Likes", color: .pink),
            BottomBarItem(icon: "magnifyingglass", title: "Search", color: .orange),
            BottomBarItem(icon: "person.fill", title: "Profile", color: .blue)
        ])
    }
}
#endif
