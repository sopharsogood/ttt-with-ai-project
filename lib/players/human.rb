module Players
    class Human < Player

        def move(board)
            puts "Where will you move? (1-9)"
            gets.strip
        end
    end
end