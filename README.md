<h1 align="center">Gimel Studio</h1>

<p align="center">
  <img href="https://github.com/GimelStudio/GimelStudio/blob/master/LICENSE" src="https://img.shields.io/badge/License-Apache2.0-green.svg" />
  <br/>
  Non-destructive, node-based 2D graphics editor, focused on simplicity, speed, elegance, and usability<br/>
  <a href="https://gimelstudio.github.io">Official Website</a> | <a href="https://gimelstudio.zulipchat.com/join/sif32f3gjpnikveonzgc7zhw/">Community Chat</a> | <a href="https://gimelstudio.readthedocs.io/en/latest/">Official Manual</a>
</p>

!["Gimel Studio Banner"](/assets/banner/gimel-studio-06-pre-3.png "Gimel Studio")


# About Gimel Studio

This repository tracks the next step of Gimel Studio to become a truly usable and serious non-destructive graphics editor. It is currently in ``initial planning/development`` stage, working towards a usable MVP application. Things will probably change **a lot** from what is currently here.

You’re always welcome to help out, ask questions, give feedback, and suggest ideas/improvements.

**Join us in our Zulip chat organization [here](https://gimelstudio.zulipchat.com/join/sif32f3gjpnikveonzgc7zhw/) to give your feedback and stay in the loop!**


# Project Vision

The main goal is to expand on and greatly improve upon the concepts from the [previous version](https://github.com/Correct-Syntax/Gimel-Studio) of Gimel Studio to create a serious (yet fun!) 2D graphics editor.

This includes:

- Re-designed UI (inspired by Blender and Sketch)
- Improved file-type support (.tiff, .exr files, etc)
- 16-bit workflow support
- CPU and GPU based processing
- Highly improved node-graph and overall workflow for image editing
- Greater emphasis on re-usabilty of node graph setups via templates, etc
- User preferences for customizabilty
- UI translations
- Gizmos for the viewport to allow for WYSIWYG-like interaction for transforms, etc. (e.g. crop, rotate, etc)
- Continued improvement and additions to the Python API for scripting custom nodes
- And more...

Nodes can be used to composite, edit and create new effects and/or composite raster and vector graphics on-demand and visually with node thumbnails showing each step of the process (where applicable). Helpful gizmos in the interactive viewport can be used to do various editing tasks and speed up the workflow. Preset node graph templates can be created, used and re-used to save time setting up common node-setups.

Custom nodes can be scripted with the built-in Python API for maximum flexibility. Integrations with other software are planned.

With a fully non-destructive workflow that uses both GPU and CPU processing (via GLSL + OpenGL) while being seamlessly cross-platform on Windows, Linux and macOS (for 64-bit systems), Gimel Studio aims to be a simple, yet powerful 2D graphics editing tool for anyone with an image to edit.


# Current Status

**6/6/22 update:** We're in the process of planning for another step to hopefully propel the project forward with a clearer goals and organization.

**Join us in our Zulip chat organization [here](https://gimelstudio.zulipchat.com/join/sif32f3gjpnikveonzgc7zhw/) to give your feedback and stay in the loop!**

There are [alpha pre-releases](https://github.com/GimelStudio/GimelStudio/releases) available for those wanting to test the current functionality.

![gs-wip-demo](https://user-images.githubusercontent.com/60711001/148820733-358faad6-ee80-4d27-b9c2-2503c6b0abf8.gif)
*The status of the next generation of Gimel Studio as of 1/10/2022*


# Contributing

Take a look at the [GitHub Issues](https://github.com/GimelStudio/GimelStudio/issues) for details on immediate and future tasks to be done. Issues labeled “Good first issue” will be the best for new contributors. We are willing to mentor any contributors as needed.

**Pull requests are always welcome! :)**

Please see the [CONTRIBUTING.md](CONTRIBUTING.md) for some details on contributing.


# Running the code

*Please note: At this stage of development, the code is highly WIP and likely to change a lot. Many things are not implemented and not stable. Please don't expect too much at this point...*

## Windows

1. Make sure you have Python 3.9 or 3.10 installed on your system.
2. Run ``pip install -r requirements.txt``
3. You can get an older release of OIIO (OpenImageIO) [here](https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio) and install it with ``pip install <the_path_to_the_whl_here>``. Or, to use the latest version of OIIO, follow the build instructions [here](https://github.com/Correct-Syntax/py-oiio#windows-build-steps).
4. Run ``cd src`` then ``python main.py`` to navigate to the src directory and run Gimel Studio.
5. To build an executable, make sure you are in the root directory and run ``python build.py``. The executable will be generated in the ``dist`` folder.

## Linux

*This has been tested on Debian-based systems (Ubuntu, Linux Mint). Other distros may require extra configuration.*

1. Make sure you have Python 3.9 installed on your system.
2. Navigate to the root folder and in your terminal, run ``python3 build.py``. This will begin a process to install all of the neccesary libraries and will give you the option to create a standalone executable or just run the code with Python.

## macOS

1. Make sure you have Python 3.8 or 3.9 installed on your system.
2. Navigate to the root folder and in your terminal, run ``python3 build.py``. This will install all of the neccesary libraries and will give you the option to create a standalone executable or just run the code with Python.
