class TodoDecorator < Draper::Decorator
  delegate_all
  decorates :todo

  def option
    {id: self.id, title: self.title, text: self.text, status: self.status}
  end
end