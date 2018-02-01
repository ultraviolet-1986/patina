# Patina
A 'patina', 'layer', or 'toolbox' for BASH under Linux which aims to help users perform tasks quicker by the command line.

# Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Features](#features)
- [Recommended Packages](#recommended-packages)
- [Conventions](#conventions)
- [Patina Layout](#patina-layout)
- [Built-in Commands](#built-in-commands)
  - [Patina](#patina)
  - [Themes](#themes)
  - [Prompts](#prompts)
  - [Places](#places)
  - [Application Components](#application-components)
    - [ClamAV](#clamav)
    - [Uncomplicated Firewall (ufw)](#uncomplicated-firewall-ufw)
  - [Place Components](#place-components)
  - [System Components](#system-components)
- [Helper Functions](#helper-functions)
- [Acknowledgements and References](#acknowledgements-and-references)

# Introduction

*Patina* allows its users to write more efficient scripts and make them instantly available to their command prompt without the need for sourcing individually; instead, a user can simply drop their script into the appropriate folder and execute it immediately. Inspired by the principles behind Kon-Mari, *Patina* also contains some pre-defined components which can help the user keep their system clean, tidy and efficient.

# Installation

## Step 1

Clone into the `patina` repository using your BASH shell (example below):

```bash
$ git clone http://github.com/ultraviolet-1986/patina ~/Workspace
```

## Step 2

Once the repository has been cloned, you must *source* it in your BASH profile.

This is named `.bash_profile`, or `.bashrc` depending on your operating system.
A sample line can be seen below:

```bash
source "$HOME/Workspace/patina/patina.sh"
```

# Features
Patina is a BASH script with transparent and easy-to-read code, which contains the following features:

- Compatible with any Linux distribution and Microsoft Windows 10 using the Windows sub-system for Linux, requiring only BASH to operate at its most basic.
- Provides a means of memorising fewer, shorter commands which will operate in exactly the same way regardless of Operating System.
- Contains a unified look-and-feel derived from popular Linux distributions.
- Provides a useful set of basic helper functions for easier script creation.
- Contains a selection of vibrant colour themes to personalise your prompt.
- Provides a means of instantly accessing your scripts.
- Can be restarted to detect and connect new scripts without closing the console.
- Contains a dynamic update mechanism using `git` source control.
- Is not intrusive and its own conventions are easy to learn and never replace existing functionality.

# Recommended Packages
Patina does not require anything except BASH as a rule, but it can make use of the following packages (correct for Ubuntu):

| **Package** | **Description**                                      |
|-------------|------------------------------------------------------|
| `clamav`    | For the `p-clamscan <X>` commands. |
| `git`       | For the `p-update` command.                          |
| `systemd`   | For manipulating system services such as networking. |
| `ufw`       | For the `p-ufw <X>` commands.                        |
| `xdg-utils` | For opening files, locations, and URLs graphically.  |

# Conventions
One of Patina's more prominent features is its directory structure - Patina connects to these directories and the scripts within automatically, acting as a hub. These scripts are called 'components' - a component requires no execution code and can simply contain functions that can then be called instantly without executing the script. An example 'Patina Component' can be seen below:

```bash
#!/bin/bash

hello_world() {
  echo 'Hello, World!'
}

alias 'p-hello'='hello_world'
```

The above file can be saved within the `components/user` folder as `patina_user_hello.sh` and Patina will automatically connect to it on startup. A file saved within the `components/system` folder would be saved as `patina_system_hello.sh` - this is a convention which can help keep components better organised. This naming convention **must** be followed as far as `patina_<name>.sh` as a minimum, or Patina will ignore the script and not connect to it.

The only required code for a component is a function; in this case: `hello_world`. When starting Patina, you can then simply type 'hello_world' (sans quotes) to activate your function instead of executing the script and calling the function externally.

Notice the `p-hello` alias toward the end of the file? This is another convention of Patina: the `p-` prefix indicates a Patina function and simply makes for a shorter (yet still memorable) command. This is not a required convention, but it can be useful to keep your functionality separate from the rest of the shell and help to prevent naming conflicts.

With Patina version `0.1.0` and later, semantic version numbering is added and displayed alongside the current version of BASH. This will be in the format of `Major.Minor.Patch`.

# Patina Layout
The default directory structure for Patina may not be present when cloning into the repository, but will be generated when Patina starts. The following diagram demonstrates the intended layout:

```
home
    |
    +-- .patinarc

patina
    |
    +-- CHANGELOG.md
    +-- LICENSE
    +-- patina.sh
    +-- README.md
    +-- components
    |   |
    |   +-- applications
    |   +-- places
    |   +-- system
    |   +-- user
```

This layout is inspired by the GNOME 2 / MATE desktops' custom menu bar, which contains `Applications`, `Places`, and `System` menu categories respectively - by mimicking this structure, Patina components can be categorised and better organised for a user. The additional `user` folder is for any components which may not fit in the original three categories, or are for testing purposes.

# Built-in Commands

In a similar manner to the component naming convention, Patina includes some built-in functions, which follow this convention and can be called at any time. The basic commands are listed below:

## Patina

| **Command** | **Description**                                                                        |
|-------------|----------------------------------------------------------------------------------------|
| `p-update`  | Check for and apply Patina updates.                                                    |
| `p-list`    | Display a list of connected Patina components.                                         |
| `p-refresh` | Restart Patina to detect and connect to new components.                                |
| `p-reset`   | Clear command-line history and restart Patina to detect and connect to new components. |

## Themes

| **Command**       | **Description**                                              |
|-------------------|--------------------------------------------------------------|
| `p-theme default` | Apply light/dark magenta theme.                              |
| `p-theme blue`    | Apply light/dark blue theme.                                 |
| `p-theme cyan`    | Apply light/dark cyan theme.                                 |
| `p-theme green`   | Apply light/dark green theme.                                |
| `p-theme magenta` | Apply light/dark magenta theme.                              |
| `p-theme red`     | Apply light/dark red theme.                                  |
| `p-theme yellow`  | Apply light/dark yellow theme.                               |
| `p-theme black`   | Apply basic black theme.                                     |
| `p-theme gray`    | Apply basic light/dark gray theme (United States spelling).  |
| `p-theme grey`    | Apply basic light/dark gray theme (United Kingdom spelling). |
| `p-theme white`   | Apply basic white theme.                                     |
| `p-theme blossom` | Apply light magenta/light red theme.                         |
| `p-theme classic` | Apply light magenta/light cyan theme.                        |
| `p-theme cygwin`  | Apply light green/light yellow theme.                        |
| `p-theme gravity` | Apply light magenta/light yellow theme.                      |
| `p-theme mint`    | Apply light green/light blue theme.                          |
| `p-theme solus`   | Apply a Solus-like theme using light blue/light purple.      |
| `p-theme varia`   | Apply light red/light yellow theme.                          |
| `p-theme water`   | Apply light blue/cyan theme.                                 |

## Prompts

| **Command**        | **Description**                   |
|--------------------|-----------------------------------|
| `p-prompt default` | Apply the standard Patina prompt. |
| `p-prompt debian ` | Apply a Debian-like prompt.       |
| `p-prompt patina`  | Apply the standard Patina prompt. |
| `p-prompt solus`   | Apply a Solus-like prompt.        |

## Places

| **Command**        | **Description**                                                                                       |
|--------------------|-------------------------------------------------------------------------------------------------------|
| `files`            | Open default File Manager, will open the Home directory if a valid path is not given as an argument.  |
| `p-root`           | Open the Patina root directory in the default File Manager and command-line.                          |
| `p-c`              | Open the Patina 'components' directory in the default File Manager and command-line.                  |
| `p-c-applications` | Open the Patina 'application components' directory in the default File Manager and command-line.      |
| `p-c-places`       | Open the Patina 'place components' directory in the default File Manager and command-line.            |
| `p-c-system`       | Open the Patina 'system components' directory in the default File Manager and command-line.           |
| `p-c-user`         | Open the Patina 'user components' directory in the default File Manager and command-line.             |
| `p-source`         | Open the Patina source code file in the default Text Editor.                                          |
| `p-config`         | Open the Patina preferences file in the default Text Editor.                                          |
| `p-url <X>`        | Open a valid URL in the default web browser.                                                          |
| `p-url patina`     | Open the Patina GitHub page in the default web browser: <https://github.com/ultraviolet-1986/patina>. |

## Application Components

### ClamAV

| **Command**       | **Description**                                                                                               |
|-------------------|---------------------------------------------------------------------------------------------------------------|
| `p-clamscan`      | Perform a ClamAV virus scan on a given path and offer to record the results within the user's home directory. |
| `p-clamscan help` | Display instructions for the `p-clamscan` commands.                                                           |

### Uncomplicated Firewall (ufw)

*In most cases, the following commands require `sudo` privileges, please review source code before use.*

| **Command**       | **Description**                                                                                               |
|-------------------|---------------------------------------------------------------------------------------------------------------|
| `p-ufw disable`   | Disable the `ufw` firewall (not recommended).                                                                 |
| `p-ufw enable`    | Enable the `ufw` firewall (recommended).                                                                      |
| `p-ufw help`      | Display instructions for `p-ufw` commands.                                                                    |
| `p-ufw reset`     | Enable the `ufw` firewall and remove the basic rules added by the `p-ufw setup` command.                      |
| `p-ufw setup`     | Enable the `ufw` firewall with some basic defaults (please refer to source code before usage).                |
| `p-ufw status`    | Display the status of the `ufw` firewall in a table.                                                          |

## Place Components

| **Command** | **Description**                                                            |
|-------------|----------------------------------------------------------------------------|
| `home`      | Open the Home directory in the default File Manager and command-line.      |
| `desktop`   | Open the Desktop directory in the default File Manager and command-line.   |
| `documents` | Open the Documents directory in the default File Manager and command-line. |
| `downloads` | Open the Downloads directory in the default File Manager and command-line. |
| `music`     | Open the Music directory in the default File Manager and command-line.     |
| `pictures`  | Open the Pictures directory in the default File Manager and command-line.  |
| `public`    | Open the Public directory in the default File Manager and command-line.    |
| `templates` | Open the Templates directory in the default File Manager and command-line. |
| `videos`    | Open the Videos directory in the default File Manager and command-line.    |

## System Components


| **Command**           | **Description**                                                                                               |
|-----------------------|---------------------------------------------------------------------------------------------------------------|
| `p-calibrate <X> <Y>` | Draw a grid on the Terminal so the window can be properly resized (helpful when there are no 'resize hints'). |
| `p-os`                | Display the details of the Operating System.                                                                  |

*The following commands require a `systemd` environment and will prompt the user for a password, please review source code before use.*

| **Command**         | **Description**                                             |
|---------------------|-------------------------------------------------------------|
| `p-network disable` | Disable the networking service.                             |
| `p-network enable`  | Enable the networking service.                              |
| `p-network restart` | Restart the networking service.                             |
| `p-network start`   | Start the networking service.                               |
| `p-network status`  | Display whether or not an Internet connection is available. |
| `p-network stop`    | Stop the networking service.                                |

*The following commands require `sudo` privileges, please review source code before use.*

| **Command**                           | **Description**                                                |
|---------------------------------------|----------------------------------------------------------------|
| `p-package install` / `p-pkg install` | Install package(s) using default package manager.              |
| `p-package remove` / `p-pkg remove`   | Remove package(s) using default package manager.               |
| `p-package update` / `p-pkg update`   | Update package catalogue using default package manager.        |
| `p-package upgrade` / `p-pkg upgrade` | Upgrade outdated package(s) using the default package manager. |

# Helper Functions

The following helper functions can be included in any component or external script as long as Patina is running:

| **Command**                          | **Description**                                                   |
|--------------------------------------|-------------------------------------------------------------------|
| `echo_wrap "<Paragraph typed here>"` | Will echo and word-wrap text to the correct width of the console. |

# Acknowledgements and References

- Thanks to **Kieran Burrell** for optimising script-connection logic.
- `patina_update`
  - [Neil Mayhew / Stack Overflow](http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git)
