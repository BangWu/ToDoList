class DashboardController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def show
    @todones = Todo.where(status: true)
    @todos = Todo.where(status: false)
  end

  def add
    todo = Todo.new(add_todo_params.merge({status: false}))
    todo.save
    partial_item = render_to_string(partial: 'dashboard/item', locals: {todo: todo})

    render json: {status: 'OK', item: partial_item}
  end

  def update
    todo = Todo.find(todo_id['id'])
    todo.update(to_do_params)
    todo.save
    partial_item = render_to_string(partial: 'dashboard/item', locals: {todo: todo})
    render json: {status: 'OK', item: partial_item}
  end

  def delete
    todo = Todo.find(todo_id['id'])
    todo.delete
    render json:{status: 'OK'}
  end


  private
  def add_todo_params
    params.require(:todo).permit(:title, :text)
  end

  def todo_id
    params.require(:todo).permit(:id)
  end

  def to_do_params
    params.require(:todo).permit(:status, :title, :text)
  end
end
