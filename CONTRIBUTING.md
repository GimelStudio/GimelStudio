# Contributing to Gimel Studio

Thanks for taking the time to contribute. We're excited to have you!

The following is a set of guidelines for contributing to the Gimel Studio repositories, which are hosted in the [Github Organization](https://github.com/GimelStudio) on GitHub. 

These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

Read the following sections in order to know how to ask questions and how to work on something in an orderly manner.

Gimel Studio is an open source project and we love to receive contributions from our community — you! There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting UI translations, bug reports and feature requests or writing code which can be incorporated into Gimel Studio itself.

**Please note that like many open-source projects, we require you to sign a CLA (Contributor License Agreement) when you contribute for the first time.**


#### Table Of Contents

[Asking for help](#asking-for-help)

[What should I know before I get started?](#what-should-i-know-before-i-get-started)
  * [Tech we're using](#tech-were-using)
  * [Design Decisions](#design-decisions)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Your First Code Contribution](#your-first-code-contribution)

[Styleguides](#styleguides)


## Asking For Help

**Please don't use the issue tracker for general support questions**. Check whether the [Github Discussions](https://github.com/GimelStudio/GimelStudio/discussions) can help with your issue.


## What Should I Know Before I Get Started?

### Tech we're using

Gimel Studio itself is written in Python so most code contributions will require at least a basic knowledge of Python 3.8+.

Some nodes are also using GLSL shaders for on-GPU image-manipulation, but knowledge of GLSL isn't required to contribute for most issues.

[Python](https://python.org) – We can effectively use Python’s strong suits (ease-of-use, portability, multitude of packages, large community, etc) and get the performance required by relying on lower-level and performant external libraries to do the heavy lifting (where implementing something in Python would be a bottleneck).

We also use GLSL in addition to Python for image-editing, as applicable, via [ModernGL](https://github.com/moderngl/moderngl). Other graphics rendering API suggestions are welcome!

[Numpy](https://numpy.org) – Numpy is the “data-exchange” format, the core image format used for the backend of Gimel Studio. It is used as “glue” to combine OIIO, GMIC, etc.

[OpenImageIO](https://openimageio.readthedocs.io/en/release-2.2.8.0) – OIIO is used for image input/output and some image editing. OpenImageIO is a library for reading, writing, and processing images in a wide variety of file formats using a format-agnostic API. It is used in professional large-scale visual effects and feature film animation, and it is used ubiquitously by large VFX studios, as well as incorporated into many commercial products.

[Cario](https://pycairo.readthedocs.io/en/latest) – Cairo is a 2D graphics library with support for multiple output devices, including SVG, etc. We will use either Cairo or another library (suggestions welcome) for vector graphics support.

[G'MIC](https://gmic.eu) – For additional image effects and filters (CPU-based). *Mainly need to wait for the [GMIC python bindings](https://github.com/myselfhimself/gmic-py) to support Windows and macOS before implementing this into Gimel Studio, but this probably won’t be implemented until after the core is stable anyway.*

[wxPython](https://wxpython.org) – Is used as the **primary GUI front-end** as it’s a powerful, native, cross-platform GUI toolkit based on wxWidgets.

Modern, styleable widgets for Gimel Studio are currently in development via [gswidgetKit](https://github.com/GimelStudio/gswidgetkit) and a powerful node graph widget via [gsnodegraph](https://github.com/GimelStudio/gsnodegraph).

The API Scripting Language is Python (with the option to use a GLSL shader).

### Design Decisions

When we make a significant decision in how we maintain the project and what we can or cannot support, we will often announce it in our Discord channels. Feel free to ask questions and/or suggest ideas there!


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

* [Good First issues](https://github.com/GimelStudio/GimelStudio/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) - issues which should only require a small amount of code and/or don't require an in-depth knowledge of the existing code. Some of these can be quite challenging even though they don't require a lot of code though!
* [Help wanted issues](https://github.com/GimelStudio/GimelStudio/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22) - issues which should be a bit more involved.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

If you have any questions about contributing, feel free to ask on the official [Discord](https://discord.gg/RqwbDrVDpK) or in a Github issue.


## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use sentence case except for referencing a file, method, function, class, etc in the code
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line

## Python Code

Python code should largely **follow Python' PEP8 guidlines**, except:

* The line length can be greater than the PEP8 character limit
* Capitalization of function and method names are acceptable since this is the style used in wxPython (the GUI library).

### Python File Naming Conventions

* Python file names should use "snake case" and no capital letters (``nodegraph_pnl`` not ``nodegraphpnl``)

### Folder Naming Conventions

Should you need to create a new folder: Folder names should be short, with no spaces and no capital letters (``corenodes`` not ``core_nodes``), except for UI translation folders which are based on the locale (e.g: ``fr_FR``).
