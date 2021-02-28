Gimel Studio
============

Gimel Studio is a non-destructive, node-based 2D image graphics editor.

[![GitHub license](https://img.shields.io/github/license/Correct-Syntax/Gimel-Studio?color=light-green)](https://github.com/GimelStudio/GimelStudio/blob/master/LICENSE)


# Status

**The original, experimental version of Gimel Studio is available at https://github.com/Correct-Syntax/Gimel-Studio.**

This repository tracks the next step of Gimel Studio to become a truly usable and serious node-based, non-destructive image editor. It is currently in *planning stage* and things will probably change from what is currently here.


# Join this project

You're welcome to join us in planning/development for the next step of Gimel Studio!

If you'd like to join development or have questions, comments or ideas you can join the Gimel Studio [discord server](https://discord.gg/RqwbDrVDpK).


# Tech Stack

[Python](https://python.org) - We can effectively use Python's strong suits (ease-of-use, portability, multitude of packages, large community, etc) and get the performance required by relying on lower-level and performant external libraries to do the heavy lifting where implementing something in Python would be a bottleneck. This should also lower the bar on contributing to Gimel Studio and thus (hopefully) allow for a greater contributor base.

We also plan to use GLSL and/or it's variants in addition to Python for image-editing, as applicable, via [ModernGL](https://github.com/moderngl/moderngl) or another graphics API (suggestions welcome!). **(This is still undecided)**

[Numpy](https://numpy.org/) - Numpy will be the "data-exchange" format, the core image format used for the backend of Gimel Studio. It will be used as "glue" to combine OIIO, GMIC, etc.

[OpenImageIO](https://openimageio.readthedocs.io/en/release-2.2.8.0/) - OIIO will be used for image IO and (possibly) some image editing. OpenImageIO (OIIO) is a library for reading, writing, and processing images in a wide variety of file formats, using a format-agnostic API. It is used in professional, large-scale visual effects and feature film animation, and it is used ubiquitously by large VFX studios, as well as incorporated into many commercial products. *Needs Linux and MacOs wheels built for python. (currently WIP)*

[Cario](https://pycairo.readthedocs.io/en/latest/) - Cairo is a 2D graphics library with support for multiple output devices, including SVG, etc. We will use cario for vector graphics support (if decided that we're going in that direction).

[G'MIC](https://gmic.eu/) - For additional image effects and filters (CPU-based). *Mainly need to wait for the [GMIC python bindings](https://github.com/myselfhimself/gmic-py) to support Windows and MacOs before implementing this into Gimel Studio, but this probably won't be implemented until after the core is stable anyway.*

[wxPython](https://wxpython.org) -  Will be used as the **primary GUI front-end** as it's a powerful, native, cross-platform GUI toolkit based on wxWidgets. For good examples of wxpython used as a toolkit for graphics applications see [sK1 vector graphics editor](https://sk1project.net/) and [ImagePy](https://github.com/Image-Py).

[Vue.js](https://vuejs.org/) Vue.js (web frontend framework) will be used for a **web-based UI front-end**. This will be *experimental* and mainly used for prototyping as it will use websockets to communicate with the Gimel Studio core backend and it may or may not be the best, performance-wise.

**API Scripting Language:** Python, of course. :)

*Other possible libs (undecided): OpenCV, Scipy, etc*