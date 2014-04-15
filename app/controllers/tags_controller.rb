class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account!
  before_action :find_conversation!

  respond_to :json

  def create
    @conversation.tags = (@conversation.tags + [params[:tag]]).uniq
    @conversation.save

    respond_with @conversation, location: account_conversation_path(@account, @conversation)
  end

  private

  def find_conversation!
    @conversation = @account.conversations.find_by!(number: params.fetch(:conversation_id))
  end

  def find_account!
    @account = Account.friendly.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end
end
