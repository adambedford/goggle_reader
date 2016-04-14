class @BookmarkedArticles
  constructor: ->
    $(".bookmark-toggle-link").on "click", (event) => @toggleBookmark(event)

  toggleBookmark: (event) ->
    event.preventDefault
    $link = $(event.currentTarget)
    $container = $link.parents(".card")
    $url = $link.attr("href")
    $icon = $link.find("i")

    console.log($url)

    $.ajax "#{$url}.js",
      type: $link.data("method"),
      dataType: "text",
      success: (data) ->
        $container.html($(data).contents())
      error: (data) ->
        debugger;
        Materialize.toast(data)

    return false

$ ->
  window.currentPage = new BookmarkedArticles