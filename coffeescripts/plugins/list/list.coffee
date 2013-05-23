define ["jquery.custom", "core/browser", "core/helpers"], ($, Browser, Helpers) ->
  list =
    insert: (e) -> e.api.clean() if e.api["insert#{Helpers.capitalize(e.type)}"]()
    dent: (e) -> e.api.clean() if e.api[e.type]()
    handleTab: (e) ->
      keys = Helpers.keysOf(e)
      if (keys == "tab" or keys == "shift+tab")
        [startItem, endItem] = e.api.getParentElements("li")
        if startItem and endItem
          e.preventDefault()
          e.api.trigger(if keys == "tab" then "indent" else "outdent")
  SnapEditor.actions.orderedList = list.insert
  SnapEditor.actions.unorderedList = list.insert
  SnapEditor.actions.indent = list.dent
  SnapEditor.actions.outdent = list.dent

  includeBehaviours = (e) -> e.api.config.behaviours.push("list")
  $.extend(SnapEditor.buttons,
    orderedList: Helpers.createButton("orderedList", "ctrl+shift+8", onInclude: includeBehaviours)
    unorderedList: Helpers.createButton("unorderedList", "ctrl+shift+7", onInclude: includeBehaviours)
    indent: Helpers.createButton("indent", "", onInclude: includeBehaviours)
    outdent: Helpers.createButton("outdent", "", onInclude: includeBehaviours)
  )

  SnapEditor.behaviours.list =
    onActivate: (e) -> $(e.api.el).on("keydown", list.handleTab)
    onDeactivate: (e) -> $(e.api.el).off("keydown", list.handleTab)

  styles = ""
  for button, i in ["orderedList", "unorderedList", "indent", "outdent"]
    styles += Helpers.createStyles(button, (17 + i) * -26) # sprite position * step
  SnapEditor.insertStyles("plugins_list", styles)
