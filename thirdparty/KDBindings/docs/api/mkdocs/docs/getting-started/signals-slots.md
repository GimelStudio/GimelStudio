# Signals and Slots

Signals and Slots are the basis on which [Properties](properties.md) and [Data binding](data-binding.md) are built.

The concept is a central feature of the Qt framework.
It allows objects to declare events they may encounter as "Signals".
The object can then "emit" the Signal at any time.
Signals can be connected to functions of another object, referred to as "Slots".

Signals & Slots therefore provide an easy way to implement the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern).
This is especially useful for UI libraries that need to dynamically react to events and observe values.

For an explanation of the original Signals & Slots in Qt, follow [this link](https://doc.qt.io/qt-5/signalsandslots.html).

KDBindings introduces its own Signals that can be used without the need for Qts Meta Object Compiler.
They also don't need to be attached to any specific object.

## KDBindings Signals
A Signal in KDBindings is just an object that can be freely used anywhere in your code.
They are templated over the types of values they emit, which may be of any type.

Slots can be connected to such a Signal by simply calling `connect(...)` on the Signal object.
To emit the Signal, call `emit(...)` and pass the arguments the Signal emits.

### Minimal example
``` cpp
#include <kdbindings/signal.h>

using namespace KDBindings;
Signal<const std::string&> mySignal;

mySignal.connect([](const std::string& value){
  std::cout << value << std::endl;
});

mySignal.emit("Hello World!");
```
Expected output:
```
Hello World!
```

For the full class reference, see: [KDBindings::Signal](../classKDBindings_1_1Signal.md).

## KDBindings Slots
In KDBindings, a slot is anything that can be invoked, so any function, lambda or other object that implements the `operator()`.

Generally, the signature of the slot must match the arguments emitted by the Signal.
However, the Signal class provides an overload to the `connect()` function that allows binding some of the slot arguments to default values.
This is especially useful to connect member functions to a Signal by binding a pointer to the object to the first (implicit) argument.

### Minimal example
``` cpp
#include <kdbindings/signal.h>

using namespace KDBindings;

class MyWidget {
  public:
    void onClicked() {
      std::cout << "Hello World!" << std::endl;
    }
};

Signal<> clicked;
MyWidget widget;

clicked.connect(&MyWidget::onClicked, &widget);
clicked.emit();
```
Expected output:
```
Hello World!
```

Note that in KDBindings, the order of arguments is in reverse to the order required by Qt.
KDBindings expects the member function first, and the pointer to the class object second.

See the examples:

- [02-signal-member](../02-signal-member_2main_8cpp-example.md)
- [03-member-arguments](../03-member-arguments_2main_8cpp-example.md)
- [07-advanced connections](../07-advanced-connections_2main_8cpp-example.md)

Also see the [documentation of the connect function](../classKDBindings_1_1Signal.md#function-connect).

## Managing a connection

Calling the connect function of a Signal returns a [KDBindings::ConnectionHandle](../classKDBindings_1_1ConnectionHandle.md).
These objects reference the connection and can be used to disconnect or temporarily block it.

It's important to note that, unlike Qt, KDBindings requires you to manually disconnect a connection when any of the bound arguments are destroyed.
For that purpose it's important to keep the ConnectionHandle around!
You must use it to disconnect the connection, should the object that contains the slot go out of scope!
Otherwise, you will encounter a dangling pointer whenever the Signal is emitted.

For further information, see the [KDBindings::ConnectionHandle](../classKDBindings_1_1ConnectionHandle.md) documentation.

## Some Notes on Mutability and const Best Practices

When Signals are incorporated into another object, mutability of these Signals can become a concern.
By default functions that modify a Signal, like "connect", are not const, as they modify the Signal.

That does mean however that by default just connecting to a Signal means you'll require a non-const reference to the object the
Signal is contained in.
For some applications, this does not make much sense, as the Signal is just meant to notify of a change, and changing the Signal by
connecting to it doesn't really "modify" the enclosing objects.
This is for example the case in the Property class in KDBindings.

For these cases we actually recommend using the C++ "mutable" keyword to allow the use of non-const Signal functions even in const-contexts.
Whilst using mutable is uncommon, in our opinion this is the correct place to use it, as it accurately marks which Signals change the behavior
of the enclosing object by being connected, and which ones don't.
