# Package-by-Layer Architecture

![diagram](https://github.com/mohammadt-deriv/architecture_proposal/assets/75987594/946f57f3-01d1-4466-9a6e-6026568b7eff)


## What is it
Its just a custom version of layered architecture, fine-tuned for flutter apps, aming for high `testability` and `simplicity`.

## Overview
This architecture consist of 4 main layers, where each layer reside in its own package:
### 1. Domain
>**Responsible for defining app language**

In short, any class or interface that both UI and Data layer should be aware of, in order to communicate with each other.
examples are Models/Entities, base classes, repository interfaces.
#### Rules
- Do not depends on any layer.
- No UI code allowed in this layer.
- No data code allowed in this layer.
- No dependency to `Flutter`.
- No implementation of its own interfaces.

##
### 2. UI
>**Responsible for showing app data**

This layer is responsible for defining all widgets that is visible to user. from template to small ones.
It also can use state management tools for managing state of a `UI` unit. Its important to note that here we should not define state managers that are general purpose, like AuthCubit. because this way we're crossing layer responsibility.
#### Rules
- Only depends on domain layer
- No Data code allowed in this layer.
- No domain code allowed in this layer.
- No navigation code allowed

##
### 3. Data
>**Responsible for Providing app data**

Defines any class that is evolved in process of fetching raw data till translating it to domain language.
So it may contain data sources, repositories and any other class that helps to produce domain language.
For example `AuthCubit` will live in this layer, because its an implementation of `AuthIO` in domain. it helps providing something that translate data to domain requirements.

#### Rules
- Only depends on domain layer
- No UI code allowed in this layer.
- No domain code allowed in this layer.

##
### 4. App
>**Responsible for connecting layers**

Data and UI layers are nothing useful by themselves, so another layer step in to connect them together.
App layer is our final package where we instantiate both ui and data classes, and pass instances to eachother as their constructor requirement. This package will define routes and pages of the client app, so it is the only one aware of navigation system.
It can also define app themes, env variables, flavors, feature flags and anything related to app in general.
#### Rules
- Depends all ui and data and domain layer.
- No UI code allowed in this layer.
- No domain code allowed in this layer.
- No Data code allowed in this layer.


## Why package-by-leyer?
While it may seem unpopular choice among microservice folks, this is a huge step into separating concerns and prevent spaghetti code in big projects. tight-coupling is the hardest evil among our codebase in deriv mobile apps, and it leads to hard testability, hard maintainability and hard times when adding/removing features.
In this architecture, if you ever try to fetch data directly from api in a cubit or in a widget, you fail because you don't have access to any data layer classes in your widgets, because they are in data package and you ui package is not depending on it in pubspec. all you have 
, is some domain interfaces that you can depend on. this will ensures high testability for your ui code.
Also keep in mind that in each package, we don't blindly throw classes in a single folder. we still foldering them by meaningful topics, so it won't be confusing or hard to find what you are looking for.
Meanwhile, you can still extract huge features(like trade and auth) in separate packages. in fact, you SHOULD.


## Problems that this architecture solves
in a survey from deriv mobile developers, we asked them to list problems in the codebase they work on daily. here are top 3:
- Hard Debugging
  - Due to tight coupling
- Hard Testing
  - Due to bad/no dependency injection
- Hard Modifying
  - Due to tight coupling

Tight coupling is result of mixing ui and data code, which in this architecture we tried to define clear constraints for violating it, by having separate package for each layer.
Also missing domain layer is the real cause of having bad dependency injection and low testability.
Other advantages:
- Least boilerplate code
- Low learning curve due to minimum layers

## Problems that this architecture introduce
- You high level widgets, like templates and layouts, will probably have long list of dependencies in their constructor, as they need to also provide dependency for their children. we can fix that by passing them `.of(context)` way but personally i prefer get compile error when i miss passing a dependency, not runtime one.
- You need to go through different packages to add/remove a feature code.
- You might not be familiar with TDD and fail to define proper interfaces for your UI.(happens for me)

## Folders Structure
First we create the main `app` package. then we create a folder called `packages` and put other 3 package in there(`ui`,`data`,`domain`).
you can find a sample of this structure in `example` folder of this repo.


    .
    ├── lib
    ├── packages
    │   ├── data-package   
    │   ├── ui-package
    │   └── domain-package
    └── pubspec.yaml

## Example app
This example covers this scenario:
1. User login to app with deriv token or as guest.
2. User selects a symbol/market from a selector and see its live price from deriv api.

### Additional scenarios:
- Feature flags
- Reconnect mechanism for websocket
- Error handling
- Remembers last logged in user on fresh start
- Uses modern navigation package (GoRouter)

### Remaining
- Tests :(
- Localization (still not sure how to do it in this architecture)
