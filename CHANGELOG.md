# Changelog

# Table of Contents

- [0.6.x Series: 'Kyrie'](#06x-series)

# 0.6.x Series: 'Kyrie'
- **0.6.9 Released XXX, XX XXth 2018**
  - Have removed custom prompt functionality to begin the process of improving
    the simplicity of the Patina source code.
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
    and `p-url <X>` (where <X> is a valid URL) will open a URL in the default
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
  - The entire project has been corrected and checked using *ShellCheck* at:
    <https://www.shellcheck.net/>.
- **0.6.5 Released Tuesday, November 14th 2017**
  - Some of Patina's logic has been moved to the relevant components to ensure
    that the source file `patina.sh` is easier to debug and maintain.
  - A new component named `patina_system_theming.sh` has been added.
  - The entire project has been corrected and checked using *ShellCheck* at:
    <https://www.shellcheck.net/>.
- **0.6.4 Released Monday, November 13th 2017**
  - Shortened the BASH version number displayed in Patina's initial start-up.
  - Separated colours and formatting to `patina_system_stylesheet.sh` component.
  - Added a counter on the `p-list` command to show how many components are
    currently connected.
  - Tested system using <https://www.shellcheck.net/> and updated directives.
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
  - Minor bug-fixes and corrections using <https://www.shellcheck.net/>.
- **0.6.0 Released Friday, July 21st 2017**
  - Created a new repository called *patina* for this version.
  - Cygwin support has been removed to ensure better integration for Linux and
    Microsoft Windows 10 using the Windows sub-system for Linux.
  - The entire project has been corrected and checked using *ShellCheck* at:
    <https://www.shellcheck.net/>.
