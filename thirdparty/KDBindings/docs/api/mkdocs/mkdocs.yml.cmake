site_name: KDBindings ${CMAKE_PROJECT_VERSION} - Reactive programming & data binding in C++
site_url: https://docs.kdab.com/kdbindings/latest/
repo_url: https://github.com/kdab/kdbindings
site_description: KDBindings Documentation - Reactive programming & data binding in C++
site_author: Klarälvdalens Datakonsult AB (KDAB)

theme:
  name: 'material'
  features:
    - navigation.tabs
      # Navigation.tabs.sticky is an insiders only feature
      # Enable it so it might become available later
    - navigation.tabs.sticky
    - navigation.top
  palette:
    scheme: kdab
  font:
    text: 'Open Sans'
  favicon: assets/assets_logo_tree.svg
  logo: assets/transparentWhiteKDAB.svg
copyright: "Copyright &copy; 2020-2022 Klar&auml;lvdalens Datakonsult AB (KDAB)<br>The Qt, C++ and OpenGL Experts<br><a href='https://www.kdab.com'>https://www.kdab.com/</a>"
extra:
  # Disabling the generator notice is currently a
  # Insiders only feature.
  # Will disappear if this feature becomes publicly available
  generator: false
  social:
    - icon: fontawesome/brands/twitter
      link: https://twitter.com/kdabqt
    - icon: fontawesome/brands/facebook
      link: https://facebook.com/kdabqt
    - icon: fontawesome/solid/envelope
      link: mailto:info@kdab.com
extra_css:
  - stylesheets/kdab.css
markdown_extensions:
  - pymdownx.highlight:
      linenums: true
  - pymdownx.superfences
  - toc:
      permalink: true
nav:
  - Home: 'index.md'
  - Getting Started:
    - Overview: 'getting-started/index.md'
    - 'Signals & Slots': 'getting-started/signals-slots.md'
    - Properties: 'getting-started/properties.md'
    - 'Data Binding': 'getting-started/data-binding.md'
  - Classes: 'Classes.md'
  - Namespaces: 'Namespaces.md'
  - Files: 'Files.md'
  # examples is not capitalizedfor compatibility with
  # the Github examples folder name
  - Examples: 'examples.md'
  - License: 'license.md'
