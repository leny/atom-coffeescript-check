coffee = require( "coffee-script" ).compile

oCompilerOptions =
    bare: yes

coffeeCheck = ( oEditor ) ->
    return unless oEditor.getCursorScopes().indexOf( "source.litcoffee" ) isnt -1 or oEditor.getCursorScopes().indexOf( "source.coffee" ) isnt -1
    return unless ( sSelection = oEditor.getSelectedText() )
    try
        sCompiledSelection = coffee sSelection, oCompilerOptions
    catch oError
        return atom.confirm
            message: "CoffeeScript Check - Oops !"
            detailedMessage: oError.message
    atom.confirm
        message: "CoffeeScript Check - Result"
        detailedMessage: sCompiledSelection
        buttons:
            "Ok": no
            "Copy to clipboard": ->
                atom.clipboard.write sCompiledSelection

module.exports =
    activate: ->
        atom.workspaceView.command "coffeescript-check:check", ".editor", ->
            coffeeCheck atom.workspaceView.getActivePaneItem()
