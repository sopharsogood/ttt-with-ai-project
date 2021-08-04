class Game
   WIN_COMBINATIONS = [[0,1,2],
                       [3,4,5],
                       [6,7,8],
                       [0,3,6],
                       [1,4,7],
                       [2,5,8],
                       [0,4,8],
                       [2,4,6]]

    attr_accessor :player_1, :player_2, :board

    def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
        self.player_1 = player_1
        self.player_2 = player_2
        self.board = board
        if self.player_1.token == self.player_2.token ||
          self.player_1.token == " " ||
          self.player_2.token == " " ||
          self.player_1.token.length != 1 ||
          self.player_2.token.length != 1
            self.player_1.token = "X"
            self.player_2.token = "O"
        end
    end

    def current_player
        if self.board.turn_count % 2 == 0
            return self.player_1
        else
            return self.player_2
        end
    end

    def won?
        WIN_COMBINATIONS.find { |combination| self.board.cells[combination[0]] == self.board.cells[combination[1]] &&
               self.board.cells[combination[0]] == self.board.cells[combination[2]] &&
               self.board.cells[combination[0]] != " "}
    end

    def draw?
        self.board.turn_count == 9 && !self.won?
    end

    def over?
        self.draw? || self.won?
    end

    def winner
        if self.won?
            return self.board.cells[self.won?[0]]
        else
            return nil
        end
    end

    def turn
        input = self.current_player.move(self.board)
        if self.board.valid_move?(input)
            self.board.update(input, self.current_player)
        else
            puts "Invalid move. Please select again."
            self.turn
        end
    end

    def play
        until self.over?
            self.turn
        end
        puts "Cat's Game!" if self.draw?
        puts "Congratulations #{self.winner}!" if self.won?
    end

end