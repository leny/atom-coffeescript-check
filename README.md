# Atom : CoffeeScript Check

> Compile a CoffeeScript selection to check its JavaScript output.

* * *

**NOTE:** this package is not actively maintained anymore. You can find a new, up-to-date module at [jhessin/atom-coffee-check](https://github.com/jhessin/atom-coffee-check).

* * *

## Usage

Select a text, then use the command `CoffeeScript Check: Check`: if the selection (or the whole file if there's no selection) is *CoffeeScript* or *Literate CoffeeScript*, the plugin compiles it and shows the result in a notification.

The notification provides a "*Copy to clipboard*" button to copy the compiled result.

## Keybindings

With the success of Atom, it's really difficult to choose keybindings that will not enter in conflict whit anyone else's packages, so I have removed the default keystrokes and let the keymap empty to let you set your own keybindings.
