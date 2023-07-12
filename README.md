# Package-by-layer Architecture

![diagram](https://github.com/mohammadt-deriv/architecture_proposal/assets/75987594/d8f84d86-13e5-466b-93d5-48b86e943129)


## What is it
This is not a new architecture, its just a custom version of layered architecture for flutter apps, which highly aims for `testability` and `simplicity`.

## Overview
This architecture consist of 4 main layers, where each layer reside in its own package:
### 1. Domain
>**Responsible for defining app language**

In short, any class or interface that both UI and Data layer should be aware of, in order to comunicate with each other.
examples are Models/Entities, base classes, repository interfaces.
#### Rules
- Do not depends on any layer.
- No UI code allowed in this layer.
- No data code allowed in this layer.
- No dependecy to `Flutter`.
- No implementation of its own iterfaces.

##
### 2. UI
>**Responsible for showing app data**

This layer is responsible for defining all widgets that is visiable to user. from template to small ones.
It also can use state managment tools for managing state of a `UI` unit. Its important to note that here we should not define state managers that are general purpose, like AuthCubit. because this way we're crossing layer responsibility.
#### Rules
- Only depends on domain layer
- No Data code allowed in this layer.
- No domain code allowed in this layer.
- No navigation code allowed

##
### 3. Data
>**Responsible for Providing app data**

Defines any class that is envolved in process of fetching raw data till translating it to domain language.
So it may contain datasources, repositories and any other class that helps to produce domain language.
For example `AuthCubit` will live in this layer, because its an implementation of `AuthIO` in domain. it helps providing something that translate data to domain requierments.

#### Rules
- Only depends on domain layer
- No UI code allowed in this layer.
- No domain code allowed in this layer.

##
### 4. App
>**Responsible for connecting layers**

Data and UI layers are nothing useful by themselves, so another layer step in to connect them together.
App layer is our final package where we instantiate both ui and data classes, and pass instances to eachother as their constrcutor requierment. This package will define routes and pages of the client app, so he is the only one aware of navigation system.
It can also define app themes, env variables, flavers, and anything related to app in general.
#### Rules
- Depends on ui and data layer.
- No dependecy to domain.
- No UI code allowed in this layer.
- No domain code allowed in this layer.
- No Data code allowed in this layer.


## Why package-by-leyer?
While it may seem unpopular choice among microservice folks, this is a huge step into separating concerns and prevent spaghetti code in big projects. tight-coupling is the hardest evil among our codebases in deriv mobile apps, and it leads to hard testability, hard maintainability and hard times when adding/removing features.
In this architectur, if you ever try to fetch data directly from api in a cubit or in a widget, you fail because you don't have access to any data layer classes in your widgets, because they are in data package and you ui package is not depending on it in pubspec. all you have 
, is some domain intefaces that you can depend on. this will ensures high testability for your ui code.
Also keep in mind that in each package, we don't blindly throw classes in a single folder. we still foldering them by meaningfull topics, so it won't be confusing or hard to find what you are looking for.
Meanwhile, you can still extract huge features(like trade and auth) in separate packages. in fact, you SHOULD.




