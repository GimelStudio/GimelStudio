# Data Binding

[Data Binding](https://en.wikipedia.org/wiki/Data_binding), or [Property Binding](https://doc.qt.io/qt-5/qtqml-syntax-propertybinding.html) in Qt terminology, is a programming paradigm that allows binding of data sources to their respective consumers.
That means that if a value depends on another, it will automatically be updated whenever the input value changes.

## Basic Data Binding in KDBindings
The basis for Data Binding in KDBindings is formed by [Properties](properties.md).

They can be combined using arithmetic operators or just plain functions, to create new properties that are bound to the input properties.
This means the result of the calculation will be updated automatically every time the input of the calculation changes.

To create a binding, use the free [makeBoundProperty](../namespaceKDBindings.md#function-makeboundproperty) function in the KDBindings namespace.

### Example
``` cpp
#include <kdbindings/binding.h>

using namespace KDBindings;

Property<int> width(2);
Property<int> height(3);
Property<int> area = makeBoundProperty(width * height);

std::cout << area << std::endl; // will print 6
width = 5;
std::cout << area << std::endl; // will print 15
```

Pretty much all arithmetic operators are supported, as well as combinations of Properties with constant values.

## Declaring functions for use in data binding
KDBindings also allows you to declare arbitrary functions as usable in the context of data binding.
See the [`node_functions.h`](../node__functions_8h.md) file for documentation on the associated macros.

This is already done for some of the `std` arithmetic functions, like abs and floor.
You can use the KDBINDINGS_DECLARE_STD_FUNCTION macro to declare more of these when necessary.

### Example
``` cpp
#include <kdbindings/binding.h>

using namespace KDBindings;

Property<int> value(-1);
Property<int> positiveValue = makeBoundProperty(abs(value));
// positiveValue is 1
```


## Binding arbitrary functions
[makeBoundProperty](../namespaceKDBindings.md#function-makeboundproperty) also accepts functions as binding, so arbitrary code can be executed to produce the new property value.

### Example
``` cpp
#include <kdbindings/binding.h>

using namespace KDBindings;

Property<std::string> text;
Property<std::string> lowerCase = makeBoundProperty(
  [](std::string value) {
    std::transform(value.begin(), value.end(), value.begin(),
      [](unsigned char c) { return std::tolower(c); });
      return value;
  },
  text /*don't forget to pass in the source property*/);

text = "Hello World!";
std::cout << lowerCase.get() << std::endl;
```
Expected output:
```
hello world!
```

## No more broken bindings
A common mistake in data binding is accidentally breaking a binding by assigning a value to it.

With KDBindings this is no longer possible.
Assigning a value to a property that is the result of a data binding will result in an error!

### Example
``` cpp
#include <kdbindings/binding.h>

using namespace KDBindings;

Property<int> value = 2;
Property<int> result = makeBoundProperty(2 * value);
// result is now 4

result = 5; // this will throw a KDBindings::ReadOnlyProperty error!
```

To intentionally remove a binding from a property, use its [`reset`](../../classKDBindings_1_1Property/#function-reset) function.

### Reassigning a Binding
Even though KDBindings prevents you from accidentally overriding a binding with a concrete value, assigning a
new binding to a Property with an existing binding is possible.

For this, use the [makeBinding](../namespaceKDBindings.md#function-makebinding) function instead of [makeBoundProperty](../namespaceKDBindings.md#function-makeboundproperty) to create the binding.

It is also possible to use makeBoundProperty, which will move-assign a new Property into the existing one, therefore completely replacing the existing Property with a new one.
This means that all signals of the old property will be disconnected (see [signals & slots](signals-slots.md)) and any existing data bindings that depended on the property will be removed, which might not be what you want!

Rule of thumb: If you want to create a new property, use makeBoundProperty, if you want to add a new binding to an
existing Property, use makeBinding.

#### Example
``` cpp
#include <kdbindings/binding.h>

using namespace KDBindings;

Property<int> value = 2;
auto result = makeBoundProperty(2 * value);
// result is 4

result = makeBinding(3 * value); // This does not throw any exceptions.
// result is now 6
result = makeBoundProperty(4 * value); // This works too, but will override all existing connections to result.
// result is now 8
```


## Deferred evaluation
KDBindings optionally offers data bindings with controlled, deferred evaluation.

This feature is enabled by passing a [KDBindings::BindingEvaluator](../classKDBindings_1_1BindingEvaluator.md) to makeBoundProperty.
The binding will then only be evaluated when [`evaluateAll()`](../classKDBindings_1_1BindingEvaluator.md#function-evaluateall) is called on the evaluator instance.

Deferred evaluation is useful to avoid unnecessary reevaluation of a binding, as well as controlling the frequency of binding evaluation.
Especially in UI applications, only updating the displayed values once per second can help in making them readable, compared to a bunch of values updating at 60Hz.

See the [06-lazy-property-bindings](../06-lazy-property-bindings_2main_8cpp-example.md) example for more details on how to use deferred evaluation.


## Further reading
Classes involved in data binding are [KDBindings::Property](../classKDBindings_1_1Property.md), [KDBindings::Binding](../classKDBindings_1_1Binding.md), and [KDBindings::BindingEvaluator](../classKDBindings_1_1BindingEvaluator.md).

See [KDBindings::makeBoundProperty](../namespaceKDBindings.md#function-makeboundproperty) for the different ways to create a binding.

We also recommend you take a look at our [examples](../examples.md).
