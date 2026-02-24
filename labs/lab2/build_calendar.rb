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

def get_game_times(start_date, end_date)
  res = []
  game_days = get_game_days(start_date, end_date)
  game_days.each do |x|
    res.append Time.new(x.year, x.month, x.day, 12)
    res.append Time.new(x.year, x.month, x.day, 15)
    res.append Time.new(x.year, x.month, x.day, 18)
  end
  res
end

def build_command_pairs(filename)
  commands = get_command_info filename
  res = []
  (0..commands.count-1).each do |x|
    (x+1..commands.count-1).each do |y|
      command_pair = {}
      command_pair['first_command'] = commands[x]
      command_pair['second_command'] = commands[y]
      res.append command_pair
    end
  end
  res
end

def build_game_pairs(filename)
  res = []
  # command_pairs = reorder_command_pairs(filename)
  command_pairs = build_command_pairs filename
  command_pairs.each do |x|
    game_info = {}
    game_info['first_command'] = x['first_command']['name']
    game_info['second_command'] = x['second_command']['name']
    game_info['game_town'] = x['first_command']['hometown']
    res.append game_info
    game2_info = {}
    game2_info['first_command'] = x['second_command']['name']
    game2_info['second_command'] = x['first_command']['name']
    game2_info['game_town'] = x['second_command']['hometown']
    res.append game2_info
  end
  res
end

def get_command_info(filename)
  res = []
  file = File.open(filename)
  file.each_line do |line|
    match = (/\. (?<command>[ёа-яА-Я \-]+) — (?<hometown>[ёа-яА-Я \-]+)$/.match(line))
    command_info = {}
    command_info['name'] = match[:command]
    command_info['hometown'] = match[:hometown]
    res.append command_info
  end
  res
end

def reorder_command_pairs(filename)
  res = []
  game_pairs = build_command_pairs(filename)
  (0..game_pairs.count/2).each do |i|
    res.append game_pairs[i]
  end
  res
end

def build_calendar(start_date, end_date, filename)
  game_times = get_game_times(start_date, end_date)
  game_pairs = build_game_pairs(filename)
  return "Не хватит времени" if game_times.count < game_pairs.count
  res = []
  (0..game_pairs.count-1).each do |i|
    game = {}
    game['first_command'] = game_pairs[i]['first_command']
    game['second_command'] = game_pairs[i]['second_command']
    game['game_town'] = game_pairs[i]['game_town']
    game['date_time'] = game_times[i]
    res.append game
  end
  res
end

def print_result(start_date, end_date, commands_filename)
  puts build_calendar start_date, end_date, commands_filename
end

print_result('24.02.2026', '27.10.2027', 'teams.txt')
