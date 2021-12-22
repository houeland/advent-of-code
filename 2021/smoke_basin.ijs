ExampleMatrix =: (<'2 1 9 9 9 4 3 2 1 0'), (<'3 9 8 7 8 9 4 9 2 1'), (<'9 8 5 6 7 8 9 8 9 2'), (<'8 7 6 7 8 9 6 7 8 9'), (<'9 8 9 9 9 6 5 6 7 8')
ExampleHeight =: 5
ExampleWidth =: 10

FullMatrix =: (<'5 4 5 6 7 8 9 3 4 9 8 8 6 4 5 6 8 9 0 1 2 3 9 8 5 4 3 5 5 7 8 9 9 6 5 4 3 2 1 3 4 5 6 7 8 9 6 5 6 8 9 9 9 9 6 4 6 7 7 8 9 2 3 4 9 8 9 7 6 5 4 4 2 3 4 5 7 8 9 7 7 8 9 9 9 9 8 9 6 5 2 3 4 9 8 7 9 8 9 9'), (<'4 3 4 9 8 9 1 2 9 8 7 6 5 3 4 8 7 8 9 3 3 9 8 7 5 3 2 3 4 5 6 7 8 9 6 6 5 4 3 4 5 6 8 9 9 6 5 4 5 6 9 8 8 7 4 3 5 6 6 7 9 9 5 9 8 7 9 8 9 8 3 2 1 4 5 7 8 9 3 5 6 9 9 9 8 8 7 9 9 3 1 9 9 8 7 6 5 6 6 8'), (<'1 2 9 8 9 1 0 9 8 9 8 7 3 2 3 4 5 9 5 4 9 8 7 6 4 3 1 2 3 4 5 6 7 8 9 7 6 7 4 6 8 9 9 9 8 9 6 5 6 9 8 7 5 6 3 2 3 4 5 6 7 8 9 9 7 6 7 9 8 7 4 4 2 5 7 8 9 5 4 6 7 8 9 8 7 9 6 8 8 9 9 8 9 7 6 5 4 4 5 7'), (<'2 9 8 7 9 3 9 8 7 5 4 3 2 1 2 3 4 8 9 9 9 9 9 5 3 2 0 1 2 3 4 5 9 9 6 9 8 6 5 7 9 7 9 9 7 9 9 9 7 9 6 5 4 3 2 0 2 3 4 7 9 9 9 8 9 5 9 8 7 6 5 5 3 6 8 9 9 6 5 7 8 9 8 7 6 8 5 6 7 8 9 7 8 9 5 4 3 3 4 5'), (<'9 8 9 6 8 9 9 9 8 4 3 2 1 0 1 2 6 6 8 8 9 9 8 6 5 3 1 3 5 4 6 7 8 9 5 6 9 7 9 8 9 6 5 4 6 9 8 7 9 8 7 6 5 5 3 1 3 5 5 6 8 9 8 7 6 4 3 9 8 8 7 6 7 9 9 7 8 9 6 8 9 8 7 6 5 9 4 5 6 9 7 6 9 8 7 2 2 2 5 6'), (<'8 7 6 5 7 8 9 9 6 5 4 4 2 1 4 3 4 5 6 7 8 9 9 9 6 5 7 9 6 5 8 8 9 5 4 3 4 9 9 9 8 7 6 3 9 8 7 6 7 9 8 7 8 6 4 5 8 9 6 7 9 8 7 6 5 4 2 0 9 9 8 9 8 9 6 6 7 8 9 9 9 9 8 3 3 1 2 3 5 9 8 5 8 9 8 1 0 1 2 3'), (<'9 9 5 4 6 2 9 8 7 6 5 5 3 2 3 4 6 6 7 8 9 9 9 8 7 9 8 8 7 6 7 9 3 2 1 2 9 8 9 9 9 8 9 2 1 9 7 5 5 3 9 8 8 7 8 6 7 8 9 8 9 9 8 7 9 4 3 9 8 9 9 5 9 3 5 5 6 7 8 9 9 8 9 2 1 0 5 7 9 8 7 6 7 8 9 2 4 3 4 5'), (<'6 5 4 3 2 1 2 9 8 9 6 5 4 3 4 5 7 8 8 9 9 9 8 9 8 9 9 9 9 9 8 9 4 1 0 9 8 7 8 9 9 9 8 9 9 8 5 4 3 2 2 9 9 8 9 7 8 9 7 9 7 9 9 9 8 9 9 8 7 6 5 4 3 1 3 4 9 8 9 9 9 7 6 3 2 3 4 5 6 9 8 7 8 9 5 4 5 4 5 6'), (<'8 6 5 4 5 4 3 4 9 8 7 6 5 4 7 6 8 9 9 3 9 8 7 5 9 1 2 6 6 7 9 9 5 3 9 9 7 6 7 8 9 8 7 9 8 7 6 3 2 1 0 1 2 9 7 9 9 7 6 5 6 7 9 8 6 7 8 9 6 5 4 3 2 0 1 5 6 9 9 8 7 6 5 4 6 5 5 9 9 8 9 8 9 8 7 5 6 5 6 7'), (<'8 7 6 7 6 5 4 5 7 9 8 7 9 9 8 9 9 4 3 2 9 7 6 4 2 0 1 4 5 6 7 8 9 9 8 8 9 5 6 7 8 9 6 5 9 7 5 4 3 2 2 3 4 5 6 7 8 9 3 4 8 9 7 6 5 7 8 9 7 6 5 4 3 1 2 6 9 2 1 9 9 8 7 5 8 6 9 8 9 7 9 9 9 9 7 6 8 9 7 9'), (<'9 9 8 8 7 6 5 6 7 8 9 9 8 9 9 9 7 6 5 9 6 5 4 3 2 1 2 3 7 8 9 9 9 8 7 6 5 4 5 6 9 9 7 4 9 8 6 5 4 3 4 5 7 8 9 8 9 3 2 1 9 8 6 5 4 5 8 8 9 7 6 5 4 4 3 4 8 9 0 1 3 9 7 6 9 9 8 7 8 6 7 8 9 6 9 7 9 9 8 9'), (<'9 8 9 9 8 7 6 9 8 9 9 8 7 8 9 9 8 9 9 8 7 6 8 4 3 2 3 4 8 9 1 2 4 9 6 5 4 3 6 9 8 8 9 3 2 9 7 6 5 5 6 7 8 9 9 9 9 4 3 2 5 9 7 6 3 4 6 7 8 9 8 8 7 5 6 5 7 8 9 3 4 9 8 9 8 7 6 5 7 5 6 9 7 5 3 9 5 6 9 9'), (<'8 7 6 7 9 8 7 8 9 9 8 7 6 9 9 9 9 9 7 9 8 7 7 5 5 3 4 6 9 1 0 1 9 8 7 7 3 2 3 5 6 7 9 9 3 9 8 7 6 6 8 8 9 8 9 8 7 5 6 3 4 9 8 7 4 9 7 8 9 3 9 9 9 6 7 9 8 9 9 9 5 9 9 9 9 6 5 4 2 4 8 9 5 4 2 3 4 7 9 9'), (<'9 6 5 3 2 9 9 9 9 9 8 7 5 7 8 9 9 8 6 5 9 9 8 9 6 4 6 7 8 9 9 9 8 7 6 5 2 1 3 4 5 6 7 8 9 9 9 9 9 7 8 9 8 7 9 8 7 6 7 8 6 7 9 8 9 9 8 9 3 2 3 9 8 7 8 9 9 9 9 8 9 8 9 9 8 6 4 3 1 3 5 9 3 2 1 2 9 9 7 8'), (<'8 6 3 2 1 0 2 3 9 8 7 6 4 5 7 8 9 6 5 4 3 4 9 8 7 5 7 8 9 7 8 6 9 8 7 4 3 0 2 8 9 7 9 9 8 9 9 9 8 9 9 8 8 6 6 9 8 7 8 9 9 8 9 9 9 8 9 5 1 0 1 2 9 9 9 9 9 8 7 7 9 7 9 8 7 6 5 9 2 3 9 8 9 1 0 9 8 7 6 9'), (<'6 5 4 3 2 2 3 9 8 7 6 4 3 5 8 9 8 7 4 3 2 3 4 9 8 6 7 8 9 6 5 4 6 9 7 6 4 1 6 7 8 9 9 8 7 8 9 8 7 8 9 7 6 5 4 3 9 8 9 9 9 9 8 9 8 7 6 4 3 1 2 3 6 7 8 9 8 7 6 5 7 6 8 9 8 7 9 8 9 9 8 7 8 9 9 8 9 7 5 6'), (<'7 6 5 4 5 6 4 5 9 7 5 3 2 5 9 9 9 9 3 2 1 4 9 9 8 7 8 9 9 7 5 3 7 9 8 9 4 3 5 6 8 9 9 8 6 5 4 7 6 7 8 9 7 6 2 1 2 9 7 8 9 8 7 9 8 7 6 5 4 3 3 4 5 6 9 9 7 6 5 4 5 5 7 8 9 9 8 7 6 8 4 5 6 9 8 7 7 5 4 6'), (<'8 7 9 9 7 9 6 7 9 8 5 4 3 4 8 9 8 7 4 1 0 9 8 9 9 8 9 9 8 7 6 1 2 3 9 8 9 4 5 6 9 8 9 8 7 4 3 4 5 6 7 8 9 9 5 3 4 5 6 9 8 7 6 5 9 8 7 8 7 6 5 9 6 9 9 8 9 5 4 3 1 4 5 9 7 9 9 8 5 9 3 4 9 8 7 6 6 4 3 4'), (<'9 9 8 9 9 8 7 9 8 7 6 5 4 6 7 8 9 6 5 9 2 9 7 9 9 9 9 9 9 9 3 2 3 9 9 7 9 5 6 9 8 7 6 5 4 3 2 3 4 5 8 9 9 8 6 7 9 7 9 8 7 6 5 3 2 9 8 9 8 9 9 8 9 8 9 7 8 9 5 4 2 3 4 5 6 9 8 7 4 3 2 9 8 7 6 5 5 3 2 5'), (<'9 8 7 6 8 9 8 9 9 8 7 7 9 8 9 9 8 9 9 8 9 8 5 8 9 9 9 8 7 5 4 9 9 8 7 6 8 9 9 8 7 6 5 4 3 2 1 0 7 6 7 8 9 9 9 9 8 9 2 9 8 9 4 2 1 3 9 5 9 9 8 7 9 7 6 6 8 8 9 4 3 5 6 6 8 9 8 6 5 4 3 4 9 8 9 4 3 2 1 2'), (<'9 7 8 5 7 9 9 6 5 9 9 8 9 9 5 6 7 9 8 7 6 7 4 6 7 8 9 9 7 6 9 8 7 8 6 5 7 8 8 9 8 7 7 5 4 3 2 3 4 7 8 9 9 9 8 9 7 9 1 0 9 8 9 3 0 1 3 4 9 8 7 6 5 4 5 5 6 7 9 5 4 6 8 9 9 5 9 8 6 6 5 5 6 9 9 5 4 3 2 3'), (<'9 6 5 4 5 8 8 9 4 9 8 9 3 2 4 5 6 9 7 6 5 4 3 5 6 9 9 9 8 9 8 7 6 7 3 4 5 6 7 8 9 8 7 6 9 8 6 4 5 6 7 9 8 7 6 7 6 7 9 9 8 7 8 2 1 2 9 9 8 7 6 5 4 3 4 3 5 6 8 9 5 8 9 1 2 4 5 9 9 8 8 7 9 8 7 6 6 5 3 4'), (<'7 5 4 3 5 6 7 9 9 8 7 3 2 1 9 6 8 9 9 7 9 3 2 3 4 7 8 9 9 9 9 5 4 3 2 3 6 7 8 9 6 9 9 7 9 8 7 5 9 7 9 8 7 6 5 6 5 6 8 9 7 6 4 3 2 9 8 7 9 9 9 7 3 2 1 2 3 8 9 9 7 9 1 0 1 9 6 7 9 9 9 8 9 9 8 8 7 6 4 6'), (<'6 4 3 2 4 5 7 8 9 8 6 5 3 9 8 9 9 3 2 9 8 9 3 4 5 6 9 9 9 8 7 6 8 4 5 4 5 8 9 3 5 6 8 9 9 9 8 6 8 9 7 9 8 7 4 5 4 5 9 8 9 6 5 4 3 4 9 6 9 8 7 6 4 3 2 4 5 6 7 8 9 9 9 9 9 8 9 9 7 6 7 9 9 9 9 9 8 7 8 7'), (<'7 4 2 1 3 4 8 9 9 9 7 6 9 8 7 8 9 4 9 8 7 8 9 9 6 7 8 9 9 9 9 8 7 6 6 5 7 9 3 2 3 7 8 9 9 9 9 7 9 6 5 7 9 5 3 4 3 5 6 7 9 8 7 6 5 9 8 5 3 9 8 7 5 6 3 4 6 8 9 9 7 9 8 7 6 7 9 8 6 5 7 7 8 9 4 2 9 8 9 8'), (<'3 2 1 0 1 2 8 7 9 9 8 9 8 7 6 7 9 5 6 9 6 5 9 8 9 8 9 9 9 8 7 9 8 8 8 6 7 8 9 1 2 3 4 9 8 9 9 8 9 3 4 5 9 4 2 1 2 4 7 8 9 9 9 8 9 8 7 6 2 1 9 8 6 8 7 5 6 7 8 9 6 7 9 6 5 9 8 7 5 4 5 6 7 9 9 4 5 9 2 9'), (<'4 3 2 3 2 3 5 6 7 8 9 2 3 4 5 6 8 9 9 8 5 4 5 6 7 9 7 8 9 7 6 7 9 9 9 7 8 9 1 0 3 4 9 8 7 8 9 9 1 2 4 9 8 7 3 6 7 5 6 7 8 9 8 9 7 9 8 7 1 0 1 9 7 9 8 7 9 8 9 4 5 9 8 9 3 2 9 6 5 3 4 5 6 7 8 9 6 9 1 2'), (<'5 4 5 4 3 4 8 7 8 9 6 3 6 5 6 7 9 8 9 7 6 5 8 7 8 9 6 7 9 6 5 4 5 6 9 8 9 3 2 1 3 9 8 7 6 7 8 9 0 9 5 6 9 5 4 5 7 8 7 8 9 9 7 7 6 7 9 8 2 1 2 9 8 9 9 8 9 9 4 2 9 9 7 9 4 9 8 7 3 2 1 4 5 7 9 9 9 8 9 9'), (<'7 6 8 9 6 5 6 8 9 6 5 4 7 6 7 8 9 7 9 8 9 6 9 8 9 5 4 9 8 7 6 5 6 7 8 9 5 4 3 2 9 9 9 6 5 6 7 9 9 8 9 7 9 6 7 7 8 9 8 9 7 8 5 5 5 6 9 9 3 2 4 5 9 0 1 9 8 6 5 9 8 7 6 8 9 8 7 6 4 3 2 3 4 6 8 9 9 7 6 8'), (<'9 7 9 8 7 9 8 9 9 8 6 5 8 9 9 9 8 6 7 9 9 8 9 9 6 4 3 2 9 8 7 6 7 8 9 9 9 5 4 9 8 9 9 2 4 5 6 9 8 6 8 9 8 7 9 8 9 2 9 9 6 7 4 3 4 9 8 6 4 3 5 6 7 9 9 9 9 8 9 8 7 6 5 3 0 9 9 8 5 4 6 4 5 6 7 9 6 5 4 7'), (<'9 8 9 9 8 9 9 1 3 9 7 6 9 6 4 3 4 5 6 9 9 9 8 7 6 5 4 5 6 9 8 7 8 9 5 9 8 9 9 8 7 7 8 9 6 7 7 8 9 5 4 2 9 8 9 9 5 4 9 8 5 4 3 2 1 2 9 7 5 4 9 7 9 7 8 9 9 9 7 9 8 7 4 2 1 9 8 7 6 9 8 5 7 8 8 9 9 6 5 6'), (<'3 9 5 6 9 2 1 0 1 9 8 9 8 7 5 2 1 4 7 8 9 8 9 8 7 6 7 6 7 8 9 9 9 3 4 9 7 9 8 7 6 6 8 9 8 9 8 9 9 9 0 1 2 9 9 8 7 5 9 7 6 5 9 3 9 3 9 8 7 8 9 9 8 6 6 8 9 4 6 7 9 9 5 3 2 3 9 8 7 9 9 9 8 9 9 9 8 9 9 7'), (<'2 3 4 5 8 9 2 3 4 5 9 9 9 8 6 4 2 3 4 9 8 7 6 9 8 7 8 7 8 9 6 4 3 2 9 8 6 5 4 3 4 4 5 8 9 9 9 9 9 8 9 2 9 8 9 9 8 9 9 8 7 9 8 9 8 9 9 9 9 9 9 7 6 5 5 7 8 9 9 9 8 7 6 4 3 4 6 9 8 9 6 7 9 9 9 9 7 9 8 9'), (<'1 0 1 6 7 9 5 4 6 9 8 9 9 9 7 5 6 9 5 9 9 5 4 2 9 8 9 8 9 9 9 9 9 9 9 9 5 4 3 2 0 3 6 7 8 9 9 8 7 7 9 9 7 6 7 8 9 8 9 9 9 8 7 9 7 8 9 9 9 8 7 6 4 3 4 5 9 9 8 9 8 7 6 5 4 5 6 7 9 6 5 6 7 8 9 8 6 8 7 9'), (<'2 5 2 5 6 7 9 5 7 9 7 8 9 9 8 6 9 8 9 8 7 6 2 1 0 9 8 9 8 7 8 8 7 8 9 8 6 5 4 4 1 2 5 6 7 9 9 8 6 6 7 8 9 5 6 9 6 7 9 9 9 7 6 5 6 7 8 9 9 9 8 5 5 2 3 5 6 8 7 8 9 9 7 6 8 7 8 9 6 5 4 3 7 9 8 7 5 6 6 8'), (<'3 4 3 4 5 6 7 9 8 9 6 7 8 9 9 9 8 7 9 9 9 8 3 2 9 8 7 6 7 5 6 5 6 9 8 7 6 5 4 3 2 3 4 5 8 9 7 6 5 4 5 9 5 4 8 4 5 6 8 9 8 7 6 4 5 6 7 8 9 9 9 3 2 1 2 3 4 5 6 9 6 9 8 9 9 9 9 7 5 4 3 2 6 8 9 9 4 3 4 5'), (<'7 5 6 6 7 9 8 9 9 8 9 8 9 2 3 9 8 6 8 9 6 5 4 9 8 9 9 5 4 3 5 4 5 7 9 8 7 7 6 4 5 4 7 6 7 8 9 5 5 3 4 7 9 3 2 3 4 5 6 7 9 8 7 6 6 8 9 9 9 9 8 9 9 0 1 5 8 9 7 9 5 4 9 6 6 9 8 9 8 7 5 3 4 6 7 8 9 6 5 6'), (<'9 7 8 9 8 9 9 8 6 7 9 9 2 1 9 8 9 5 7 8 9 6 5 9 7 9 5 4 3 2 1 3 4 9 9 9 9 9 7 5 6 5 6 8 8 9 5 4 3 1 3 6 7 9 3 6 5 6 7 8 9 9 9 7 7 9 9 9 7 5 7 6 8 9 7 6 7 8 8 9 6 3 2 4 5 9 7 6 9 9 6 6 5 7 8 9 8 7 6 9'), (<'9 8 9 9 9 9 7 6 5 6 8 9 3 9 8 7 6 4 5 7 8 9 9 8 6 8 9 6 4 4 0 4 9 7 8 9 8 8 9 6 7 8 7 8 9 7 6 6 5 9 4 5 6 7 9 7 7 8 9 9 7 5 9 8 8 9 9 8 5 4 3 5 6 8 9 8 8 9 9 9 9 5 1 3 9 8 9 5 9 8 7 7 6 7 8 9 9 8 7 8'), (<'8 9 8 9 8 7 6 5 4 5 6 7 9 9 9 8 4 3 5 6 9 9 8 7 5 7 8 9 5 5 9 9 7 6 7 8 6 7 9 7 8 9 8 9 9 8 7 7 9 8 9 7 8 9 9 8 9 9 9 9 5 4 3 9 9 9 8 7 6 5 4 5 6 9 9 9 9 9 9 9 8 9 2 9 8 7 8 4 5 9 8 9 9 8 9 9 6 9 9 9'), (<'7 8 7 9 9 8 7 9 3 4 5 6 7 9 5 4 3 2 4 9 8 7 6 5 4 6 6 8 9 9 8 7 6 5 3 4 5 6 8 9 9 5 9 6 8 9 8 9 8 7 9 9 9 1 0 9 9 9 9 8 9 3 2 3 6 8 9 8 7 8 7 6 7 8 9 2 1 9 8 7 7 8 9 9 7 6 5 3 2 3 9 5 6 9 9 8 5 3 2 1'), (<'6 5 6 7 8 9 9 8 9 5 6 7 8 9 6 5 4 3 9 8 7 6 5 2 3 4 5 6 9 8 7 6 4 3 2 8 6 7 8 9 2 4 4 5 6 7 9 9 9 6 6 7 8 9 9 9 8 9 8 7 8 9 3 4 5 6 9 9 8 9 9 7 8 9 9 9 9 8 7 6 6 7 9 9 8 7 3 2 1 2 3 4 8 9 8 7 6 4 3 2'), (<'5 4 3 4 9 9 8 7 9 9 7 8 9 8 7 7 5 9 8 9 6 5 4 1 2 3 5 5 6 9 8 3 2 1 0 9 8 9 9 2 1 5 3 4 5 6 7 9 6 5 4 3 4 9 8 8 6 8 7 6 7 9 5 7 8 7 8 9 9 9 9 9 9 3 9 8 7 9 9 4 5 6 7 8 9 5 4 1 0 2 5 6 7 8 9 9 7 6 4 3'), (<'3 1 2 9 8 9 9 6 7 8 9 9 5 9 9 8 9 9 7 8 9 4 3 0 1 2 3 4 8 9 9 5 3 2 1 3 6 7 8 9 0 1 2 5 6 8 9 8 6 4 3 2 9 8 7 6 5 9 7 5 6 8 9 9 9 8 9 9 9 9 8 9 3 2 9 8 6 5 4 3 4 5 8 9 7 6 3 2 1 2 5 9 8 9 8 9 8 8 5 6'), (<'4 5 9 8 7 9 7 5 8 7 8 9 4 3 5 9 8 7 6 8 9 4 2 1 3 5 6 8 9 9 8 7 5 4 2 4 5 9 8 9 1 9 3 4 6 7 9 6 5 4 2 1 0 9 8 6 4 3 2 3 7 9 2 3 4 9 9 9 8 9 7 8 9 1 3 9 8 8 5 4 5 7 9 9 8 7 8 4 5 3 4 8 9 8 7 5 9 8 7 8'), (<'5 9 9 9 6 7 5 4 6 6 7 8 9 2 9 9 8 7 5 6 8 9 4 2 8 6 8 9 5 4 9 8 9 5 3 4 5 6 7 8 9 8 9 9 7 9 8 7 6 5 3 3 4 9 8 7 5 4 3 4 6 9 3 5 9 9 9 7 6 7 6 7 9 0 9 9 9 7 6 8 6 8 9 5 9 9 8 7 6 5 6 7 8 9 9 4 3 9 8 9'), (<'9 8 7 6 5 4 3 2 4 5 6 9 9 9 8 7 6 5 4 5 7 8 9 3 8 7 9 5 4 3 0 9 7 6 4 6 7 9 8 9 6 6 7 8 9 9 9 9 8 7 5 4 5 7 9 8 6 5 4 6 7 8 9 9 8 9 8 6 5 4 5 6 8 9 8 9 8 9 9 9 7 9 2 4 9 8 9 8 7 6 7 8 9 9 8 9 9 9 9 3'), (<'9 9 8 5 4 3 2 1 2 5 7 8 9 9 9 8 7 4 3 5 6 7 8 9 9 8 9 4 3 2 1 9 8 7 5 9 8 9 9 2 5 5 6 9 9 8 8 7 9 8 6 7 6 7 8 9 8 7 5 6 8 9 9 8 7 8 9 8 4 3 4 9 9 8 7 6 7 8 8 9 8 9 1 9 8 7 7 9 8 9 8 9 8 9 7 9 8 9 2 1'), (<'7 8 9 8 7 4 3 0 1 4 5 6 9 8 7 9 8 5 2 4 5 6 7 8 9 9 6 5 9 3 9 7 9 8 6 7 9 3 2 1 3 4 9 8 7 6 7 6 5 9 7 8 7 8 9 9 9 8 9 7 9 9 8 7 6 7 9 9 2 1 9 8 9 7 9 5 6 6 7 8 9 1 0 9 8 6 5 5 9 9 9 8 7 6 5 6 7 8 9 3'), (<'6 9 8 7 6 5 3 1 2 3 6 9 8 7 6 5 9 2 0 3 7 8 8 9 8 9 7 9 8 9 6 5 4 9 7 8 9 2 1 0 1 9 9 7 6 5 6 5 4 9 8 9 8 9 9 9 7 9 9 8 9 8 7 5 5 6 8 9 9 9 8 7 6 6 5 4 4 5 6 7 8 9 2 9 7 6 4 3 4 9 8 7 6 5 4 5 6 9 8 9'), (<'9 9 9 8 7 5 4 5 3 4 8 9 9 9 9 4 3 2 1 2 3 4 5 6 7 8 9 8 7 8 9 3 2 9 8 9 5 3 2 1 9 8 7 6 5 4 3 2 3 4 9 9 9 9 8 7 6 5 6 9 8 7 8 4 4 5 9 6 7 9 7 6 5 4 4 3 2 3 4 6 7 8 9 8 9 9 3 1 0 1 9 8 7 4 3 5 9 8 7 8'), (<'8 9 7 9 9 8 6 7 8 5 6 7 8 9 8 7 4 3 5 3 4 5 6 7 9 9 8 7 6 7 9 4 3 4 9 7 6 4 3 3 4 9 9 8 7 6 2 1 2 5 7 8 9 8 7 6 4 4 5 9 7 6 4 3 2 7 4 5 9 8 7 5 4 3 2 0 1 2 3 7 9 9 7 6 7 8 9 2 3 9 8 7 6 5 6 9 9 9 6 7'), (<'7 7 6 8 9 9 7 8 9 6 7 8 9 8 7 6 5 8 7 4 8 6 8 8 9 8 9 8 5 6 9 5 5 5 9 8 6 5 4 5 6 8 9 9 7 4 3 2 3 4 5 9 9 5 4 3 2 3 9 9 8 9 3 2 1 2 3 4 5 9 8 6 6 5 4 1 2 3 4 5 9 8 7 5 6 7 8 9 4 6 9 8 8 6 9 8 7 8 5 6'), (<'6 4 5 6 7 9 8 9 8 7 8 9 3 9 8 7 6 9 7 5 7 8 9 9 8 7 6 6 4 7 8 9 7 6 7 9 7 9 6 9 7 8 9 8 6 5 4 6 4 5 6 7 8 9 3 2 1 9 8 7 6 5 4 3 2 3 5 5 7 9 8 7 7 5 3 2 3 4 6 6 8 9 3 4 7 8 9 8 5 7 9 9 9 8 9 8 6 5 4 3'), (<'4 3 4 7 8 9 9 9 9 9 9 3 2 3 9 8 7 9 8 6 7 8 9 9 8 7 5 4 3 6 7 8 9 8 8 9 9 8 9 8 9 9 3 9 7 6 7 8 9 6 7 9 9 8 7 6 2 3 9 9 8 9 9 5 4 6 8 6 7 8 9 9 8 5 4 6 4 5 6 7 8 9 4 5 6 9 8 7 6 7 8 9 7 9 8 9 7 4 2 1'), (<'5 4 5 6 9 8 7 8 9 1 2 9 1 9 9 9 8 9 9 9 8 9 6 5 9 7 6 5 4 5 6 7 8 9 9 8 9 6 9 7 8 9 4 9 8 7 8 9 8 7 9 9 8 7 6 5 3 4 5 6 9 9 8 9 5 7 9 7 8 9 9 7 9 7 9 8 7 6 7 8 9 7 5 6 7 8 9 8 9 8 9 4 6 9 6 5 3 2 1 0'), (<'7 5 6 7 8 9 6 7 9 0 9 8 9 8 9 9 9 5 6 7 9 6 5 3 9 8 7 8 6 7 7 8 9 9 9 7 8 5 7 6 9 8 9 9 9 8 9 9 9 8 9 3 9 8 9 5 4 5 6 9 8 8 7 8 9 9 8 9 9 6 8 6 9 8 9 9 8 7 8 9 9 8 6 7 8 9 9 9 9 9 3 2 9 8 9 6 4 5 2 3'), (<'8 8 7 9 9 3 5 7 8 9 8 7 6 7 8 8 9 3 2 9 8 6 4 2 4 9 8 9 7 8 9 9 9 9 8 6 7 4 8 5 6 7 8 8 9 9 9 8 7 9 3 2 3 9 5 9 8 7 9 8 7 6 5 9 4 9 7 8 9 5 4 5 6 9 8 9 9 8 9 6 5 9 7 9 9 8 9 9 9 8 9 9 8 7 8 9 5 6 3 4'), (<'9 9 8 9 3 2 3 4 9 8 7 6 5 5 6 7 8 9 1 0 9 3 2 1 2 3 9 9 8 9 9 9 9 8 7 5 4 3 3 4 7 9 9 7 8 9 8 7 6 4 2 1 0 3 4 5 9 9 9 9 7 5 4 5 3 7 6 9 9 4 3 4 5 6 7 9 8 9 6 5 4 3 9 8 6 7 8 9 8 7 6 7 6 6 9 8 9 7 4 5'), (<'6 6 9 5 2 1 4 9 9 8 8 5 4 4 5 8 9 8 9 9 8 9 9 2 3 5 6 9 9 7 9 8 7 6 5 4 3 2 1 2 3 4 5 6 9 8 7 6 5 4 3 2 1 2 3 4 9 8 8 9 8 4 3 4 2 6 5 6 7 9 2 6 6 9 8 9 6 8 9 9 5 9 8 7 5 6 9 8 7 6 5 4 5 4 8 7 8 9 5 7'), (<'4 5 9 4 3 4 9 8 7 6 5 4 3 2 3 4 5 6 8 9 7 9 8 9 4 6 9 8 6 6 7 9 8 7 6 5 6 1 0 1 3 5 6 7 8 9 8 7 6 7 4 3 6 4 9 9 8 7 6 5 4 3 2 0 1 2 4 5 8 9 3 5 6 7 8 9 5 6 7 8 9 8 7 6 4 3 2 9 9 5 4 3 4 3 4 5 9 9 9 8'), (<'2 9 8 7 6 5 6 9 8 7 4 3 5 1 5 6 6 7 9 9 6 5 7 8 9 9 8 7 5 4 6 4 9 9 7 9 7 2 1 9 4 5 9 8 9 9 9 9 8 6 5 4 9 9 7 6 9 8 9 6 5 4 3 4 2 4 5 6 7 8 9 6 7 8 9 2 4 5 9 9 2 9 8 7 3 2 1 9 5 4 3 2 1 2 3 6 8 9 9 9'), (<'1 0 9 9 8 7 8 9 9 4 3 2 1 0 6 7 7 8 9 8 7 4 6 8 9 8 7 6 4 3 2 3 4 5 9 8 9 4 9 8 9 6 8 9 7 8 9 9 8 7 8 9 8 7 6 5 6 9 8 7 6 5 5 4 3 5 6 7 8 9 9 8 8 9 2 1 3 7 8 9 1 0 9 8 9 3 9 8 6 5 4 5 6 3 5 6 7 8 9 7'), (<'2 1 7 8 9 8 9 9 6 5 4 4 2 1 2 8 9 9 9 9 4 3 5 9 9 9 8 4 3 2 1 2 5 9 8 7 8 9 8 7 8 9 9 5 6 7 8 8 9 8 9 8 7 6 5 4 5 9 9 8 9 8 6 6 4 5 7 8 9 1 2 9 9 5 4 3 4 6 7 8 9 9 8 9 8 9 8 9 7 6 5 6 8 7 6 7 9 9 5 6'), (<'4 5 6 9 3 9 9 8 7 9 6 7 4 2 3 6 7 8 9 7 3 2 3 9 8 7 4 3 2 1 0 1 9 8 7 6 7 4 6 6 7 8 9 3 3 5 6 7 8 9 9 9 6 5 4 3 7 8 9 9 9 8 7 8 9 6 8 9 5 4 3 9 7 6 6 4 5 7 8 9 9 8 7 8 7 7 7 9 8 7 6 9 9 8 7 8 9 6 3 2'), (<'6 8 9 1 2 3 9 9 9 8 7 8 7 6 4 5 8 9 7 6 5 3 9 8 7 6 5 4 3 2 3 9 8 7 6 5 4 3 4 5 6 7 9 1 2 6 7 9 9 1 9 8 7 9 6 4 5 9 9 9 8 9 8 9 8 7 9 7 6 5 9 8 9 8 7 6 7 8 9 9 9 9 6 7 6 5 6 7 9 8 7 8 9 9 9 9 6 5 4 3'), (<'7 9 2 0 1 9 8 7 6 9 8 9 8 6 5 7 9 9 8 7 6 4 5 9 8 7 6 5 4 5 9 8 7 6 5 4 3 2 3 4 6 7 8 9 3 8 8 9 4 3 4 9 9 8 6 5 6 7 8 9 7 6 9 2 9 9 9 9 7 9 9 7 5 9 8 7 9 9 8 9 8 7 5 4 3 4 5 6 7 9 8 9 9 8 9 8 7 6 5 5'), (<'8 9 4 1 9 8 7 6 5 4 9 9 8 7 8 9 7 2 9 9 7 8 6 8 9 8 7 6 5 9 9 9 8 7 5 3 2 1 4 5 6 7 8 9 5 6 9 7 6 4 9 9 9 8 7 7 7 8 9 7 6 5 4 3 9 7 8 8 9 8 9 4 3 2 9 9 9 8 7 9 7 6 5 3 2 1 0 2 6 7 9 9 8 7 6 9 8 7 8 6'), (<'9 6 5 9 9 9 8 5 4 3 2 3 9 8 9 7 5 3 9 9 8 9 7 9 8 9 8 7 9 8 9 9 7 6 5 4 1 0 1 3 7 9 9 7 6 7 8 9 8 9 8 9 8 9 8 9 8 9 9 8 7 9 9 9 8 6 5 7 6 7 8 9 2 1 0 9 8 7 6 5 9 8 7 9 9 9 9 3 5 6 8 9 7 6 5 3 9 9 8 7'), (<'9 9 9 8 9 8 7 6 5 4 3 5 7 9 9 9 9 9 8 5 9 9 8 9 7 8 9 9 8 7 9 9 9 7 6 6 3 1 2 3 4 7 8 9 8 8 9 9 9 8 7 5 6 7 9 2 9 7 5 9 9 7 8 9 7 5 4 4 5 6 7 9 3 2 9 8 9 9 7 3 2 9 9 8 7 8 8 9 9 7 9 7 6 5 4 2 3 4 9 8'), (<'7 7 6 7 8 9 9 7 6 5 4 6 8 9 9 8 8 9 7 4 3 2 9 8 6 7 9 8 7 6 8 9 8 9 8 9 3 2 3 4 5 6 7 8 9 9 6 9 8 7 6 4 7 9 9 1 9 8 9 8 8 6 7 8 9 6 3 3 4 5 9 8 9 9 8 7 7 8 9 4 1 9 8 7 6 7 7 6 8 9 8 9 7 6 4 3 4 5 7 9'), (<'6 7 5 6 7 8 9 9 7 6 9 7 9 7 6 7 7 9 6 5 2 1 0 9 5 6 7 9 9 4 6 6 7 9 9 6 4 5 4 5 6 7 8 9 2 4 5 6 9 9 5 3 8 9 8 9 9 9 8 7 6 5 6 7 8 9 2 2 5 9 8 6 9 8 7 6 6 7 8 9 2 3 9 9 5 6 6 5 9 8 7 8 9 7 5 4 5 6 7 8'), (<'5 3 4 5 9 9 9 8 9 8 9 8 9 7 4 5 6 8 9 4 3 2 1 9 4 5 9 9 8 3 4 5 6 9 8 7 5 6 5 7 8 9 9 5 3 5 6 7 9 8 3 1 9 8 7 8 9 4 3 2 4 4 5 6 8 9 1 0 9 8 7 5 4 3 2 4 5 6 7 8 9 9 8 7 4 3 5 4 5 5 6 7 8 9 6 9 6 9 8 9'), (<'3 2 3 4 9 9 8 7 8 9 4 9 7 6 5 9 9 9 6 5 4 3 9 8 6 9 8 7 6 1 2 3 4 6 9 8 9 7 9 8 9 9 9 9 4 7 7 9 9 7 6 2 9 8 6 5 4 3 2 1 2 3 6 7 9 5 2 1 6 9 7 6 5 9 1 3 4 7 8 9 9 8 7 6 5 2 1 2 3 4 5 6 7 8 9 8 7 8 9 1'), (<'0 1 9 9 8 7 9 6 9 5 3 9 8 7 9 8 7 8 9 6 7 4 9 8 7 9 6 5 4 0 1 6 5 6 9 9 9 8 9 9 5 8 7 8 9 9 9 8 7 6 5 3 9 8 7 6 5 5 4 2 3 4 7 8 9 4 3 4 5 9 8 9 9 8 9 4 5 8 9 9 9 8 7 5 4 3 0 3 4 5 6 7 8 9 6 9 8 9 1 0'), (<'1 9 8 7 6 5 4 5 6 9 2 1 9 8 9 9 6 7 8 9 9 5 6 9 9 8 7 6 2 1 3 4 5 7 8 9 9 9 4 5 4 5 6 9 8 9 9 9 9 7 6 8 9 9 8 7 6 6 5 4 5 6 7 8 9 8 6 5 6 7 9 9 8 7 8 9 6 7 8 9 9 9 8 6 5 4 1 2 5 6 7 8 9 6 5 9 9 9 3 2'), (<'2 3 9 8 5 4 3 4 5 8 9 0 1 9 8 7 5 6 7 9 8 9 7 8 9 9 8 4 3 4 5 5 6 9 9 8 9 6 3 1 3 4 5 6 7 8 9 9 9 8 9 9 4 6 9 8 9 8 7 5 8 7 8 9 9 9 7 6 7 9 9 8 9 6 9 8 9 9 9 9 8 9 9 8 6 5 4 3 4 5 6 7 8 9 3 8 7 8 9 3'), (<'3 9 8 7 6 5 4 5 6 7 8 9 9 8 9 5 4 5 6 7 7 8 9 9 9 9 9 5 6 6 8 9 7 9 8 7 6 5 2 0 2 3 4 5 6 7 8 9 6 9 5 2 3 9 9 9 6 9 9 6 9 8 9 8 8 9 8 7 9 8 7 7 8 4 5 6 7 8 9 9 7 6 5 9 7 6 5 4 5 6 8 8 9 5 4 5 6 7 9 4'), (<'4 5 9 8 8 9 7 6 7 8 9 9 8 7 5 4 2 3 4 5 6 7 8 9 9 8 7 6 7 7 9 9 8 9 9 8 7 4 3 1 3 4 5 7 7 8 9 9 5 4 3 1 9 8 9 4 5 9 8 7 8 9 7 6 7 8 9 9 8 9 6 5 6 3 4 5 4 6 7 8 9 4 3 9 8 7 6 7 6 7 8 9 9 8 7 6 8 9 8 9'), (<'7 6 7 9 9 9 8 7 8 9 3 2 9 8 9 5 3 4 5 9 7 8 9 5 3 9 8 7 8 8 9 2 9 6 7 9 6 5 3 2 4 5 9 8 8 9 8 8 9 5 4 9 8 7 9 3 2 1 9 8 9 3 4 5 8 9 9 8 7 6 5 4 3 2 3 4 3 4 9 9 4 3 2 0 9 8 7 9 7 8 9 8 9 9 9 7 9 9 7 8'), (<'9 7 9 6 9 9 9 8 9 9 9 0 2 9 7 6 5 6 7 8 8 9 9 9 2 1 9 8 9 9 9 3 4 5 9 8 6 5 4 5 6 6 9 9 9 4 6 7 9 6 9 8 7 6 7 9 9 0 9 9 3 2 7 6 7 9 9 9 8 9 8 5 4 1 0 1 2 4 7 8 9 5 4 9 9 9 8 9 8 9 6 7 8 9 8 9 8 7 6 5'), (<'9 8 9 5 7 8 9 9 9 9 8 9 3 5 9 7 6 7 8 9 9 9 9 8 9 2 3 9 9 9 8 4 5 6 7 9 7 6 7 6 7 7 8 9 3 3 4 6 8 9 8 7 6 5 7 7 8 9 8 9 4 3 8 7 9 8 9 9 9 8 7 6 8 2 1 2 3 5 6 9 7 6 9 8 9 9 9 8 9 6 5 8 9 9 7 6 5 7 5 4'), (<'3 9 3 4 5 9 8 9 9 8 7 8 9 6 9 8 7 8 9 9 9 9 8 7 8 9 5 6 9 8 7 5 6 8 9 9 8 9 8 7 8 8 9 0 1 2 4 5 7 8 9 6 5 4 5 6 9 8 7 6 5 4 9 8 9 7 8 9 9 9 9 7 8 3 2 6 9 7 9 8 9 9 6 7 8 9 8 7 6 5 4 9 8 7 6 5 4 3 2 3'), (<'2 1 2 3 5 6 7 9 9 7 6 8 8 9 9 9 8 9 9 8 9 8 7 6 7 9 9 9 9 9 8 6 7 8 9 7 9 9 9 8 9 9 3 2 3 3 4 6 8 9 9 3 2 3 4 5 6 9 9 7 6 9 9 9 8 6 9 8 9 9 9 8 9 5 4 5 9 9 8 7 8 7 5 6 7 8 9 9 5 4 3 4 9 9 8 4 3 2 1 2'), (<'3 2 3 4 9 7 9 7 8 3 4 6 7 8 9 9 9 9 8 7 8 9 9 5 6 6 7 8 9 9 9 9 8 9 5 6 8 9 8 9 6 5 4 3 5 4 5 6 9 6 8 9 1 5 6 7 8 9 9 8 9 8 9 7 4 5 6 7 8 9 9 8 7 6 5 9 8 9 8 6 4 5 4 5 6 7 8 9 5 3 2 3 9 8 7 6 5 3 0 1'), (<'4 5 6 9 8 9 8 6 7 2 4 5 6 7 8 9 9 8 7 6 9 5 4 3 4 5 9 9 7 8 9 9 9 5 4 7 9 6 7 9 7 6 5 4 5 7 6 8 9 5 8 9 2 3 5 6 7 9 9 9 8 7 5 6 3 4 5 6 7 9 9 9 8 7 9 8 7 8 6 5 3 4 3 4 5 7 8 9 6 4 3 9 9 9 8 7 6 4 1 2'), (<'5 6 9 8 7 6 5 4 2 1 3 4 5 6 9 8 7 6 8 4 5 9 9 9 6 7 8 9 5 8 9 9 5 4 2 3 4 5 6 9 8 7 9 8 7 8 7 9 7 6 7 8 9 4 6 8 9 9 9 8 7 6 4 3 2 3 4 5 6 8 9 7 9 8 9 7 6 5 4 3 2 3 2 4 5 6 8 9 6 5 9 8 7 6 9 8 6 4 3 3'), (<'8 7 8 9 8 7 6 5 1 0 1 2 4 5 6 9 6 5 4 3 4 7 7 8 9 9 9 3 4 6 7 8 9 3 1 9 9 9 7 9 9 8 9 9 8 9 9 9 8 7 8 9 7 5 7 9 9 8 9 9 8 7 4 3 1 2 3 4 5 8 9 5 4 9 9 9 8 4 3 2 1 0 1 5 6 7 9 9 9 9 8 7 6 5 4 9 8 7 6 4'), (<'9 9 9 8 7 6 5 4 2 1 2 6 7 8 9 8 5 4 2 1 2 5 6 7 8 9 7 5 6 7 8 9 9 9 9 8 7 8 9 8 7 9 3 2 9 6 7 8 9 8 9 9 8 6 7 9 8 7 6 8 9 8 5 4 2 3 4 5 6 7 8 9 3 5 9 8 7 6 4 3 2 1 2 7 7 8 9 9 8 9 9 6 5 4 3 5 9 8 7 5'), (<'9 3 2 9 8 7 8 6 3 2 3 5 8 9 8 7 6 5 1 0 1 4 5 6 7 8 9 6 9 8 9 9 9 8 9 7 6 7 9 9 5 3 2 1 3 5 6 7 8 9 9 9 9 7 8 9 7 6 5 3 4 9 6 5 4 4 6 7 8 9 9 3 2 3 4 9 8 7 5 4 3 2 3 4 8 9 9 8 7 9 8 7 6 5 6 6 7 9 8 6'), (<'8 9 1 2 9 9 8 7 9 3 4 7 9 1 9 9 4 3 2 1 2 3 6 7 8 9 9 8 9 9 9 8 7 6 5 6 5 9 8 7 6 7 3 2 3 4 5 6 7 9 9 8 9 8 9 9 8 6 5 4 9 8 7 6 7 6 7 8 9 9 9 5 3 4 5 6 9 8 6 5 4 6 5 5 6 7 9 5 6 5 9 9 7 6 8 8 9 9 9 7'), (<'7 8 9 4 9 8 9 8 9 5 5 8 9 2 9 8 7 5 3 2 3 4 8 9 9 7 6 9 2 3 5 9 6 5 4 3 4 5 9 8 7 6 5 3 4 5 6 8 8 9 9 7 8 9 9 9 8 7 6 5 6 9 9 8 8 9 8 9 9 8 7 6 4 5 6 7 8 9 8 6 5 7 8 6 7 9 5 4 3 4 5 9 8 9 9 9 8 9 9 8'), (<'6 7 8 9 9 7 6 9 8 6 6 7 8 9 9 9 9 5 4 7 4 5 6 7 8 9 5 2 1 3 9 8 7 6 5 1 2 3 4 9 9 9 8 6 5 6 8 9 9 8 7 6 5 6 9 8 9 8 9 6 7 9 8 9 9 8 9 6 8 9 8 7 7 6 9 8 9 4 9 7 6 8 9 7 8 9 8 5 4 6 6 9 9 6 5 6 7 8 9 9'), (<'5 6 8 9 8 9 5 4 9 9 8 9 9 8 8 8 8 9 5 6 7 7 7 8 9 5 4 3 0 2 5 9 8 7 8 2 9 4 6 7 8 9 9 7 6 7 9 9 8 7 7 5 4 6 6 7 8 9 9 8 9 8 7 9 9 7 6 5 7 8 9 9 9 7 8 9 4 2 9 8 9 9 9 8 9 8 7 6 8 7 7 8 9 5 4 5 6 7 8 9'), (<'4 5 7 8 7 8 9 3 5 7 9 9 8 7 6 7 7 9 7 7 9 9 9 9 8 7 6 5 4 3 4 5 9 8 9 9 8 9 9 8 9 9 9 8 7 8 9 8 9 6 5 4 3 4 5 6 7 8 9 9 9 9 6 7 8 9 6 4 6 9 9 8 9 9 9 3 2 1 0 9 6 7 9 9 9 9 8 7 9 9 8 9 5 4 3 4 5 6 7 8'), (<'3 4 3 5 6 8 9 4 6 7 9 9 7 6 5 5 6 8 9 8 9 9 8 9 9 8 7 9 5 4 5 6 7 9 9 9 7 8 8 9 9 9 7 9 9 9 6 7 8 9 2 1 2 3 4 5 8 9 9 9 7 6 5 6 7 8 9 3 5 9 8 7 9 8 7 9 9 2 1 2 5 6 7 8 9 7 9 8 9 9 9 5 4 3 2 5 7 7 8 9'), (<'2 3 2 4 5 7 9 5 6 9 8 8 9 8 3 4 5 7 8 9 6 5 7 8 9 9 9 8 9 7 6 8 9 9 8 7 6 6 7 9 8 7 6 5 4 4 5 6 7 8 9 2 3 4 6 8 9 9 9 8 6 5 4 5 9 9 2 1 9 8 7 6 5 7 6 7 8 9 3 3 4 5 9 9 7 5 6 9 9 8 7 6 5 4 5 6 8 9 9 9'), (<'1 0 1 2 4 5 9 6 9 8 7 7 9 3 2 3 5 6 9 9 5 4 6 7 8 9 6 7 9 9 7 9 8 7 7 6 4 5 8 9 9 9 7 4 3 2 3 7 8 9 6 5 4 6 7 9 9 9 9 8 7 9 5 6 8 9 3 9 8 7 6 5 4 5 5 6 7 8 9 4 5 7 8 9 6 4 5 6 9 9 9 7 6 5 6 7 8 9 6 7'), (<'2 1 2 3 4 6 8 9 8 7 6 5 6 3 1 3 4 6 7 8 9 3 2 1 2 3 5 6 7 8 9 9 9 6 5 4 3 6 7 8 9 8 6 5 4 3 5 6 7 8 9 9 5 7 8 9 9 8 8 9 8 7 6 8 9 5 4 9 9 8 6 4 3 5 4 4 5 7 9 9 6 8 9 9 8 3 4 5 8 9 9 9 7 6 8 9 9 4 5 6'), (<'3 6 5 4 5 6 7 8 9 6 5 4 3 2 0 2 3 4 8 9 3 2 1 0 4 5 6 7 8 9 9 9 8 7 6 5 4 5 6 9 9 9 9 8 6 4 5 6 8 9 9 8 6 7 9 9 9 7 6 4 9 8 7 9 8 6 9 8 7 6 5 4 2 1 2 3 5 6 7 8 9 9 7 6 5 4 5 6 7 8 9 9 8 7 8 9 3 2 3 7')
FullHeight =: 100
FullWidth =: 100

H =: ExampleHeight
W =: ExampleWidth
M =: ". >(H) ($,) ExampleMatrix

H =: FullHeight
W =: FullWidth
M =: ". >(H) ($,) FullMatrix



BM =: (98,.99,M,99),.98

up =: }: }: 99,M,99
down =: }. }. 99,M,99
right =: |: }. }. |: 98,.M,.98
left =: |: }: }: |: 98,.M,.98

lowest =: up <. down <. left <. right
isbigger =: lowest > M
boundary =: M = 9
basins =: M * (1 - boundary)
risk =: isbigger * (M + 1)
risksum =: +/+/ risk
sources_idxs =: -10 + i. (H,W)
sources =: isbigger * sources_idxs

echo '--- M'
NB. echo M
echo '--- BM'
NB. echo BM
echo '---'
echo '--- up'
NB. echo up
echo '--- down'
NB. echo down
echo '--- left'
NB. echo left
echo '--- right'
NB. echo right
echo '---'
echo '--- lowest'
NB. echo lowest
echo '--- isbigger'
NB. echo isbigger
echo '--- risk'
NB. echo risk
echo '--- risksum'
echo risksum
echo '--- boundary'
NB. echo boundary
echo '--- basins'
NB. echo basins
echo '--- original sources'
echo sources

3 : 0''
for. i.1000 do.
up_s =: }: }: 0,sources,0
down_s =: }. }. 0,sources,0
right_s =: |: }. }. |: 0,.sources,.0
left_s =: |: }: }: |: 0,.sources,.0

up_add =: (sources = 0) * up_s * (1 - boundary)
sources =: sources + up_add
down_add =: (sources = 0) * down_s * (1 - boundary)
sources =: sources + down_add
right_add =: (sources = 0) * right_s * (1 - boundary)
sources =: sources + right_add
left_add =: (sources = 0) * left_s * (1 - boundary)
sources =: sources + left_add

end.
)

echo '--- flooded sources'
echo sources

all_sizes =: ''

3 : 0''
for_ijk. sources_idxs do.
  top =: ijk
  for_ijk. top do.
    inner =: ijk
    size =: +/+/ sources = inner
    if. size > 0 do.
      all_sizes =: all_sizes , size
    end.
  end.
end.
)

echo '--- all_sizes'
echo all_sizes

biggest =: 3 {. all_sizes \: all_sizes
echo '--- biggest'
echo biggest

echo '--- answer'
echo * /biggest
