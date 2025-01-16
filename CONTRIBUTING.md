# Contributing to Gimel Studio

Thank you for taking the time to contribute. We're excited to have you!

The following is a set of guidelines for contributing to the Gimel Studio repositories, which are hosted in the [Github Organization](https://github.com/GimelStudio) on GitHub. 

These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

Read the following sections in order to know how to ask questions and how to work on something in an orderly manner.

Gimel Studio is an open source project and we love to receive contributions from our community — you! There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting UI translations, bug reports and feature requests or writing code which can be incorporated into Gimel Studio itself.

**Please note that like many open-source projects, we require you to sign a CLA (Contributor License Agreement) when you contribute for the first time.**


#### Table Of Contents

[Asking for help](#asking-for-help)

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
  * [Core Technologies](#core-technologies)
  * [State Management and Architecture](#state-management-and-rchitecture)
  * [Design Decisions](#design-decisions)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Your First Code Contribution](#your-first-code-contribution)

[Styleguides](#styleguides)
[Stacked CLI Commands](#stacked-cli-commands)


## Asking For Help

**Please don't use the issue tracker for general support questions**. Check whether the [Github Discussions](https://github.com/GimelStudio/GimelStudio/discussions) can help with your issue.


## What Should I Know Before I Get Started?

### Core Technologies

Moving forward, **Gimel Studio is written in Dart/Flutter**, so a basic understanding of Dart and/or the Flutter framework is required for most code contributions. 

If you are completely new to Dart and Flutter, you can find an overview of the Dart language [here](https://dart.dev/language) and documentation to get started learning Flutter [here](https://docs.flutter.dev/get-started/learn-flutter).

In the future, we will likely use shaders for on-GPU image-manipulation and C++ for performance critical portions of Gimel Studio, but knowledge of either isn't required to contribute for most issues.

### State Management and Architecture

For **state management** Gimel Studio uses [Stacked](https://stacked.filledstacks.com/docs/getting-started/overview): an MVVM framework for building maintainable applications. Due to the integral role that the Stacked MVVM architecture plays in the Gimel Studio, you should familiarize yourself with the [Stacked documentation](https://stacked.filledstacks.com/docs/getting-started/overview). See below for an overview of the Stacked CLI commands you may use when you contribute code.

### Design Decisions

When we make a significant decision in how we maintain the project and what we can or cannot support, we will often announce it in our [community chat](https://gimelstudio.zulipchat.com). Feel free to ask questions and/or suggest ideas there!


## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Gimel Studio. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

When you are creating a bug report, please include as many details as possible. Fill out the template as the information it asks for helps us resolve issues faster.

#### Before Submitting A Bug Report

Make sure to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). After you've determined  your bug is related to, create an issue in the repository and provide as much helpful information as you can to help us understand the problem.

### Your First Code Contribution

Unsure where to begin contributing to Gimel Studio? You can start by looking through these `good-first-issue` and `help-wanted` issues:

* [Good First issues](https://github.com/GimelStudio/GimelStudio/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) - issues which shouldn't require an in-depth knowledge of the existing code. Some of these can be challenging even though they don't require a lot of code though!
* [Help wanted issues](https://github.com/GimelStudio/GimelStudio/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) - issues which should be a bit more involved.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

If you have any questions about contributing, feel free to ask on the official [community chat](https://gimelstudio.zulipchat.com) or in a Github issue.


## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use sentence case except for referencing a file, method, function, class, etc in the code
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

## Dart Code

Dart code should largely **the [Effective Dart guidlines](https://dart.dev/effective-dart)**, except:

* The line length should be ``120``.

Format your code by running ``dart format . -l 120`` in your terminal.


## Stacked CLI Commands

- Use ``stacked generate`` to re-sync the generated files.

- **Global widget**: Use ``stacked create widget gs_<widget_name>`` to create a new global widget in the ``lib/ui/widgets/common/`` folder. The ``gs_`` prefix is used for global widgets that are common across the application (dropdowns, buttons, etc.).

- **Local widget**: Use ``stacked create widget <widget_name> --path 'ui/widgets/<the_area_folder>/widgets'`` to create a new widget for a specific area of the application. If you are needing to create a widget inside of a sub-widget, change the ``path`` in the command above accordingly. 

- **Service**: Use ``stacked create service <service_name>`` to create a new service in the ``lib/services/`` folder.
