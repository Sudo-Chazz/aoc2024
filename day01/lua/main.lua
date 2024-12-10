local function main()
  local left_t = {}
  local right_t = {}
  for line in io.lines("../input.txt") do
    table.insert(left_t, string.match(line, "^%d+"))
    table.insert(right_t, string.match(line, "%d+$"))
  end

  table.sort(left_t)
  table.sort(right_t)

  local sum = 0
  for i = 1, #left_t do
    sum = sum + math.abs(left_t[i] - right_t[i])
  end

  print(sum)
end

main()
