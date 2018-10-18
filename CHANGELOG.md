# Changelog

## Table of Contents

- [0.7.x Series: 'Duchess'](#07x-series-duchess)
- [0.6.x Series: 'Kyrie'](#06x-series-kyrie)

## 0.7.x Series: 'Duchess'

The name **Duchess** was taken from the Disney film **The Aristocats**, she is a
mother to three mischievous young kittens and guides them on a long journey home
after an evil butler tries to steal their inheritance.

- **0.7.4 Now in testing**
  - Have reinstated the `files` command to facilitate navigation using the
    command-line. This will not require the `-g` command switch and will always
    both change directory on the console and open the location graphically using
    the default file manager.
  - Updated `README.md` to show new command(s) and have updated it according to
    Markdown style standards.
  - The path-detection logic for `files` and other commands such as `p-root` and
    `documents` (for example) have been updated to allow only access to
    directories and not files.
  - A new component named `patina_system_display_server.sh` has been added. This
    allows the user quickly probe the system and determine whether the current
    desktop is running under `Xorg` or `Wayland`.
  - A new Patina Exception has been added, named `PE0010`, it is thrown when
    Patina cannot detect a required variable.
- **0.7.3 Released Wednesday, August 8th 2018**
  - Included the initial check and import of the '/etc/os-release' and
    '/etc/lsb-release' files to allow a better interrogation of the host
    operating system. This aids system integration.
  - The source code for Patina now contains the correct license references and
    the terminal output has been updated to reflect this.
  - Version numbering has been reverted to a string for the sake of simplicity.
  - Updated the initial loading message.
- **0.7.2 Released Monday, May 21st 2018**
  - Drastically simplified `patina_system_theming.sh` code by removing `case`
    statements and shifting all logic to the outer `if` tree.
  - Corrected function termination in `patina_system_theming.sh` file so that
    the chosen theme is not applied twice during initialisation.
  - Improved the Operating System detection wall during startup so that it is
    not nesting more code within `if` statements.
  - Loading themes and error-handling themes is now handled by the
    `patina_system_theming.sh` component. This helps to encapsulate
    functionality in a more efficient fashion.
  - Have removed the `patina_system_services.sh` component and updated
    `patina_system_network.sh` to remove its dependency on it.
  - Have removed `patina_system_terminal.sh` and `patina_system_xdg.sh` and have
    moved useful functionality to the main `patina.sh` script.
  - The `patina_system_package_manager.sh` component has been updated to
    detect an Internet connection before beginning.
  - Some functionality has been updated to improve execution times.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).
- **0.7.1 Released Tuesday, April 24th 2018**
  - A new folder specifically for documentation has been included in Patina's
    root directory and is named `resources`. At present it contains two sub-
    folders named `exceptions` and `help`, these will assist in the organisation
    of documentation to come. Existing documentation has been moved into this
    new structure.
  - There is now a side-project for Patina named *Patina User Components*, it
    can be found at:
    <https://github.com/ultraviolet-1986/patina-user-components>. A user can now
    cherry-pick extra components that add functionality not typically relevant
    to Patina's scope.
  - Three commands have been included to allow quick-access to Patina's new
    `resources` locations - they are `p-r`, `p-r-exceptions`, and `p-r-help`.
    An explanation for these has been added to `README.md`.
  - Sample exception files have been placed within the appropriate directory,
    and a reference list has been added to the new `EXCEPTIONS.md` file along
    with a demonstration of their use in pseudo-code.
  - Improved exception-throwing logic, Patina will now attempt to match a
    specific string. The arguments passed must be in the `PE0000` format.
  - Removed the `p-clamav` alias and edited the `README.md` file to reflect
    this.
  - Updated Internet connection detection so that Patina will now ping
    Cloudflare (1.1.1.1) instead of Google (8.8.8.8).
  - Drastically simplified `patina_system_updater.sh` code.
  - Removed `p-os` command as it did not provide much to Patina and updated the
    `README.md` file to reflect this.
  - Removed `p-calibrate` command from main repository, placed it within the
    `patina-user-components` repository and updated the `README.md` file to
    reflect this.
  - Have updated `patina_system_theming.sh` to allow colour in text-only
    sessions such as a server (where supported).
  - Support for opening files/URLs has been dropped as a response to
    [KDE Neon](https://neon.kde.org/) displaying security warnings regarding
    this so the commands `p-file` and `p-url` have been removed, and the `files`
    command has been obsoleted.
  - Opening locations such as `p-root` or `downloads` will now only change the
    current folder in the terminal. This can be opened graphically also by
    appending `-g` to the end of the command.
  - Fixed minor bugs with function termination.
- **0.7.0 Released Wednesday, April 4th 2018**
  - Version numbering has been split into three integer variables to introduce
    the possibility of validating a component against a specific version of
    Patina.
  - Removed some of the static-linking logic for now until a better organisation
    logic has been introduced.
  - Application components for `p-ufw` and `p-clamscan` can now access their
    instructions by using `?` as an argument. The commands `p-ufw ?` and
    `p-clamscan ?` are now the same as `p-ufw help` and `p-clamscan help`.
  - Another alias for `p-clamscan` has been added, now the user can type
    `p-clamav` and it (along with its arguments) will operate in exactly the
    same manner as `p-clamscan`.
  - The `README.md` file has been updated to include new command instructions.
  - Both `README.md` and `CHANGELOG.md` have been parsed with a Markdown linter
    to help better format documentation.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).

## 0.6.x Series: 'Kyrie'

The name **Kyrie** was taken from the video game **Project Zero/Fatal Frame**,
during the conclusion of the game, she became the game's ultimate heroine.

- **0.6.9 Released Tuesday, March 20th 2018**
  - Have removed custom prompt functionality to begin the process of improving
    the simplicity of the Patina source code.
  - The script declaration has been changed from `#!/bin/bash` to the more
    modern and correct `#!/usr/bin/env bash`.
  - Have updated the `README.md` file for the sake of standardisation.
- **0.6.8 Released Wednesday, January 24th 2018**
  - The folders `Templates` and `Public` in a standard home folder can now be
    accessed using the `templates` and `public` commands respectively. The
    `README.md` file has been updated to show this.
  - Configuration file `patina_configuration.conf` has been removed from the
    `patina` project directory and all configuration of Patina is now stored in
    the user's home directory as a hidden file named `.patinarc` to follow the
    convention of `.bashrc` or other `.rc` files.
- **0.6.7 Released Wednesday, November 15th 2017**
  - Have updated the `patina_system_xdg.sh` file so that the commands `p-url`
    and `p-url X` (where X is a valid URL) will open a URL in the default
    web browser.
  - The command `p-url patina` will now open the project's GitHub page, this has
    been changed from `p-url-patina`. The `README.md` file reflects this.
  - The presentation of messages and errors have been altered to remove colours
    and preserve terminal screen estate in the `patina_system_xdg.sh` file.
  - All components have been edited to reduce the amount of colour used and the
    amount of empty whitespace shown on message output.
- **0.6.6 Released Wednesday, November 15th 2017**
  - Have included a new component for basic management of the 'ufw' firewall
    named `patina_applications_ufw.sh`. Check `README.md` for updated
    instructions.
  - Began the process of simplifying text output for better readability. This
    means that most text prompts will be displayed on one line in the default
    colours of the terminal.
  - Patina application component help text has now been moved into plain text
    files for improved proof-reading and updating.
  - The `p-clamscan-help` command has been updated to match the rest of Patina
    and now the correct usage is `p-clamscan help`.
  - Added Solus' colours to the `patina_system_stylesheet.sh` file.
  - Have added a new Patina Solus theme which can be activated using the
    `p-theme solus` command. Best used with the `p-prompt solus` command.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).
- **0.6.5 Released Tuesday, November 14th 2017**
  - Some of Patina's logic has been moved to the relevant components to ensure
    that the source file `patina.sh` is easier to debug and maintain.
  - A new component named `patina_system_theming.sh` has been added.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).
- **0.6.4 Released Monday, November 13th 2017**
  - Shortened the BASH version number displayed in Patina's initial start-up.
  - Separated colours and formatting to `patina_system_stylesheet.sh` component.
  - Added a counter on the `p-list` command to show how many components are
    currently connected.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).
- **0.6.3 Released Friday, September 8th 2017**
  - Minor bug-fixes for `patina_system_package_manager.sh` component.
  - Included support for **Solus** package manager `eopkg` within `p-package`.
  - The `p-package` command now has a shorthand equivalent of `p-pkg`.
  - Added a `patina_metadata_codename` variable which will change by series.
  - Cleaned the repository from before this point because of commit errors.
- **0.6.2 Released Thursday, September 7th 2017**
  - Minor tweaks and bug-fixes.
  - Have removed the `hotdog` and `bigtop` themes, replacing them with Metroid-
    inspired themes `gravity` and `varia`.
  - Patina now detects incorrect or null settings and corrects accordingly -
    this is to be updated to prevent the use of nested IF statements.
- **0.6.1 Released Tuesday, July 25th 2017**
  - Created a new branch called 'test' for new changes to be written.
  - Added a new `p-prompt` command to change the default prompt to mimic other
    Linux distribution defaults.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).
- **0.6.0 Released Friday, July 21st 2017**
  - Created a new repository called *patina* for this version.
  - Cygwin support has been removed to ensure better integration for Linux and
    Microsoft Windows 10 using the Windows sub-system for Linux.
  - The entire project has been parsed, checked and corrected using
    [ShellCheck](https://www.shellcheck.net/).
