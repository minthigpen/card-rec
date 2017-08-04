class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
   
    # get card and make matches and store those in instance variable 
    @card = params[:card_id] ? Card.find(params[:card_id]) : Card.order("RANDOM()").first
    @card_swatch_colors = SwatchPresenter.new(@card).normalized_colors
    # make sure that the 
    @card.initialize_matches unless @card.matches.any?
    # @matches = @card.matches.includes(background: :colors).map{ |match| MatchPresenter.new(match) }.sort{ |a, b| b.beta_sample <=> a.beta_sample }.limit(6)
    @matches = @card.matches.includes(background: :colors).map{ |match| MatchPresenter.new(match) }.sort{ |a, b| b.beta_sample <=> a.beta_sample }[0,5]
    # pop the first in the array of 
    @best_match = @matches.shift

    @survey = Survey.new
  end

  def specific
    card_id = params[:card_id]
    redirect_to action: 'new', card_id: card_id
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create

    # create Survey and Response object for whichever match was selected
    @survey = Survey.create!(card_id: params[:card_id_string].to_i)
    response_match = Match.find(params[:match_selection].to_i)
    @survey.responses.create(match_id: response_match.id, selected: true)

    # find the recommended Match
    recommended_match_id = params[:recommended].select do |match_id_string, match_recommended|
      match_recommended == "true"
    end.to_h.keys[0].to_i
    recommended_match = Match.find(recommended_match_id)

    # recommended_match = params[:recommended].first do |match_id_string, match_bool|
    #   match_bool
    # end

    # update priors if the selected backdrop was recommended
    if response_match == recommended_match
      updated_alpha = recommended_match.alpha + 1
      recommended_match.update_columns(alpha: updated_alpha)


    # else penalize the recommended since the sub-optimal choice was given
    else
      updated_beta = recommended_match.beta + 1

      recommended_match.update_columns(beta: updated_beta)
    end

    # params[:match_selection].each do |match_id_string, value_string|
    #   @survey.responses.create(match_id: match_id_string.to_i, selected: value_string == "1")
    # end

    redirect_to action: 'new'
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      # params.require(:survey).permit(:card_id, :responses)
      #params.permit(:card_id, :match_selection, :recommended)
    end
end
