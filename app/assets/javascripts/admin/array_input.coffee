$ ->
  removeFromArrayInput = (el) ->
    input = $(el).siblings('input')
    if input.attr('disabled') == 'disabled'
      $(el)
        .html('<i class="fa fa-times-circle"></i>')
        .removeClass('can-undo')
      $(input).removeAttr('disabled')
      $(input).removeClass('text--strike')
    else
      $(el)
        .html('<i class="fa fa-undo"></i>')
        .addClass('can-undo')
      $(input).attr('disabled', 'disabled')
      $(input).addClass('text--strike')

  $('.js-add-to-array-input').click (e) ->
    e.preventDefault

    if $(@).hasClass('array-action--add')
      original = $(@).parent()
      clone    = $(original).clone(true)
      clone_id = "clone_#{Math.floor((Math.random() * 100000) + 1)}"
      input    = $(clone).find('input')

      if $(input).val() != ''
      # Remove error classes from original's input
        $(original)
          .find('input')
          .removeClass('has-error')

        # Reset clone's input
        $(input)
          .removeClass('has-error')
          .attr('id', clone_id)
          .val('')

        # Change action to remove
        $(@)
          .html('<i class="fa fa-times-circle"></i>')
          .attr('class', 'array-action--remove js-remove-from-array-input')

        # Add clone and focus its input
        $(@).parent().parent().append $(clone)
        $("##{clone_id}").focus()

      else
        $(original)
          .find('input')
          .addClass('has-error')
          .focus()

    else
      removeFromArrayInput $(@)

  $('.js-remove-from-array-input').click (e) ->
    e.preventDefault
    removeFromArrayInput $(@)