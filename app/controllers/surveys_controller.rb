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
    @card.initialize_matches unless @card.matches.any?
    @matches = @card.best_matches.order(:rule_id).includes(background: :colors).map{ |match| MatchPresenter.new(match) }

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
    @survey = Survey.create!(card_id: params[:card_id_string].to_i)

    params[:match_selection].each do |match_id_string, value_string|
      @survey.responses.create(match_id: match_id_string.to_i, selected: value_string == "1")

    end

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
      params.permit(:card_id, :match_selection)
    end
end
