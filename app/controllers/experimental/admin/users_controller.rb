# frozen_string_literal: true

class Experimental::Admin::UsersController < ApplicationController
  layout "experimental_admin"

  before_action :set_user, only: %i[show edit update destroy]

  # GET /experimental/admin/users
  def index
    @users = User.all
  end

  # GET /experimental/admin/users/1
  def show; end

  # GET /experimental/admin/users/new
  def new
    @user = User.new
  end

  # GET /experimental/admin/users/1/edit
  def edit; end

  # POST /experimental/admin/users
  def create
    @user = User.new(user_params.except(:role))
    @user.roles << Role.find(user_params[:role])

    if @user.save
      redirect_to experimental_admin_user_path(@user), notice: "User was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /experimental/admin/users/1
  def update
    if @user.update(user_params)
      redirect_to experimental_admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /experimental/admin/users/1
  def destroy
    @user.destroy
    redirect_to experimental_admin_users_path, notice: "User was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.fetch(:user, {}).permit(:first_name, :last_name, :email, :role)
  end
end
