APIParseError
============

Server error parsing class. Standart from 06.03.2017 

## Instruction

Copy [AppDelegate+Firebase.swift](https://github.com/steelkiwi/ErrorParse-ios/blob/master/ErrorParse/APIErrorParser.swift) file to your project

Now you can pass your data from response in class:
```swift
APIErrorParser.parse(errorData)
```

Result:
- field: String? - error parameter. Nil in case, when error parsing occurs
- error: Error - error object with .localizedDescription property
