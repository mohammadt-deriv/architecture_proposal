# Package-by-Layer Architecture


<img width="1497" alt="Screenshot 2023-08-23 at 12 02 19 PM" src="https://github.com/mohammadt-deriv/architecture_proposal/assets/75987594/a48a5786-f8c2-4bd2-97ec-1511c1a4180e">

[Full diagram Link](https://excalidraw.com/#json=scYH0c-Eq1jmE-Y_rAcUh,S-34y1qVKRI4uCiJm5rBvQ)

## What is it
Its just a custom version of layered architecture, fine-tuned for flutter apps, aming for high `testability` and `simplicity`.

## Overview
This architecture consists of 4 main layers, where each layer reside in its own package:
### 1. Domain
>**Responsible for defining app language**

In short, any class or interface that both UI and Data layer should be aware of, in order to communicate with each other.
Examples are Models/Entities, base classes, repository interfaces.
#### Rules
- Do not depend on any layer.
- No UI code allowed in this layer.
- No data code allowed in this layer.
- No dependency to `Flutter`.
- No implementation of its own interfaces.

##
### 2. UI
>**Responsible for showing app data**

This layer is responsible for defining all widgets that is visible to user. From template to small ones.
It also can use state management tools for managing state of a `UI` unit. It's important to note that here we should not define state managers that are general purpose, like AuthCubit. because this way we're crossing layer responsibility.
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
For example `AuthCubit` will live in this layer, because its an implementation of `AuthIO` in domain. It helps to provide something that translate data to domain requirements.

#### Rules
- Only depends on domain layer
- No UI code allowed in this layer.
- No domain code allowed in this layer.

##
### 4. App
>**Responsible for connecting layers**

Data and UI layers are nothing useful by themselves, so another layer step in to connect them together.
App layer is our final package where we instantiate both UI and data classes, and pass instances to eachother as their constructor requirement. This package will define routes and pages of the client app, so it is the only one aware of navigation system.
It can also define app themes, env variables, flavors, feature flags and anything related to app in general.
#### Rules
- Depends on all UI and data and domain layer.
- No UI code allowed in this layer.
- No domain code allowed in this layer.
- No Data code allowed in this layer.


## Why package-by-leyer?
While it may seem unpopular choice among micro service folks, this is a huge step into separating concerns and prevent spaghetti code in big projects.
Here we are not suggesting having `all` of our codebase separated by layer-first approach. Because we are assuming that we already extracted any feature that could be extracted and be reused in other apps, like trade and auth, into separate package, and we are only architecting whatever is remained.
Cause if you think about it, there are lot of things in any app that is not reusable for other apps. Examples are home and profile.
If you separate you app into layers first, developers can easily understand your whole app architecture in a glance, without trying to open each feature folder to make sure they are following exact same layers. also, you are promoting TDD principles with this layering, as you have strict line between your UI and data code. Usually in TDD, you write your UI without worrying about whom provide you data and how. with this separation by package, there is `zero` chance for any developer to violate this rule, because if you ever for example try to fetch data directly in UI code, you will get `compile time` error, thanks to dart dependency management which tells there's is no dependency between UI package and data package.
Also keep in mind that in each package, we don't blindly throw classes in a single folder. We still foldering them by meaningful topics, so it won't be confusing or hard to find what you are looking for.

## Problems that this architecture solves
in a survey from deriv mobile developers, we asked them to list problems in the codebase they work on daily. Here are top 3:
- Hard Debugging
 - Due to tight coupling
- Hard Testing
 - Due to bad/no dependency injection
- Hard Modifying
 - Due to tight coupling.

Tight coupling is result of mixing UI and data code, which in this architecture we tried to define clear constraints for violating it, by having separate package for each layer.
Also missing domain layer is the real cause of having bad dependency injection and low testability.

## Problems that this architecture introduces
- You high level widgets, like templates and layouts, will probably have long list of dependencies in their constructor, as they need to also provide dependency for their children. We can fix that by passing them `.of(context)` way but personally i prefer get compile error when i miss passing a dependency, not runtime one.
- You need to go through 1-2 more folder to add/remove a features compared to feature-first architects.
- You might not be familiar with TDD and fail to define proper interfaces for your UI.(happens for me)

## Folders Structure
First we create the main `app` package. then we create a folder called `packages` and put other 3 package in there(`UI`, `data`, `domain`).
You can find a sample of this structure in `example` folder of this repo.


    app-package
    │
    ├── packages
    │   ├── data-package   
    │   ├── ui-package
    │   └── domain-package

## Testing
Testing with this architecture is pretty straightforward, specially the UI part, since you can even test complex `pages` functionalities by passing all dependecies of that page through constrcutor. You also don't need to be worry about navigation in your testing, since you're sure all navigation logic is in app package, not UI.
You can see example of testing a page in this file: 
[HomePage Test](https://github.com/mohammadt-deriv/architecture_proposal/blob/master/example/packages/architecture_proposal_ui/test/home/home_layout_test.dart)

## Migration plan
For migrating an existing project to this architecture, you have to follow these steps:
1. **Init new strcuture**: Create `packages` folder and init all `data`, `UI`, `domain` packages in that folder.
2. **Extract a feature UI**: Move `one` of feature's pages + its widgets and cubits to `UI` package. We will fix errors in next step. don't forget to create a folder with feature's name and put files in there.
3. **Refactor extracted UI**: Remove all dependecies to data classes, navigation and non-ui codes(just move them to a temp place as we need them in next steps). now depend on correct interfaces and entities for your widgets and cubits. Also add these intefaces and entities to your `domain`package. This step might be the most challenging step but once you do it right, rest is much easier.
4. **Define data classes**: This step might be differernt for each case, but usually you have to create a repository class which implements defined interfaces, and accepts a data source as dependecy. you need to make sure all the removed logics in previous step is now covered in your new data classess.
5. **Replace with extracted page**: Now in your lagacy project, replace old widgets refrences with your new refactored widgets.
6. **Test app functionality**: Test if app works as before. chances are `high` that you've broke something, but don't panic and track the issue patiently. Rememeber first steps are always harder. the more page you extract, the easier proccess gets.
7. **Repeat proccess with next Page/Feature**: After app gets back to normal state, it means a success migration for one feature. continue with next feature.

## Localization
Localization should be done in `UI package`, since only widgets in UI package need localization.
We can do it by passing generated localization delegates from `UI package` to `app package` in `MaterialApp`, and thats no issue because our app package already knows about UI package.


