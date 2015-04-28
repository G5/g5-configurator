$ = jQuery

showSelect = (selector) ->
  $(selector).show()
  $(selector + " select").removeAttr("disabled")

hideSelect = (selector) ->
  $(selector).hide()
  $(selector + " select").attr("disabled", "disabled")

$ ->
  # at this point, the target app select widget has options for every app
  targetAppOptions = $(".js-target_apps select").children()

  # returns a subset of target apps above based on target app kind
  optionsFor = (targetAppKind) ->
    targetAppOptions.filter('optgroup[label$="' + targetAppKind + '"]')

  # selecting a different target app kind will modify the form
  $(".js-target_app_kind").change ->
    # hide specific form widgets
    hideSelect(".js-target_apps");
    hideSelect(".js-remote_app");
    hideSelect(".js-updated_app_kinds");

    # find selected target app kind
    targetAppKind = $(".js-target_app_kind option:selected").attr("value")

    # only show target apps which match target app kind
    $(".js-target_apps select").empty()
    $(".js-target_apps select").append optionsFor(targetAppKind)

    # show form widgets specific to this target app
    showSelect(".js-target_apps") unless targetAppKind == ""
    showSelect(".js-remote_app") if targetAppKind == "client-app-creator"
    showSelect(".js-updated_app_kinds") if targetAppKind == "client-app-updater"

  # manually trigger initial form setup
  $(".js-target_app_kind").change()
