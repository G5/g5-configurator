$ = jQuery
$ ->
  # initially, hide and disable target apps and remote app
  $(".js-target_apps").hide()
  $(".js-target_apps").attr("disabled", "disabled")
  $(".js-remote_app").hide()
  $(".js-remote_app").attr("disabled", "disabled")
  # can i define these out here?
  $targetAppsSelect = $(".js-target_apps select")
  $targetAppsOptgroups = $targetAppsSelect.children()
  # when target app type changes
  $(".js-target_app_kind").change ->
    # find selected target app kind
    targetAppKind = $(".js-target_app_kind option:selected").attr("value")
    if targetAppKind == ""
      # initially, hide target apps and remote app
      $(".js-target_apps").hide()
      $(".js-target_apps select").attr("disabled", "disabled")
      $(".js-remote_app").hide()
      $(".js-remote_app select").attr("disabled", "disabled")
    else
      # filter target app options
      $targetAppsSelect.empty()
      blank = $targetAppsOptgroups.filter('option[value=""]')
      matching_optgroup_options = $targetAppsOptgroups.filter('optgroup[label$="' + targetAppKind + '"]')
      $targetAppsSelect.append(blank).append(matching_optgroup_options).find('option').clone()
      # display target apps
      $(".js-target_apps").show()
      $(".js-target_apps select").removeAttr("disabled")
      # if g5-client-app-creator then show remote app else hide
      if targetAppKind == "g5-client-app-creator"
        $(".js-remote_app").show()
        $(".js-remote_app select").removeAttr("disabled")
      else
        $(".js-remote_app").hide()
        $(".js-remote_app select").attr("disabled", "disabled")
