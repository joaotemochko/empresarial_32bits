class SatController < DefaultController
  extend FFI::Library
  require_relative 'lib_ruby/biblioteca_sat.rb'
  require 'ffi'

  @sat = ffi_lib "#{Rails.root}/dll/SAT.dll"
  if not File.exist?("#{Rails.root}/logs")
    Dir.mkdir("logs")
  end
  if not File.exist?("#{Rails.root}/configSAT")
    Dir.mkdir("configSAT")
  end
  @pathLogX = File.open("#{Rails.root}/logs/LOG_SAT.log", 'w')
  @eArqConfig = File.join("#{Rails.root}/configSAT/ACBrLib.INI")
  @eChaveCrypt = ''

  def index
    Biblioteca_sat.INIT(@eArqConfig, @eChaveCrypt)
    Biblioteca_sat.CONFIG_GRAVARVALOR('Principal', 'TipoResposta', '2')
    Biblioteca_sat.CONFIG_GRAVARVALOR('Principal', 'LogNivel', '4')
    Biblioteca_sat.CONFIG_GRAVARVALOR('Principal', 'LogPath', @pathLogX)
    Biblioteca_sat.CONFIG_GRAVARVALOR('Sat', 'NomeDLL', @sat)

  end
end