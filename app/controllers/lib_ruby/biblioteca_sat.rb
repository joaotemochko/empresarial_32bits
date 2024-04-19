class Biblioteca_sat
  extend FFI::Library
  ffi_lib "#{Rails.root}/dll/ACBrSAT32.dll"
  attach_function :INIT,:SAT_Inicializar, [:string, :string], :int
  attach_function :INIT_SAT, :SAT_InicializarSAT, [], :int
  attach_function :FINALIZAR,:SAT_Finalizar, [], :int
  attach_function :DESINICILIZAR,:SAT_DesInicializar, [], :int
  attach_function :CONSULTA_SAT,:SAT_ConsultarSAT, [:string, :string], :int
  attach_function :CONFIG_LER, :SAT_ConfigLer, [:string], :int
  attach_function :CONFIG_GRAVAR, :SAT_ConfigGravar, [:string], :int
  attach_function :CONFIG_LERVALOR, :SAT_ConfigLerValor, [:string, :string, :string, :string], :int
  attach_function :CONFIG_GRAVARVALOR, :SAT_ConfigGravarValor, [:string, :string, :string], :int
  attach_function :CONFIG_IMPORTAR, :SAT_ConfigImportar, [:string], :int
  attach_function :CONFIG_EXPORTAR, :SAT_ConfigExportar, [:string, :string], :int
  attach_function :IMPRIMIR_EXTRATO, :SAT_ImprimirExtratoVenda, [:string], :int
end