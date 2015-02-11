$(document).ready ->
  initYearPicker()

initYearPicker = ->
  $('.year').click ->
    $('#winners').empty()
    year = $(@).data('year')
    winners = $(@).data('winners')

    $.each winners, (i, winner) ->
      console.log winner.month
      console.log winner.winner
      $('#winners').append(
        '<img class="trophy" src="" alt="trophy"/>'+
        '<span class="month">'+winner.month+'</span>'+
        '<span clas="winner">'+winner.winner+'</span>'  
      )
