!["Gimel Studio banner"](/assets/banner/banner.png "Gimel Studio")

Gimel Studio
============

[![GitHub license](https://img.shields.io/github/license/Correct-Syntax/Gimel-Studio?color=light-green)](https://github.com/GimelStudio/GimelStudio/blob/master/LICENSE)
[![Language grade: Python](https://img.shields.io/lgtm/grade/python/g/GimelStudio/GimelStudio.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/GimelStudio/GimelStudio/context:python)

Gimel Studio is a non-destructive, node-based 2D image graphics editor focused on **simplicity, speed, elegance and usability**.

The main goal is to expand on and greatly improve upon the concepts from the [original version](https://github.com/Correct-Syntax/Gimel-Studio) of Gimel Studio to create a serious (yet fun!) 2D graphics editor. 

This includes a re-designed UI (highly inspired by Blender and Sketch), improved file-type support and a concept of layers *and* nodes for image editing. Nodes can be used to composite, create/add new effects and/or composite raster and vector graphics on-demand. Custom nodes can be scripted with the built-in Python API for maximum flexibility.

With a fully non-destructive workflow that uses both GPU and CPU processing while being seamlessly cross-platform on Windows, Linux and MacOs (for 64-bit systems), Gimel Studio aims to be a simple, yet powerful 2d graphics editing tool for beginners and pros alike.


# Status

**The original version of Gimel Studio is available [here](https://github.com/Correct-Syntax/Gimel-Studio).**

This repository tracks the *next step* of Gimel Studio to become a truly usable and serious node-based, non-destructive image editor. It is currently in *planning/initial development stage* and things will probably change (a lot) from what is currently here.

!["Gimel Studio mockup"](https://i.ibb.co/0C2sf3Y/Full-HD.jpg "Gimel Studio")
*Early WIP mockup of the redesigned UI*


# Join this project

You're welcome to join us in planning/development for the next step of Gimel Studio!

If you'd like to join development or have questions, comments or ideas you can join the Gimel Studio [Discord](https://discord.gg/RqwbDrVDpK). This is where you can chat with the developers and get the latest development updates (at the moment).


# Running the code

There's not much here right now, but if you'd like to see the latest (initial) updates to the GUI and backend, you can do so by following the steps below:

1. ``pip install -r requirements.txt``
2. ``python src/main.py``


# Tech Stack

[Python](https://python.org) - We can effectively use Python's strong suits (ease-of-use, portability, multitude of packages, large community, etc) and get the performance required by relying on lower-level and performant external libraries to do the heavy lifting (where implementing something in Python would be a bottleneck). This should also lower the bar on contributing to Gimel Studio and thus (hopefully) allow for a greater contributor base.

We also plan to use GLSL and/or it's variants in addition to Python for image-editing, as applicable, via [ModernGL](https://github.com/moderngl/moderngl), [glnext](https://github.com/cprogrammer1994/glnext) or another graphics rendering API (suggestions welcome!). **(This is still undecided)**

[Numpy](https://numpy.org/) - Numpy will be the "data-exchange" format, the core image format used for the backend of Gimel Studio. It will be used as "glue" to combine OIIO, GMIC, etc.

[OpenImageIO](https://openimageio.readthedocs.io/en/release-2.2.8.0/) - OIIO will be used for image IO and (possibly) some image editing. OpenImageIO (OIIO) is a library for reading, writing, and processing images in a wide variety of file formats, using a format-agnostic API. It is used in professional, large-scale visual effects and feature film animation, and it is used ubiquitously by large VFX studios, as well as incorporated into many commercial products.

[Cario](https://pycairo.readthedocs.io/en/latest/) - Cairo is a 2D graphics library with support for multiple output devices, including SVG, etc. We will use either cairo or [Skia graphics engine](https://skia.org/) for vector graphics support.

[G'MIC](https://gmic.eu/) - For additional image effects and filters (CPU-based). *Mainly need to wait for the [GMIC python bindings](https://github.com/myselfhimself/gmic-py) to support Windows and MacOs before implementing this into Gimel Studio, but this probably won't be implemented until after the core is stable anyway.*

[wxPython](https://wxpython.org) -  Will be used as the **primary GUI front-end** as it's a powerful, native, cross-platform GUI toolkit based on wxWidgets. For good examples of wxpython used as a toolkit for graphics applications see [sK1 vector graphics editor](https://sk1project.net/) and [ImagePy](https://github.com/Image-Py).

**API Scripting Language:** Python, of course. :)