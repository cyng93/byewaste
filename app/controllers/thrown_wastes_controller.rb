class ThrownWastesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @thrown_waste = ThrownWaste.new
  end

  def create
    @user = User.find(params[:user_id])
    @thrown_waste = @user.thrown_wastes.new(thrown_waste_params)

    if @thrown_waste.save
      new_score = current_user.score + @thrown_waste.waste.weight
      current_user.update_score(new_score)
      redirect_to user_thrown_wastes_path(current_user)
    else
      render 'index'
    end
  end

  def destroy
    @thrown_waste = current_user.thrown_wastes.find(params[:id])
    new_score = current_user.score - @thrown_waste.waste.weight
    new_score = 0 if new_score < 0
    current_user.update_score(new_score)
    @thrown_waste.destroy

    redirect_to user_thrown_wastes_path(current_user)
  end

private
  def thrown_waste_params
    params.require(:thrown_waste).permit(:user_id,
                                         :waste_id
                                         )
  end
end
