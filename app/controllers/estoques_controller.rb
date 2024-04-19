class EstoquesController < DefaultController
  before_action :set_estoque, only: %i[ show edit update destroy ]
  before_action :set_fornecedor_options, only: [ :new, :create, :edit, :update ]
  before_action :set_produto_options, only: [ :new, :create, :edit, :update ]

  # GET /estoques or /estoques.json
  def index
    @estoques = Estoque.all
  end

  # GET /estoques/1 or /estoques/1.json
  def show
  end

  def search_estoque
    @estoque = Estoque.all
    if params[:search].blank?
      redirect_to estoques_path and return
    else
      @parameter = params[:search].downcase
      @produto = Produto.all
      @results = @produto.search_produto(@parameter)
      @id_produto = @results.all.pluck(:id)
      @estoque = @estoque.where(:produto_id => @results)
    end
  end

  # GET /estoques/new
  def new
    @estoque = Estoque.new
  end

  # GET /estoques/1/edit
  def edit
  end

  # POST /estoques or /estoques.json
  def create
    @estoque = Estoque.new(estoque_params)

    respond_to do |format|
      if @estoque.save
        format.html { redirect_to estoque_url(@estoque), notice: "Estoque criado com sucesso." }
        format.json { render :show, status: :created, location: @estoque }

        @produto = Produto.where(:id => estoque_params[:produto_id])
        @soma = @produto.sum{|e| e.quantidade + @estoque.quantidade}
        Produto.where(:id => @produto).update!(:quantidade => @soma)

        @quantidade = (@estoque.quantidade * @estoque.valor)
        Estoque.where(:id => @estoque).update!(:valor => @quantidade)
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @estoque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estoques/1 or /estoques/1.json
  def update
    respond_to do |format|
      if @estoque.update(estoque_params)
        format.html { redirect_to estoque_url(@estoque), notice: "Estoque atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @estoque }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @estoque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estoques/1 or /estoques/1.json
  def destroy
    @estoque.destroy!

    respond_to do |format|
      format.html { redirect_to estoques_url, notice: "Estoque deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    def set_fornecedor_options
      @fornecedor_options = Fornecedor.all.pluck(:nome, :id)
    end

    def set_produto_options
      @produto_options = Produto.all.pluck(:nome, :id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_estoque
      @estoque = Estoque.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def estoque_params
      params.require(:estoque).permit(:produto_id, :fornecedor_id, :desc, :lote, :data_compra, :validade, :quantidade, :valor, :status)
    end
end
