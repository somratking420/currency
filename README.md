# Currency for iOS

![View of the Currency app for iOS running on an iPhone](http://f.cl.ly/items/1V1t3V1T140z2N0M1415/currency.jpg)

This project is a fun currency converter app, built by a designer learning iOS development in Swift, hitting the App Store as soon as possible. Free to download, open to contributions.

## Swift

This project is written in the Apple Swift version 2.1.1

## Motivation

This project is a learning exercise in Swift programming. With the open sourcing the code base I seek primarily to get feedback and critique on my code base but also to allow others to contribute to the project.

## Installation

This project uses [CocoaPods](https://cocoapods.org). Below is the setup to configure Cocoa Pods in your machine.

To install Cocoa Pods, run:
```$ sudo gem install cocoapods```

To install the required pods for this project, change to the project directory and run:
```$ pod install```

## API Reference

This project makes use of the [Yahoo Query Language (YQL) API](https://developer.yahoo.com/yql/) to get currency exchange rates. You can test query statements on the [YQL Console](https://developer.yahoo.com/yql/console/).

An example YQL statement to fetch the USD to JPY exchange rate looks like:
```select * from yahoo.finance.xchange where pair in ("USDJPY")```

And the resulting XML REST query looks like:
```https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDJPY%22)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys```

## Tests

There are no tests written for this application so far.

## Tasks

There is a plain text file included in the repository with the current list of tasks to do. This is temporary.

## Contributors

The best contribution to this project right now is in the form of feedback. Either comment the code base, on the commits, or open issues. I will reply to all feedback as quickly as possible. If you are interested in contributing directly to the code base, please open a pull request and explain the changes. If you have more questions please contact me on Twitter at [@nunosans](http://twitter.com/nunosans).
