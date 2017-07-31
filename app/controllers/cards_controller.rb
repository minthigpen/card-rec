class CardsController < ApplicationController

  def recommended_backgrounds
    card = Card.find_by_pp_id(params[:new_paper_id])
    recommended_background_ids = card.best_matches.map do |match|
      match.background.pp_id
    end
    render json: recommended_background_ids
  end

end
