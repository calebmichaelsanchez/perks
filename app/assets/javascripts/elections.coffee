$(document).ready ->
  $('#election-form').on 'ajax:success', (event, response) ->
    console.log response
    console.log 'success!'

    # iterate through response.votes, populate various elements etc
    $('#election-results').append("stuff goes here.")
