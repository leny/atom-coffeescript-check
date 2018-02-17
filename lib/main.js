"use babel";

import { compile as coffee } from "coffeescript";
import { CompositeDisposable } from "atom";

let oCompilerOptions = {
        bare: true
    },
    oDisposables,
    fActivate,
    fDeactivate,
    fScopeIsCoffee,
    fShowResult,
    fShowError;

fScopeIsCoffee = function(aScopes) {
    let fCheckScope = (sScope) => {
        return sScope === "source.litcoffee" || sScope === "source.coffee";
    };

    return aScopes.findIndex(fCheckScope) > -1;
};

fShowResult = function(sContent) {
    atom.notifications.addSuccess("CoffeeScript Check: Result", {
        buttons: [
            {
                text: "Copy to clipboard",
                onDidClick: () => {
                    atom.clipboard.write(sContent);
                }
            }
        ],
        detail: sContent,
        dismissable: true
    });
};

fShowError = function(oError) {
    atom.notifications.addError("CoffeeScript Check: Oops!", {
        detail: oError.code,
        description: `<big>${oError.name}: ${oError.message}</big>`,
        dismissable: true
    });
};

fActivate = function() {
    let oCommand;

    oDisposables && oDisposables.dispose();
    oDisposables = new CompositeDisposable();

    oCommand = atom.commands.add(
        "atom-text-editor:not([mini])",
        "coffeescript-check:check",
        () => {
            let oEditor,
                aSectionsToCompile = [];

            if (!(oEditor = atom.workspace.getActiveTextEditor())) {
                return;
            }

            // parse selections
            if (oEditor.getSelections().length) {
                for (oSelection of oEditor.getSelections()) {
                    let sSelectionText;

                    if (
                        (sSelectionText = oSelection.getText()) &&
                        fScopeIsCoffee(
                            oEditor
                                .scopeDescriptorForBufferPosition(
                                    oSelection.getBufferRange()
                                )
                                .getScopesArray()
                        )
                    ) {
                        aSectionsToCompile.push(sSelectionText);
                    }
                }
            }

            // if no selection, check scope for the whole file, then select all.
            if (
                aSectionsToCompile.length === 0 &&
                fScopeIsCoffee(
                    oEditor.getRootScopeDescriptor().getScopesArray()
                )
            ) {
                aSectionsToCompile.push(oEditor.getText());
            }

            // if still no selection, throw a warning
            if (!aSectionsToCompile.length) {
                return atom.notifications.addWarning("No source!", {
                    detail:
                        "The given source(s) are empty and/or not coffeescript!",
                    dismissable: true
                });
            }

            // compile with coffee
            for (sSectionToCompile of aSectionsToCompile) {
                let sCompiledSection;

                try {
                    sCompiledSection = coffee(
                        sSectionToCompile,
                        oCompilerOptions
                    );
                    if (!sCompiledSection.trim()) {
                        throw new Error(
                            "The selected text compiles to an empty string!"
                        );
                    } else {
                        fShowResult(sCompiledSection);
                    }
                } catch (oError) {
                    fShowError(oError);
                }
            }
        }
    );
    oDisposables.add(oCommand);
};

fDeactivate = function() {
    oDisposables && oDisposables.dispose();
};

export { fActivate as activate, fDeactivate as deactivate };
