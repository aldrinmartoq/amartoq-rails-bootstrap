def a0_run(cmd)
  $a0_run_list << cmd
  run cmd
end

def a0_git(msg)
  git add: '.'
  if $a0_run_list.empty?
    git commit: "-a -m '#{msg}'."
  else
    txt = $a0_run_list.collect { |x| "$ #{x}" }.join("\n")
    git commit: "-a -m '#{msg}; comandos:

#{txt}
'"
  end
  $a0_run_list = []
end



# Configuración inicial
$a0_run_list = []
$a0_run_list << "rails #{ARGV.join(' ')}"
run "bundle"
git :init
a0_run "rake db:create db:migrate"
a0_git 'Inicio proyecto'



# HAML
gem 'haml-rails'
gem_group :development, :test do
  gem 'html2haml'
end
a0_run 'for file in app/views/**/*.erb; do html2haml -e $file ${file%erb}haml && rm $file; done'
a0_git 'Soporte plantillas HAML'



# Cancan
gem 'cancan'
a0_run 'rails generate cancan:ability'
a0_git 'Soporte autorización cancan'



# Simple form
gem 'simple_form'
a0_git 'Soporte formularios simple_form'



# Bootstrap
gem 'bootstrap-sass'
gem 'bootstrap-sass-extras'
gem 'bootstrap-navbar'
run 'rm app/assets/stylesheets/application.css'
run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
cat > app/assets/stylesheets/application.css.scss <<EOF
\$navbar-default-bg: #54b4eb;
\$navbar-default-color: black;
\$navbar-default-brand-color: black;
\$navbar-default-link-color: black;
\$navbar-default-link-active-color: white;
\$navbar-default-link-active-bg: #36a7e8;
\$navbar-default-link-hover-color: white;
\$navbar-default-link-hover-bg: black;

@import "bootstrap-sprockets";
@import "bootstrap";

body {
  padding-top: 50px;
}
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
cat > config/initializers/bootstrap-navbar.rb <<EOF
BootstrapNavbar.configure do |config|
  config.bootstrap_version = '3.0.0'
end

BootstrapNavbar.configure do |config|
  config.current_url_method = 'request.original_url'
end

module BootstrapNavbar::Helpers
  def prepare_html(html)
    html.html_safe
  end
end

ActionView::Base.send :include, BootstrapNavbar::Helpers
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
patch -p1 <<EOF
*** old.dashboard/app/assets/javascripts/application.js	Sat Oct 18 16:08:59 2014
--- new.dashboard/app/assets/javascripts/application.js	Sat Oct 18 16:09:11 2014
***************
*** 13,16 ****
--- 13,17 ----
  //= require jquery
  //= require jquery_ujs
  //= require turbolinks
+ //= require bootstrap-sprockets
  //= require_tree .
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
run 'touch app/assets/stylesheets/scaffolds.css.scss'
run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
patch -p1 <<EOF
*** old.dashboard/app/views/layouts/application.html.haml       Sat Oct 18 16:49:06 2014
--- new.dashboard/app/views/layouts/application.html.haml   Sat Oct 18 17:40:12 2014
***************
*** 6,9 ****
      = javascript_include_tag 'application', 'data-turbolinks-track' => true
      = csrf_meta_tags
    %body
!     = yield
--- 6,20 ----
      = javascript_include_tag 'application', 'data-turbolinks-track' => true
      = csrf_meta_tags
    %body
!     = navbar fixed: :top do
!       = navbar_header brand: 'dashboard', brand_link: root_url
!       = navbar_group do
!         = navbar_text 'Seleccione'
!         = navbar_item :users, users_path
!       
!     .container
!       .row
!         .span12
!           = render_breadcrumbs
!           = bootstrap_flash
!           = yield
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
a0_run 'rails generate simple_form:install --bootstrap'
a0_git 'Soporte bootstrap'

run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
patch -p1 <<EOF
diff -cr dashboard/config/initializers/simple_form_bootstrap.rb old.dashboard/config/initializers/simple_form_bootstrap.rb
*** dashboard/config/initializers/simple_form_bootstrap.rb      Sat Oct 18 19:37:38 2014
--- old.dashboard/config/initializers/simple_form_bootstrap.rb  Sat Oct 18 19:36:53 2014
***************
*** 1,21 ****
  # Use this setup block to configure all options available in SimpleForm.
  SimpleForm.setup do |config|
!   config.wrappers :bootstrap, tag: 'div', class: 'control-group', error_class: 'error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'controls' do |ba|
        ba.use :input
        ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
!       ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  
!   config.wrappers :prepend, tag: 'div', class: "control-group", error_class: 'error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'controls' do |input|
        input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
          prepend.use :input
        end
--- 1,21 ----
  # Use this setup block to configure all options available in SimpleForm.
  SimpleForm.setup do |config|
!   config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'col-sm-10' do |ba|
        ba.use :input
        ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
!       ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      end
    end
  
!   config.wrappers :prepend, tag: 'div', class: "form-group", error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'col-sm-10' do |input|
        input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
          prepend.use :input
        end
***************
*** 24,34 ****
      end
    end
  
!   config.wrappers :append, tag: 'div', class: "control-group", error_class: 'error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'controls' do |input|
        input.wrapper tag: 'div', class: 'input-append' do |append|
          append.use :input
        end
--- 24,34 ----
      end
    end
  
!   config.wrappers :append, tag: 'div', class: "form-group", error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'col-sm-10' do |input|
        input.wrapper tag: 'div', class: 'input-append' do |append|
          append.use :input
        end
***************
*** 37,42 ****
--- 37,47 ----
      end
    end

+   config.button_class = 'btn btn-primary'
+   config.form_class = 'simple_form form-horizontal'
+   config.label_class = 'col-sm-2 control-label'
+   config.input_class = 'form-control'
+ 
    # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
    # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
    # to learn about the different styles for forms and inputs,
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
a0_git 'Pichicateos varios'



# Controlador principal
a0_run 'rails generate controller home index -s'
route "root to: 'home#index'"
a0_git 'Controlador inicial'



# Scaffold usuarios
a0_run 'rails generate scaffold user email crypted_password password_salt persistence_token -s'
a0_run 'rake db:migrate'
a0_run 'rake db:seed'
a0_git 'Scaffold para usuarios con email y clave'



# Autenticación con authlogic
gem 'authlogic'
gem 'bcrypt'
gem 'scrypt'
a0_git 'Autenticación con authlogic'



# Quiet assets
gem_group :development, :test do
  gem 'quiet_assets'
end
a0_git 'Quiet assets'
