class Card < Image

  has_many :matches
  has_many :backgrounds, through: :matches

  def initialize_matches_and_mark_best_scores
    initialize_matches
    mark_best_scores
  end

  def best_matches
    matches.where(best_score: true)
  end


  private

  def initialize_matches 
    # loop through all the background
    Background.all.each do |b|
      # create match for each rule
      Rule.all.each do |r|

        score = Rule.send(r.name, self, b)
        # create new match obj
        self.matches << Match.create(background: b, rule: r, score: score, best_score: false)

      end
    end
  end

  def mark_best_scores
    Rule.all.each do |r|
      # get the score that's the lowest because that's the background image with the smallest difference from target color space
      best_match = self.matches.where(rule: r).order(score: :desc).last
      best_match.best_score = true
      best_match.save!
    end
  end

end
