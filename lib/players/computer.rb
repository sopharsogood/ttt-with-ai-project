module Players
    class Computer < Player
        attr_accessor :intelligence
        @@numerical_board = [1,1,1,1,1,1,1,1,1]

        CANONICAL_GOOD_MOVES = {
            Array.new(9,1) => [0,2,4,6,8].sample,
                [0,1,1,1,4,1,1,1,0] => [1,3,5,7].sample,
                [1,1,0,1,4,1,0,1,1] => [1,3,5,7].sample,
                [1,1,1,1,0,1,1,1,1] => [0,2,6,8].sample,
                [4,1,1,1,0,1,1,1,1] => 8,
                [1,1,4,1,0,1,1,1,1] => 6,
                [1,1,1,1,0,1,4,1,1] => 2,
                [1,1,1,1,0,1,1,1,4] => 0
        }
        
        def self.create(token)
            computer = self.new(token)
            computer.intelligence = 0
            until computer.intelligence > 0
                puts "Select an intelligence level for this computer. (1-5)"
                intelligence_input = gets.strip
                if (1..5).to_a.include?(intelligence_input.to_i)
                    computer.intelligence = intelligence_input.to_i
                else
                    puts "Sorry, invalid entry."
                end
            end
            computer
        end

        def move(board)
            self.intelligence = 3 if !self.intelligence     # just to pass tests
            
            (think_of_a_good_index(board) + 1).to_s
        end

        def think_of_a_good_index(board)
            puts "Thinking carefully where to move..."

            if self.intelligence >= 2
                @@numerical_board = self.update_numerical_board(board)
                winning_combination = self.find_good_move(9)
                if winning_combination
                    return winning_combination.find {|index| board.cells[index] == " "}
                end
            end

            if self.intelligence >= 3
                unlosing_combination = self.find_good_move(1)
                if unlosing_combination
                    return unlosing_combination.find {|index| board.cells[index] == " "}
                end
            end

            if self.intelligence >= 5
                if CANONICAL_GOOD_MOVES.keys.include?(@@numerical_board)
                    return CANONICAL_GOOD_MOVES[@@numerical_board]
                elsif board.turn_count <= 2 && @@numerical_board[4] == 1
                    return 4
                end
            end

            if self.intelligence >= 4
                plausible_win_combinations = self.select_combinations_by_sum(6)
                if plausible_win_combinations.length > 0
                    target_win_combination = plausible_win_combinations.sample
                    blanks_within_target_win_combination = target_win_combination.reject {|index| @@numerical_board[index] == 4}
                    return blanks_within_target_win_combination.sample
                end
            end
                
            random_options = (1..9).to_a
            random_move = 20
            until board.valid_move?(random_move)
                random_move = random_options.sample
                random_options.delete_if {|option| option == random_move}
            end
            return random_move - 1
        end

        def find_good_move(sum)
            selected_combinations = self.select_combinations_by_sum(sum)
            # sum = 9 to find where to go to win
            # sum = 1 to find where to go to not lose
            return nil if selected_combinations == nil
            return selected_combinations.sample
        end

        def select_combinations_by_sum(sum)
            Game::WIN_COMBINATIONS.select {|combination|  @@numerical_board[combination[0]] + @@numerical_board[combination[1]] + @@numerical_board[combination[2]] == sum}
        end

        def update_numerical_board(board)
            (0..8).to_a.each do |index|
                case board.cells[index]
                    when self.token
                        @@numerical_board[index] = 4
                    when " "
                        @@numerical_board[index] = 1
                    else
                        @@numerical_board[index] = 0
                end
            end
            @@numerical_board
        end

    end
end