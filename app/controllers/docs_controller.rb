class DocsController < ApplicationController
  before_action :set_policy, only: [:show, :index]

  def show
    @doc = @policy.docs.find(params[:id])
    @title = @doc.file

    render :show, layout: false
  end

  def index
    @docs = @policy.docs
  end

  private
    def set_policy
      @policy = Policy.find(params[:policy_id])
    end
end
