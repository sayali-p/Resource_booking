class Admin::RolesController < ApplicationController
	before_action :find_company
	before_action :find_role, only: [:edit, :show]
  #before_action :admin?
  load_and_authorize_resource :role
  def index
    @roles = @company.roles
  end

  def new
  	@role = @company.roles.build
  end

  def create
    @company.roles.build(role_params)
  	if @company.save
      flash[:success] = "Role has successfully created"
  		redirect_to ["admin",@role]
  	else
  		render :new
  	end
  end

  def show;   end

  def edit;   end

  def update; end

  def destroy; end


  private

  def role_params
  	params.require(:role).permit(:designation,:department,:priority)
  end

  def find_role
  	@role = @company.roles.find(params[:id])
  end

end
