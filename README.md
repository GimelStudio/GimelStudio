<h1 align="center">Gimel Studio</h1>

<p align="center">
  <img href="https://github.com/GimelStudio/GimelStudio/blob/master/LICENSE" src="https://img.shields.io/badge/License-Apache2.0-green.svg" />
  <img href="https://lgtm.com/projects/g/GimelStudio/GimelStudio/" src="https://img.shields.io/lgtm/grade/python/g/GimelStudio/GimelStudio.svg?logo=lgtm&logoWidth=18" />
  <br/>
  Non-destructive, node-based 2D image graphics editor written in Python, focused on simplicity, speed, elegance, and usability<br/>
  <a href="https://gimelstudio.github.io">Official Website</a> | <a href="https://discord.gg/RqwbDrVDpK">Join Our Discord Server</a> | <a href="https://gimelstudio.readthedocs.io/en/latest/">Official Manual</a>
</p>

!["Gimel Studio Banner"](/assets/banner/banner.jpg "Gimel Studio")


# About the Next Generation of Gimel Studio

**The previous (now archived) version of Gimel Studio is still available [here](https://github.com/Correct-Syntax/Gimel-Studio).**

This repository tracks the **next step** of Gimel Studio (the v0.6.x series) to become a truly usable and serious node-based, non-destructive image editor. It is currently in ``initial development stage``, working towards a usable MVP application. Things will probably change a lot from what is currently here.

**We’re especially seeking Python and/or GLSL developers, 3D artists, photographers and UI designers to help with the project.** However, even if you have none of these skills you’re still welcome, of course, to ask questions, give feedback, and suggest ideas and improvements. :)


# Vision

The main goal is to expand on and greatly improve upon the concepts from the [previous version](https://github.com/Correct-Syntax/Gimel-Studio) of Gimel Studio to create a serious (yet fun!) 2D graphics editor.

This includes:

- Re-designed UI (highly inspired by the Blender 2.8x UI and parts of Sketch)
- Improved file-type support (.tiff, .exr files, etc)
- 16-bit workflow support
- CPU and GPU based processing
- Highly improved node-graph and overall workflow for image editing
- Greater emphasis on re-usabilty of node graph setups via templates, etc
- User preferences for customizabilty
- UI translations and localization
- Gizmos for the viewport to allow for WYSIWYG-like interaction for transforms, etc. (e.g. crop, rotate, etc)
- Continued improvement and additions to the Python API for scripting custom nodes

Nodes can be used to composite, create new effects and/or composite raster and vector graphics on-demand. Helpful gizmos in the interactive viewport can be used to do various editing tasks and speed up the workflow. Preset node graph templates can be created, used and re-used to save time setting up common node-setups.

Custom nodes can be scripted with the built-in Python API for maximum flexibility. Integrations with other software like Blender are planned.

With a fully non-destructive workflow that uses both GPU and CPU processing while being seamlessly cross-platform on Windows, Linux and macOS (for 64-bit systems), Gimel Studio aims to be a simple, yet powerful 2D graphics editing tool for anyone with an image to edit.

**Visit our home page [here](https://gimelstudio.github.io) for an overview of the project goals, etc**


# WIP Mockup

Here is a **WIP mockup** of the redesigned UI:

!["Gimel Studio mockup"](https://i.ibb.co/QNNY2vX/gimel-studio-wip-ui.png "Gimel Studio")


# Discord chat

If you’d like to join development, help with the UI design, UI translations, or have questions, comments, and ideas, you can join the Gimel Studio [Discord](https://discord.gg/RqwbDrVDpK). This is where you can chat with the developers, designers and project contributors and get the latest updates on development.

If you prefer to keep to Github instead, feel free to start a discussion [here](https://github.com/GimelStudio/GimelStudio/discussions).


# Status

We are working towards an MVP which will showcase much of the core goals and features listed on the website.

The initial UI is now mostly laid out according to the WIP UI mockup and the core nodegraph rendering is just functional (it “just works”) at the moment. There is much more to do… and we could really use help to speed progress along. ;)

![gs-wip-demo](https://user-images.githubusercontent.com/60711001/136237852-e4a83033-e26c-4ea5-be16-f01cf2936cf7.gif)
*The current status of the next generation of Gimel Studio as of 10/5/2021*

Take a look at the [GitHub Issues](https://github.com/GimelStudio/GimelStudio/issues) for details on immediate and future tasks to be done. Issues labeled “Good first issue” will be the best for new contributors. A familiarity with Python helps, but we are willing to mentor any contributors as needed.

**Pull requests are always welcome! :)**


# Running the code

*Please note: At this stage of development, the code is highly WIP and likely to change a lot. Many things are not implemented and not stable. Please don't expect too much at this point...*

## Windows

1. ``pip install -r requirements.txt``
2. Get the OIIO (OpenImageIO) pre-built python wheel (Windows only) [here](https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio) and install it.
3. ``cd src``
4. ``python main.py``

## Linux

1. ``pip3 install -r requirements.txt``
2. If building wxPython fails, Download the wheel file for wxpython which matches your Python version and Linux OS version from https://extras.wxpython.org/wxPython4/extras/linux/ and install the wxpython package with ``pip3 install <pathtothewheelfilehere>``
3. ``cd src``
4. ``python3 main.py``

Please note that the renderer, which relies on OIIO (OpenImageIO) will **not work if OIIO is not found**. The rest of the application will run, but the renderer will not work. This essentially means that we do not have Linux support yet (please check back later or help us to get it working for linux).

OIIO will need to be [built from source](https://github.com/OpenImageIO/oiio/blob/master/INSTALL.md#building-from-source) since pre-built wheels are not yet available. See [this issue](https://github.com/GimelStudio/GimelStudio/issues/1).

## macOS

1. Make sure you have Python 3.8+ installed on your system.
2. Navigate to the root folder and in your terminal, run ```python3 build.py```. This will install all of the neccesary libraries and will give you the option to create a standalone executable or just run the code with Python.


# Tech we're using

[Python](https://python.org) – We can effectively use Python’s strong suits (ease-of-use, portability, multitude of packages, large community, etc) and get the performance required by relying on lower-level and performant external libraries to do the heavy lifting (where implementing something in Python would be a bottleneck).

We also use GLSL in addition to Python for image-editing, as applicable, via [ModernGL](https://github.com/moderngl/moderngl). Other graphics rendering API suggestions are welcome!

[Numpy](https://numpy.org) – Numpy is the “data-exchange” format, the core image format used for the backend of Gimel Studio. It is used as “glue” to combine OIIO, GMIC, etc.

[OpenImageIO](https://openimageio.readthedocs.io/en/release-2.2.8.0) – OIIO is used for image input/output and some image editing. OpenImageIO is a library for reading, writing, and processing images in a wide variety of file formats using a format-agnostic API. It is used in professional large-scale visual effects and feature film animation, and it is used ubiquitously by large VFX studios, as well as incorporated into many commercial products.

[Cario](https://pycairo.readthedocs.io/en/latest) – Cairo is a 2D graphics library with support for multiple output devices, including SVG, etc. We will use either Cairo or another library (suggestions welcome) for vector graphics support.

[G'MIC](https://gmic.eu) – For additional image effects and filters (CPU-based). *Mainly need to wait for the [GMIC python bindings](https://github.com/myselfhimself/gmic-py) to support Windows and macOS before implementing this into Gimel Studio, but this probably won’t be implemented until after the core is stable anyway.*

[wxPython](https://wxpython.org) – Is used as the **primary GUI front-end** as it’s a powerful, native, cross-platform GUI toolkit based on wxWidgets.

A greatly improved node graph for Gimel Studio is currently in development via the [GS Nodegraph](https://github.com/GimelStudio/gsnodegraph) library.

Modern, styleable widgets for Gimel Studio are currently in development via the [GS WidgetKit](https://github.com/GimelStudio/gswidgetkit) library.

The API Scripting Language is Python (with the option to use a GLSL shader).
