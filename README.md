# Atom : Coffee Check

> Compile a CoffeeScript selection to check its JavaScript output.

This is a fork of Leny's great work [CoffeeScript Check](https://atom.io/packages/coffeescript-check). His work is quite outdated though. This project uses the latest version of CoffeeScript 2 whereas his uses v1.9

# NOTICE: No longer maintained. I'm sorry but I don't really have time to work on it anymore. Feel free to use/create a fork if you are interested.

---

**NOTE:** this package is not actively maintained anymore. You can find a new, up-to-date module at [jhessin/atom-coffee-check](https://github.com/jhessin/atom-coffee-check).

* * *

## Usage

Select a text, then use the command `Coffee Check: Check`: if the selection (or the whole file if there's no selection) is _CoffeeScript_ or _Literate CoffeeScript_, the plugin compiles it and shows the result in a notification.

The notification provides a "_Copy to clipboard_" button to copy the compiled result.

## Keybindings

With the success of Atom, it's really difficult to choose keybindings that will not enter in conflict with anyone else's packages, so I have set the default keystrokes to 'unset' so you can still copy and paste into your own keybindings.
