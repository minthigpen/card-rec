class Card < Image

  has_many :matches
  has_many :backgrounds, through: :matches

  def best_matches
    matches.where(best_score: true)
  end

  def initialize_matches 
    Rule.all.each do |rule|
      best_score = Float::INFINITY
      best_match_params = {}

      Background.includes(:colors).all.each do |background|
        score = Rule.send(rule.name, self, background)
        if score < best_score
          best_score = score
          best_match_params = {background: background, rule: rule, score: score, best_score: true}
        end
      end

      self.matches << Match.create(best_match_params)

    end
  end

end

