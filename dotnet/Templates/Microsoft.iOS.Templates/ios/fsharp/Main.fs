﻿namespace iOSApp1

open UIKit

module Main =
    [<EntryPoint>]
    let main args =
        // This is the main entry point of the application.
        // If you want to use a different Application Delegate class from "AppDelegate"
        // you can specify it here.
        UIApplication.Main(args, null, typeof<AppDelegate>)
        0