# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready -> 
  $(document).on 'click', 'a[data-submit]', (event) -> 
    event.preventDefault()
    
    $($(this).data('continue')).val(1) if $(this).data('continue')
    $($(this).data('submit')).submit()
  $(document).on 'click', 'a[data-remove]', (event) ->
    event.preventDefault()
    $($(this).data('remove')).remove()

  $('.select2').select2()
  $(document).on 'show', '.sow .collapse', (event) ->
    icon = $(event.currentTarget).parent().find('.ellipsis i')
    icon.removeClass('icon-chevron-down')
    icon.addClass('icon-chevron-up')
    # icon.fadeOut()
  $(document).on 'hide', '.sow .collapse', (event) ->
    icon = $(event.currentTarget).parent().find('.ellipsis i')
    icon.removeClass('icon-chevron-up')
    icon.addClass('icon-chevron-down')    
    # icon.fadeIn()
