###* @babel ###


import { compile as coffee } from 'coffeescript'
import { CompositeDisposable } from 'atom'

export default coffeeCheck =
  compilerOptions:
    bare: true

  scopeIsCoffee: (scopes) ->
    checkScope = (scope)->
      scope is 'source.litcoffee' or
      scope is 'source.coffee'
    scopes.findIndex(checkScope) > -1

  showResult: (content)->
    atom.notifications.addSuccess('Coffee Check: Result', {
      buttons: [{
          text: 'Copy to clipboard'
          onDidClick: ->
            atom.clipboard.write content
      }]
      detail: content
      dismissable: true
    })

  showError: (error)->
    atom.notifications.addError("Coffee Check: Oops!", {
      detail: error.code
      description: "<big>#{error.name}:#{error.message}</big>"
      dismissable: true
    })

  activate: ->
    @disposables = new CompositeDisposable()

    command = atom.commands.add 'atom-text-editor:not([mini])',
      'coffee-check:check'
      =>
        sectionsToCompile = []

        editor = atom.workspace.getActiveTextEditor()
        if not editor? then return

        # parse selections
        for selection in editor.getSelections()
          scopes = editor.scopeDescriptorForBufferPosition(
            selection.getBufferRange()).getScopesArray()
          selectionText = selection?.getText()
          if selectionText and @scopeIsCoffee(scopes)
            sectionsToCompile.push selectionText

        # if no selection, check scope for the whole file, then select all.
        scopes = editor.getRootScopeDescriptor().getScopesArray()
        if sectionsToCompile.length is 0 and
          @scopeIsCoffee(scopes)
            sectionsToCompile.push editor.getText()

        # if still no selection, throw a warning
        if sectionsToCompile.length is 0
          return atom.notifications.addWarning('No source!', {
            detail:
              'The given source(s) are empty and/or not coffeescript!'
            dismissable: true
          })

        # compile the coffee
        for section in sectionsToCompile
          try
            compiledSection = coffee section,
              @compilerOptions
            if !compiledSection.trim()
              throw new Error 'The selected text compiles to an empty string!'
            else
              @showResult compiledSection
          catch error
            @showError error

    @disposables.add command

  deactivate: ->
    @disposables?.dispose()
