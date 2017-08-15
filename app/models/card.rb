class Card < Image

  has_many :matches
  has_many :backgrounds, through: :matches


  # set the score and priors
  def initialize_matches 
    
    highest_score = 0
    lowest_score = Float::INFINITY

    Background.includes(:colors).all.each do |background|

      score = Rule.highlight(self, background)
      if score < lowest_score
        lowest_score = score
      elsif score > highest_score
        highest_score = score
      end

      # add all matches with their score
      self.matches << Match.create(background: background, rule: Rule.find(4), score: score, best_score: false, alpha: 1, beta: 1)
     
    end

    # set up the priors depending on the score
    best_match = self.matches.where(score: lowest_score)
    ordered_matches = matches.order(score: :asc)

    ordered_matches.each do |m|
      #after ordering the matches by score ascending, update their priors
      puts m.score
      exp_val = 1 - ((m.score-lowest_score)/(highest_score-lowest_score))
      # bounded by (0,1)
      var = 0.01
      # bounded by (0,0.25)
      # given variance and expected value, solve system of equations to get alpha and beta, update table

      if exp_val == 1.0
        calc_alpha = ( (1-0.98)/var - (1/0.98) )*(0.99**2)*10
        calc_beta = calc_alpha*((1/0.99)-1)    
      elsif exp_val == 0.0
        calc_alpha = 1
        calc_beta = 1
      else
        calc_alpha = ( (1-exp_val)/var - (1/exp_val) )*(exp_val**2)*10
        calc_beta = calc_alpha*((1/exp_val)-1)
      end

      m.update(alpha: calc_alpha)
      m.update(beta: calc_beta)
      puts m.id
      puts calc_alpha
      puts calc_beta

    end



    ###### PREVIOUS VERSION WITHOUT LEARNING MODEL ######

    # Rule.all.each do |rule|
    #   best_score = Float::INFINITY
    #   best_match_params = {}

    #   Background.includes(:colors).all.each do |background|
    #     score = Rule.send(rule.name, self, background)
    #     if score < best_score
    #       best_score = score
    #       best_match_params = {background: background, rule: rule, score: score, best_score: true}
    #     end
    #   end

  end



end

