//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/01/2025.
//

import Foundation
import Parsing
import URLRouting

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe) public static let v1 = Path {
        "v1"
    }

    nonisolated(unsafe) public static let v2 = Path {
        "v2"
    }

    nonisolated(unsafe) public static let v3 = Path {
        "v3"
    }

    nonisolated(unsafe) public static let v4 = Path {
        "v4"
    }

    nonisolated(unsafe) public static let v5 = Path {
        "v5"
    }
}
