coffeeCheck = ( editor ) ->
    console.log "coffeeCheck"
    # TODO check if current file is CoffeeScript
    # TODO check if had selection
    # TODO get selection
    # TODO compile selection
    # TODO show the result in a pane, or console, modal, dialog, I FUCKIN' DON'T KNOW YET

module.exports =
    activate: ->
        atom.workspaceView.command "coffeescript-check:check", ".editor", ->
            currentPane = atom.workspaceView.getActivePaneItem()
            coffeeCheck currentPane
