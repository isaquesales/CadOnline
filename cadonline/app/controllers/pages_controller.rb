class PagesController < ApplicationController
  before_action :require_login!

  def index
    @document = if params[:document_id].present?
      current_user.documents.find(params[:document_id])
    else
      current_user.documents.order(updated_at: :desc).first || current_user.documents.create!(title: "Meu primeiro documento", paper_style: "ruled", paper_tone: "default", content: default_content)
    end
  end

  private

  def default_content
    {
      time: Time.current.to_i,
      blocks: [
        { type: "header", data: { text: "Meu primeiro documento", level: 2 } },
        { type: "paragraph", data: { text: "Comece a escrever..." } }
      ]
    }
  end
end
