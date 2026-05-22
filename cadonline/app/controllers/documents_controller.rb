class DocumentsController < ApplicationController
  before_action :require_login!
  before_action :set_document, only: [ :show, :update, :toggle_favorite, :destroy ]

  def create
    document = current_user.documents.create!(title: "Novo documento", content: default_content, paper_style: "ruled", paper_tone: "default")
    redirect_to root_path(document_id: document.id), notice: "Documento criado."
  end

  def show
    redirect_to root_path(document_id: @document.id)
  end

  def update
    @document.update!(document_params)
    render json: { ok: true }
  end

  def destroy
    @document.destroy!
    redirect_to root_path, notice: "Documento removido."
  end

  def toggle_favorite
    favorite = current_user.favorites.find_by(document: @document)
    if favorite
      favorite.destroy
      state = false
    else
      current_user.favorites.create!(document: @document)
      state = true
    end

    render json: { favorited: state }
  end

  private

  def set_document
    @document = current_user.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :paper_style, :paper_tone, content: {})
  end

  def default_content
    {
      time: Time.current.to_i,
      blocks: [
        { type: "header", data: { text: "Novo documento", level: 2 } },
        { type: "paragraph", data: { text: "Comece a escrever..." } }
      ]
    }
  end
end
