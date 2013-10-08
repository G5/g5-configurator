$ = jQuery
$ ->
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
      # if client-app-creator then show remote app else hide
      if targetAppKind == "client-app-creator"
        $(".js-remote_app").show()
        $(".js-remote_app select").removeAttr("disabled")
      else
        $(".js-remote_app").hide()
        $(".js-remote_app select").attr("disabled", "disabled")
  # trigger appropriated hide/shows on page load
  $(".js-target_app_kind").change()
