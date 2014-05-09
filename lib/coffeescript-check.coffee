coffee = require( "coffee-script" ).compile

oCompilerOptions =
    bare: yes

coffeeCheck = ( oEditor ) ->
    unless oEditor.getCursorScopes().indexOf( "source.litcoffee" ) isnt -1 or oEditor.getCursorScopes().indexOf( "source.coffee" ) isnt -1
        return atom.confirm
            message: "CoffeeScript Check - Oops !"
            detailedMessage: "The selected text is not Coffeescript or Literate CoffeeScript !"
    unless ( sSelection = oEditor.getSelectedText() )
        oEditor.selectLine()
        oEditor.getSelectedText()
    try
        sCompiledSelection = coffee sSelection, oCompilerOptions
        throw new Error "The selected text compiles to an empty string !" unless sCompiledSelection.trim()
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
