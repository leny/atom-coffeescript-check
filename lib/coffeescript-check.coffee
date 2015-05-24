coffee = require( "coffee-script" ).compile

oCompilerOptions =
    bare: yes

coffeeCheck = ( oEditor ) ->
    oCursorBufferPosition = oEditor.getCursorBufferPosition()
    oScopesForBufferDescription = ( oEditor.scopeDescriptorForBufferPosition oCursorBufferPosition ).scopes

    unless oScopesForBufferDescription.indexOf( "source.litcoffee" ) isnt -1 or oScopesForBufferDescription.indexOf( "source.coffee" ) isnt -1
        return atom.confirm
            message: "CoffeeScript Check - Oops !"
            detailedMessage: "The selected text is not Coffeescript or Literate CoffeeScript !"

    unless ( sSelection = oEditor.getSelectedText() )
        oEditor.selectLine()
        oEditor.getSelectedText()

    try
        sCompiledSelection = coffee sSelection, oCompilerOptions
        throw new error "the selected text compiles to an empty string !" unless sCompiledSelection.trim()
    catch oError
        return atom.confirm
            message: "coffeescript check - oops !"
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
        atom.commands.add "atom-text-editor", "coffeescript-check:check", ->
            coffeeCheck atom.workspace.getActiveTextEditor()
