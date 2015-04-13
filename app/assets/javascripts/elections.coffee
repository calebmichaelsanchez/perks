$(document).ready ->
  $('#election-form').on 'ajax:success', (event, response) ->
    $('#election-results .votes').empty()
    console.log response
    console.log 'success!'

    votes = $.parseJSON(response.votes)
    $.each votes, (i, vote) ->
      voter_name     = vote.voter.full_name
      selection_name = vote.selection.full_name
      $('#election-results .votes').
        append('<ul><li>'+voter_name+'</li><li>'+selection_name+'</li><li>'+vote.comment+'</li></ul>')

    # $('#election-form').on 'ajax:error', (event, response) ->
    #     console.log response
    #     console.log 'error!'
