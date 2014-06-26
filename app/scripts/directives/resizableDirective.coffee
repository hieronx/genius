app = angular.module("geniusApp")

app.directive "resizable", ->
  restrict: "A"

  scope:
    callback: "&onResize"

  link: (scope, elem, attrs) ->
    mainWidth = $("#main").width()
    mainRight = elem
    mainLeft = elem.prev()

    $(window).resize =>
      dist = $("#main").width() - mainWidth
      mainWidth = $("#main").width()

      mainLeftWidth = mainLeft.width() + dist
      mainRightWidth = mainRight.width()
      if mainLeftWidth < 79
        mainLeftWidth = 79
        mainRightWidth = mainWidth - 79
      else
        if mainWidth > 331
          mainRightWidth = Math.max(mainRightWidth, 252)
          mainLeftWidth = mainWidth - mainRightWidth
        else
          mainRightWidth = mainWidth - 79
          mainLeftWidth = 79

      mainLeft.width mainLeftWidth
      mainRight.width mainRightWidth

      mainRight.resizable "option",
        maxWidth: mainWidth - 79

    mainRight.resizable
      handles: "w"
      minWidth: 252
      maxWidth: mainWidth - 79
      resize: (e, ui) =>
        mainLeft.width mainWidth - ui.size.width

    mainRight.on "resizestop", (evt, ui) ->
      scope.callback?()
