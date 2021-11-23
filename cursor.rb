class Cursor
  def initialize(cursor_pos, board)
    @board = board
    @cursor_pos = cursor_pos
    @selected = false
  end

  def get_input
  end

  def toggle_selected
    @selected = !@selected
  end

  private
  def handle_key(key)
  end

  def read_char
  end

  def update_pos(diff)
  end
end