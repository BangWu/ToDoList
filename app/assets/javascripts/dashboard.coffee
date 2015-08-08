$(document).ready ->
  @button=""
  updateTodoStatus = (ele) ->
    @item = ele.closest('.item')
    @status = $(ele).is(':checked')
    $.post("/dashboard/update"
      todo: {id: @item.getAttribute("data"),status: @status}
      (data)=>
        if data.status =="OK"
          if $(ele).is(':checked')
            $('#to-done-list')[0].appendChild(@item)
            $('#to-do-list')[0].removeChild(@item)
          else
            $('#to-do-list')[0].appendChild(@item)
            $('#to-done-list')[0].removeChild(@item)
    )

  $('.todo-status').change ->
    updateTodoStatus(this);

  $('#add-todo').click ->
    @toDoTitle = $("#todo-title")
    @toDoText = $("#todo-text")
    $.post("/dashboard/add"
      todo: {title: @toDoTitle.val(),text: @toDoText.val()}
      (data)=>
        if data.status == "OK"
          item = $.parseHTML(data.item)[0]
          $(item).find(".todo-status").change ->
            updateTodoStatus(this)
          $('#to-do-list')[0].appendChild(item)
        @toDoTitle.val("")
        @toDoText.val("")
    )

  $('#edit-todo').on 'show.bs.modal', (event) =>
    button = $(event.relatedTarget)
    @button = event.relatedTarget
    modal = $(this)
    modal.find('#edit-id').val button.data('id')
    modal.find('#edit-title').val button.data('title')
    modal.find('#edit-text').val button.data('text')

  $('#edit-todo-save').click (event) =>
    modal = $('#edit-todo')
    @toDoId = modal.find("#edit-id")
    @toDoTitle = modal.find("#edit-title")
    @toDoText = modal.find("#edit-text")
    $.post("/dashboard/update"
      todo: {id: @toDoId.val(), title: @toDoTitle.val(),text: @toDoText.val()}
      (data)=>
        if data.status == "OK"
          item = $.parseHTML(data.item)[0]
          $(item).find(".todo-status").change ->
            updateTodoStatus(this)
          debugger
          $(@button.closest(".item")).replaceWith(item)
    )

  $('#delete-todo').on 'show.bs.modal', (event) =>
    @button = event.relatedTarget

  $('#delete-todo-save').click (event) =>
    $.post("/dashboard/delete"
      todo: {id: $(@button).data('id')}
      (data)=>
        if data.status == "OK"
          $(@button.closest(".item")).replaceWith("")
    )

