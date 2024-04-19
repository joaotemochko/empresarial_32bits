namespace :dev do
  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento e primeiro ambiente de produção"
  task setup: :environment do
    if Rails.env.development?
      puts "Iniciando banco de dados de desenvolvimento..."

      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Adicionando dados do Admin padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Adicionando dados do User padrão...") { %x(rails dev:add_default_user) }
    else
      puts "Iniciando banco de dados de produção..."
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Adicionando o Admin padrão...") { %x(rails dev:add_default_admin) }
    end
  end
  desc "Adiciona usuários padrão ao Admin"
  task add_default_admin: :environment do
    User.create!(
      email: 'admin@admin.com',
      admin: true,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona usuários padrão ao User"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      admin: false,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end
