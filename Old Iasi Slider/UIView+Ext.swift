//
//  UIView+Ext.swift
//  Old Iasi Slider
//
//  Created by Andrei Ionescu on 27.03.2025.
//

import SwiftUI

extension View {
    func resizableMatchWrapper() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
    }
}
