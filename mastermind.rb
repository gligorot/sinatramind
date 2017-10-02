#modified for sinatra/heroku deployment

def rand_code
  code = []
  4.times {code<<rand(1..6)}
  code.join("").to_i
end

def move_to_array(move)
  move.to_s.split("")
end

def move_result(move)
  code_array = move_to_array(session[:secret_code]).map(&:to_i)
  move_array = move_to_array(move).map(&:to_i)

  right, wrong = 0, 0

  move_array.each_with_index do |cell, index|
    if cell == code_array[index]
      right+=1
      move_array[index] = nil
      code_array[index] = nil
    end
  end

  move_array.each do |cell|
    if cell != nil && code_array.index(cell)
      wrong+=1
      code_array[code_array.index(cell)] = nil
    end
  end

  [right, wrong]
end

def check_win(result)
  redirect to('/win') if result[0] == 4
end
