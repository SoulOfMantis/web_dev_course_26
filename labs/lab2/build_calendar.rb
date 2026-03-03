# Написать скрипт для составления спортивного календаря.
# На вход подается список команд с городами, в которых они находятся.
#
#   Игры проводятся по пятницам, субботам и воскресеньям, начало игр в 12:00, 15:00, 18:00.
#   Одновременно нельзя проводить более 2 игр.
#   Игры надо расположить как можно более равномерно в указанном пользователем диапазоне.
#     Все входные данные нужно валидировать
# Календарь выводится в текстом формате в указанный пользователем файл.
#   Запуск осуществляется так:
# ruby build_calendar.rb teams.txt 01.08.2026 01.06.2027 calendar.txt
# Указан
# Форматирование календаря на ваше усмотрение, но даты должны выглядеть хорошо.
# Команда не должна играть дважды в один день, в одном городе не может быть 2 игры одновременно
require 'Date'

def get_game_days(start_date, end_date)
  st = Date.strptime(start_date, "%d.%m.%Y")
  en = Date.strptime(end_date, "%d.%m.%Y")
  i = st
  res = []
  while i <= en
    res.append i if i.friday?||i.saturday?||i.sunday?
    i += 1
  end
  res
end

def get_possible_game_times(start_date, end_date)
  res = []
  game_days = get_game_days(start_date, end_date)
  game_days.each do |x|
    res.append Time.new(x.year, x.month, x.day, 12)
    res.append Time.new(x.year, x.month, x.day, 15)
    res.append Time.new(x.year, x.month, x.day, 18)
  end
  res
end

def get_game_times(possible_game_times, game_count, l = 0, r = possible_game_times.size-1)
  throw "" if 2*possible_game_times.count < game_count
  if possible_game_times.count < game_count
    return get_game_times(possible_game_times, game_count-possible_game_times.count)
  end
  return [possible_game_times[l+r/2]] if game_count == 1
  return [possible_game_times[l], possible_game_times[r]] if game_count == 2
  l = [l+1, (possible_game_times.count/(game_count-1))-1].max
  r = [r-1, possible_game_times.count-possible_game_times.count/(game_count-1)].max
  [].concat(get_game_times(possible_game_times, game_count-2, l, r), [possible_game_times[l], possible_game_times[r]]).sort
end

def build_command_pairs(filename)
  commands = get_command_info filename
  res = []
  (0..commands.count-1).each do |x|
    (x+1..commands.count-1).each do |y|
      command_pair = {}
      command_pair[:first_command] = commands[x]
      command_pair[:second_command] = commands[y]
      res.append command_pair
    end
  end
  res.sort
end

def build_game_pairs(filename)
  res = []
  command_pairs = build_command_pairs filename
  # (0..command_pairs.count-1).each do |i|
  #
  # end
  command_pairs.each do |x|
    game_info = {}
    game_info[:first_command] = x[:first_command][:name]
    game_info[:second_command] = x[:second_command][:name]
    game_info[:game_town] = x[:first_command][:hometown]
    res.append game_info
    game2_info = {}
    game2_info[:first_command] = x[:second_command][:name]
    game2_info[:second_command] = x[:first_command][:name]
    game2_info[:game_town] = x[:second_command][:hometown]
    res.append game2_info
  end
  res.sort_by {|x| x[:game_town]}
end

def reorder_command_pairs(filename)
  res = []
  game_pairs = build_command_pairs(filename)
  (0..game_pairs.count/2).each do |i|
    res.append game_pairs[i]
  end
  res
end

def get_command_info(filename)
  res = []
  file = File.open(filename)
  file.each_line do |line|
    match = (/\. (?<command>[ёа-яА-Я \-]+) — (?<hometown>[ёа-яА-Я \-]+)$/.match(line))
    command_info = {}
    command_info[:name] = match[:command]
    command_info[:hometown] = match[:hometown]
    res.append command_info
  end
  res
end

def check_command_overlap(teams1, teams2)
  teams1[:first_command] == teams2[:first_command] || teams1[:first_command] == teams2[:second_command] || teams1[:second_command] == teams2[:first_command] || teams1[:second_command] == teams2[:second_command]
end

def build_calendar(start_date, end_date, filename)
  game_pairs = build_game_pairs(filename)
  possible_times = get_possible_game_times(start_date, end_date)
  game_count = game_pairs.count
  game_times = get_game_times(possible_times, game_count)
  return "Не хватит времени!" if game_times.is_a? String
  # game_times = possible_times
  # return "Не хватит времени" if 2*game_times.size < game_pairs.count
  res = []
  t = 0
  fl = false
  until game_pairs.empty? do
    puts t
    (0..game_pairs.count-1).each do |i|
      if res.find(proc{false}) {|x| x[:game_time].day == game_times[t].day && check_command_overlap(x, game_pairs[i])}
        puts "Skipped #{game_pairs[i]} because team is tired"
        next
      end
      if res.count{|x| x[:game_town] == game_pairs[i][:game_town] && x[:game_time] == game_times[i]} > 0
        puts "Skipped #{game_pairs[i]} because only one stadium"
        next
      end
      game = {}
      game[:first_command] = game_pairs[i][:first_command]
      game[:second_command] = game_pairs[i][:second_command]
      game[:game_town] = game_pairs[i][:game_town]
      game[:game_time] = game_times[t]
      res.append game
      t += 1
      # puts game
    end
    game_times.delete_if {|x|}
    skipped = game_pairs.delete_if { |x| res.find {|y| x[:first_command] == y[:first_command] && x[:second_command] == y[:second_command]}}
    puts "#{skipped.count}/#{skipped.count+res.count}"
    if skipped == game_pairs
      return res if fl
      t = (t + 1) % game_times.size
      fl = true
    else
      fl = false
      end
    game_pairs = skipped
  end

  res.sort_by{|x| x[:game_time]}
end

def print_result(start_date, end_date, commands_filename)
  calendar = build_calendar(start_date, end_date, commands_filename)
  if calendar.is_a? String
    puts calendar
    return
  end
  calendar.each do |x|
    puts "#{x[:game_time].strftime "%d %B %Y, %H:%M"}, в городе #{x[:game_town]}, #{x[:first_command]} : #{x[:second_command]}"
  end
end

print_result('01.08.2026', '01.9.2026', '5teams.txt')
