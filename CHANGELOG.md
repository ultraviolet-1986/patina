# Changelog

# Table of Contents

- [0.6.x Series: 'Kyrie'](#06x-series)

# 0.6.x Series: 'Kyrie'
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
