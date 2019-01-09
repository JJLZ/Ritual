//
//  TrackingManager.swift
//  Ritual
//
//  Created by Jose Lopez on 1/9/19.
//  Copyright © 2019 Namrata Bandekar. All rights reserved.
//

import Mixpanel

class TrackingManager {
    
    static func initializeMixpanel() {
        #if DEBUG
        Mixpanel.initialize(token: "06cca023bc562060ae0c55e6b9a07bfd")
        #else
        Mixpanel.initialize(token: "6864219ef5371e96d264549dbf8b66e5")
        #endif
        Mixpanel.mainInstance().loggingEnabled = true
    }
    
    static func trackEvent(name: String, eventProperties: [String: MixpanelType]? = nil) {
        
        Mixpanel.mainInstance().track(event: name, properties: eventProperties)
    }
    
    static func startTrackingTimedEvent(name: String) {
        Mixpanel.mainInstance().time(event: name)
    }
}
