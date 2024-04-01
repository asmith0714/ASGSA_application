class EmailsController < ApplicationController
    before_action :set_email, only: %i[edit update destroy ]
  
    def index
      authorize(Email)
      @emails = Email.all 
    end
   
    # GET /emails/new
    def new
      authorize(Email)
      @email = Email.new
    end
  
    # GET /emails/1/edit
    def edit
      authorize(Email)
    end
    
    # POST /emails or /emails.json
    def create
      authorize(Email)
      @email = Email.new(email_params)
  
      respond_to do |format|
        if @email.save
          format.html { redirect_to emails_path, notice: "footer was successfully created." }
          format.json { render :show, status: :created, location: @email }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @email.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /emails/1 or /emails/1.json
    def update
      authorize(Email)
      respond_to do |format|
        if @email.update(email_params)
          format.html { redirect_to emails_path, notice: "Footer was successfully updated." }
          format.json { render :show, status: :ok, location: @email }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @email.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /emails/1 or /emails/1.json
    def destroy
      authorize(Email)
      @email.destroy!
  
      respond_to do |format|
        format.html { redirect_to emails_url, notice: "Footer was successfully deleted." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_email
        @email = Email.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def email_params
        params.require(:email).permit(:president, :vice_president, :secretary, :treasurer, 
            :public_relations, :members_at_large, :org_email, :start_year, :end_year)
      end
  
  end