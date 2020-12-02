.. _building-label:

===============================
Appendix A: Building the Client
===============================

This section explains how to build the Nextcloud Client from source for all
major platforms. You should read this section if you want to develop for the
desktop client.

.. note:: Build instructions are subject to change as development proceeds.
  Please check the version for which you want to build.

These instructions are updated to work with version |version| of the Nextcloud Client.

You have two possibilities to clone the repo. 

First option is As [remote URL](https://help.github.com/en/articles/which-remote-url-should-i-use) you can choose between cloning with HTTPS URL's, which is recommended or cloning with SSH URL's. 

[https://github.com/nextcloud/desktop.git](https://github.com/nextcloud/desktop.git)

When you don't have SSH key added to your GitHub account, than use HTTPS. 

When you no part of the nextcloud organisation, clone with HTTPS:

```
$ git clone git@github.com:nextcloud/desktop.git
```

macOS
-----

In addition to needing XCode (along with the command line tools), developing in
the macOS environment requires extra dependencies.  You can install these
dependencies through MacPorts_ or Homebrew_.  These dependencies are required
only on the build machine, because non-standard libs are deployed in the app
bundle.

The tested and preferred way to develop in this environment is through the use
of HomeBrew_. The team has its own repository containing non-standard
recipes.

To set up your build environment for development using HomeBrew_:

1. Install Xcode
2. Install Xcode command line tools::
    xcode-select --install

3. Install homebrew::
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

4. Add the Nextcloud repository using the following command::

    brew tap owncloud/owncloud

5. Install a Qt5 version with qtwebkit support::

    brew install qt5

6. Install any missing dependencies::

    brew install $(brew deps owncloud-client)

7. Add Qt from brew to the path::

    export PATH=/usr/local/Cellar/qt5/5.x.y/bin:$PATH

   Where ``x.y`` is the current version of Qt 5 that brew has installed
   on your machine.
8. Install qtkeychain from here:  git clone https://github.com/frankosterfeld/qtkeychain.git
   make sure you make the same install prefix as later while building the client e.g.  -
   ``DCMAKE_INSTALL_PREFIX=/Path/to/client-install``

9. For compilation of the client, follow the :ref:`generic-build-instructions`.

10. Install the Packages_ package creation tool.

11. Enable git submodules:
```
$ cd desktop
$ git submodule init
$ git submodule update
```

12. Generate the build files:
```
$ cd build
$ cmake .. -DCMAKE_INSTALL_PREFIX=~/nextcloud-desktop-client -DCMAKE_BUILD_TYPE=Debug -DNO_SHIBBOLETH=1 
```

13. Compile and install:
```
$ make install
```

   .. note:: Contrary to earlier versions, Nextcloud 1.7 and later are packaged
             as a ``pkg`` installer. Do not call "make package" at any time when
             compiling for OS X, as this will build a disk image, and will not
             work correctly.

Windows Development Build
-------------------------

If you want to test some changes and deploy them locally, you can build natively
on Windows using MinGW. If you want to generate an installer for deployment, please
follow `Windows Installer Build (Cross-Compile)`_ instead.

1. Get the required dependencies:

   * Make sure that you have CMake_ and Git_.
   * Download the Qt_ MinGW package. You will use the MinGW version bundled with it.
   * Download an `OpenSSL Windows Build`_ (the non-"Light" version)

2. Get the QtKeychain_ sources as well as the latest versions of the Nextcloud client
   from Git as follows::

    git clone https://github.com/frankosterfeld/qtkeychain.git
    git clone git://github.com/nextcloud/client.git

3. Open the Qt MinGW shortcut console from the Start Menu

4. Make sure that OpenSSL's ``bin`` directory as well as your qtkeychain source
   directories are in your PATH. This will allow CMake to find the library and
   headers, as well as allow the Nextcloud client to find the DLLs at runtime::

    set PATH=C:\<OpenSSL Install Dir>\bin;%PATH%
    set PATH=C:\<qtkeychain Clone Dir>;%PATH%

5. Build qtkeychain **directly in the source directory** so that the DLL is built
   in the same directory as the headers to let CMake find them together through PATH::

    cd <qtkeychain Clone Dir>
    cmake -G "MinGW Makefiles" .
    mingw32-make
    cd ..

6. Create the build directory::

     mkdir client-build
     cd client-build

7. Build the client::

     cmake -G "MinGW Makefiles" ../client
     mingw32-make

   .. note:: You can try using ninja to build in parallel using
      ``cmake -G Ninja ../client`` and ``ninja`` instead.
   .. note:: Refer to the :ref:`generic-build-instructions` section for additional options.

   The Nextcloud binary will appear in the ``bin`` directory.

Windows Installer Build (Cross-Compile)
---------------------------------------

Due to the large number of dependencies, building the client installer for Windows
is **currently only officially supported on openSUSE**, by using the MinGW cross compiler.
You can set up any currently supported version of openSUSE in a virtual machine if you do not
have it installed already.

In order to make setup simple, you can use the provided Dockerfile to build your own image.

1. Assuming you are in the root of the Nextcloud Client's source tree, you can
   build an image from this Dockerfile like this::

    cd admin/win/docker
    docker build . -t nextcloud-client-win32:<version>

   Replace ``<version>`` by the version of the client you are building, e.g.
   |version| for the release of the client that this document describes.
   If you do not wish to use docker, you can run the commands in ``RUN`` manually
   in a shell, e.g. to create your own build environment in a virtual machine.

   .. note:: Docker images are specific to releases. This one refers to |version|.
             Newer releases may have different dependencies, and thus require a later
             version of the docker image! Always pick the docker image fitting your release
             of Nextcloud client!

2. From within the source tree Run the docker instance::

     docker run -v "$PWD:/home/user/client" nextcloud-client-win32:<version> \
        /home/user/client/admin/win/docker/build.sh client/  $(id -u)

   It will run the build, create an NSIS based installer, as well as run tests.
   You will find the resulting binary in an newly created ``build-win32`` subfolder.

   If you do not wish to use docker, and ran the ``RUN`` commands above in a virtual machine,
   you can run the indented commands in the lower section of ``build.sh`` manually in your
   source tree.

4. Finally, you should sign the installer to avoid warnings upon installation.
   This requires a `Microsoft Authenticode`_ Certificate ``osslsigncode`` to sign the installer::

     osslsigncode -pkcs12 $HOME/.codesign/packages.pfx -h sha256 \
               -pass yourpass \
               -n "ACME Client" \
               -i "http://acme.com" \
               -ts "http://timestamp.server/" \
               -in ${unsigned_file} \
               -out ${installer_file}

   For ``-in``, use the URL to the time stamping server provided by your CA along with the Authenticode certificate. Alternatively,
   you may use the official Microsoft ``signtool`` utility on Microsoft Windows.

   If you're familiar with docker, you can use the version of ``osslsigncode`` that is part of the docker image.

.. _generic-build-instructions:

Generic Build Instructions
--------------------------

Compared to previous versions, building the desktop sync client has become easier. Unlike
earlier versions, CSync, which is the sync engine library of the client, is now
part of the client source repository and not a separate module.

To build the most up-to-date version of the client:

1. Clone the latest versions of the client from Git_ as follows::

     git clone git://github.com/nextcloud/client.git
     cd client
     git submodule init
     git submodule update

2. Create the build directory::

     mkdir client-build
     cd client-build

3. Configure the client build::

     cmake -DCMAKE_BUILD_TYPE="Debug" ..

   .. note:: You must use absolute paths for the ``include`` and ``library``
            directories.

   .. note:: On macOS, you need to specify ``-DCMAKE_INSTALL_PREFIX=target``,
            where ``target`` is a private location, i.e. in parallel to your build
            dir by specifying ``../install``.

   .. note:: qtkeychain must be compiled with the same prefix e.g ``CMAKE_INSTALL_PREFIX=/Users/path/to/client/install/ .``

   .. note:: Example:: ``cmake -DCMAKE_PREFIX_PATH=/usr/local/opt/qt5 -DCMAKE_INSTALL_PREFIX=/Users/path/to/client/install/  -DNO_SHIBBOLETH=1``

4. Call ``make``.

   The Nextcloud binary will appear in the ``bin`` directory.

5. (Optional) Call ``make install`` to install the client to the
   ``/usr/local/bin`` directory.

The following are known cmake parameters:

* ``QTKEYCHAIN_LIBRARY=/path/to/qtkeychain.dylib -DQTKEYCHAIN_INCLUDE_DIR=/path/to/qtkeychain/``:
   Used for stored credentials.  When compiling with Qt5, the library is called ``qt5keychain.dylib.``
   You need to compile QtKeychain with the same Qt version.
* ``WITH_DOC=TRUE``: Creates doc and manpages through running ``make``; also adds install statements,
  providing the ability to install using ``make install``.
* ``CMAKE_PREFIX_PATH=/path/to/Qt5.2.0/5.2.0/yourarch/lib/cmake/``: Builds using Qt5.
* ``BUILD_WITH_QT4=ON``: Builds using Qt4 (even if Qt5 is found).
* ``CMAKE_INSTALL_PREFIX=path``: Set an install prefix. This is mandatory on Mac OS

.. _CMake: http://www.cmake.org/download
.. _CSync: http://www.csync.org
.. _Client Download Page: https://nextcloud.com/install/#install-clients
.. _Git: http://git-scm.com
.. _MacPorts: http://www.macports.org
.. _Homebrew: http://mxcl.github.com/homebrew/
.. _OpenSSL Windows Build: http://slproweb.com/products/Win32OpenSSL.html
.. _Qt: http://www.qt.io/download
.. _Microsoft Authenticode: https://msdn.microsoft.com/en-us/library/ie/ms537361%28v=vs.85%29.aspx
.. _QtKeychain: https://github.com/frankosterfeld/qtkeychain
.. _Packages: http://s.sudre.free.fr/Software/Packages/about.html
