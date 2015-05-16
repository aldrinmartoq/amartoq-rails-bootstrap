def a0_run(cmd)
  $a0_run_list << cmd
  run cmd
end

def a0_git(msg)
  git add: '.'
  if $a0_run_list.try(:empty?)
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
a0_run "bundle"
git :init
a0_run "rake db:create db:migrate"
a0_git 'Inicio proyecto'



# Ignorar rejects
run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
cat <<EOF >> .gitignore
*.rej
*.orig
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
a0_git 'Archivos de soporte'



# Versionamiento
file 'config/initializers/a0_version.rb', <<-CODE
module A0
  module App
    NAME = "#{app_name.capitalize}"
    module Version
      NUMBER      = "0.0.1"
      NAME        = ""
      TAG         = `git describe --always`.chomp
      DATETIME    = `git log --pretty=format:'(%ci)' -n 1`
    end
  end
end
CODE
a0_git 'Versionamiento'

# HAML
gem 'haml-rails'
gem_group :development, :test do
  gem 'html2haml'
end
a0_run 'bundle'
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
a0_run 'bundle install'
run 'rm app/assets/stylesheets/application.css'
run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
base64 -D <<EOF > app/assets/images/a0-logo-blanco.png
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
zEsAAAAASUVORK5CYII=
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
  padding-top: 55px;
}

.navbar-brand {
  background-image: asset-url('a0-logo-blanco.png');
  background-repeat: no-repeat;
  background-size: 40px 40px;
  background-position: center left;
  padding-left: 50px;
}

.text-center {
 text-align: center;
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
*** old.dashboard/app/views/layouts/application.html.haml Sat Oct 18 16:49:06 2014
--- new.dashboard/app/views/layouts/application.html.haml Sat Oct 18 17:40:12 2014
***************
*** 6,9 ****
      = javascript_include_tag 'application', 'data-turbolinks-track' => true
      = csrf_meta_tags
    %body
!     = yield
--- 6,17 ----
      = javascript_include_tag 'application', 'data-turbolinks-track' => true
      = csrf_meta_tags
    %body
!     = navbar fixed: :top do
!       = navbar_header brand: A0::App::NAME, brand_link: root_url
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
diff -cr old.dashboard/config/initializers/simple_form_bootstrap.rb new.dashboard/config/initializers/simple_form_bootstrap.rb
*** old.dashboard/config/initializers/simple_form_bootstrap.rb Sat Oct 18 19:37:38 2014
--- new.dashboard/config/initializers/simple_form_bootstrap.rb Sat Oct 18 19:36:53 2014
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
!     b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
        ba.use :input
        ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
!       ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      end
    end
  
!   config.wrappers :prepend, tag: 'div', class: "form-group", error_class: 'has-error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :label
!     b.wrapper tag: 'div', class: 'col-sm-9' do |input|
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
!     b.wrapper tag: 'div', class: 'col-sm-9' do |input|
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
+   config.label_class = 'col-sm-3 control-label'
+   config.input_class = 'form-control'
+ 
    # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
    # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
    # to learn about the different styles for forms and inputs,
diff -cr old.dashboard/lib/templates/haml/scaffold/_form.html.haml new.dashboard/lib/templates/haml/scaffold/_form.html.haml
*** old.dashboard/lib/templates/haml/scaffold/_form.html.haml Sat Oct 18 19:51:40 2014
--- new.dashboard/lib/templates/haml/scaffold/_form.html.haml Sat Oct 18 20:07:23 2014
***************
*** 1,10 ****
! = simple_form_for(@<%= singular_table_name %>) do |f|
    = f.error_notification
! 
!   .form-inputs
!   <%- attributes.each do |attribute| -%>
!     = f.<%= attribute.reference? ? :association : :input %> :<%= attribute.name %>
!   <%- end -%>
! 
!   .form-actions
!     = f.button :submit
--- 1,9 ----
! = simple_form_for @<%= singular_table_name %> do |f|
    = f.error_notification
! <%- attributes.each do |attribute| -%>
!   = f.<%= attribute.reference? ? :association : :input %> :<%= attribute.name %>
! <%- end -%>
!   .form-group
!     .form-actions.col-sm-offset-3.col-sm-9
!       = f.button :submit, :class => 'btn-primary'
!       = can_cancel_btn(<%= singular_table_name.classify %>, <%= index_helper %>_path)
diff -Ncr old.dashboard/lib/templates/haml/scaffold/edit.html.haml new.dashboard/lib/templates/haml/scaffold/edit.html.haml
*** old.dashboard/lib/templates/haml/scaffold/edit.html.haml    Wed Dec 31 21:00:00 1969
--- new.dashboard/lib/templates/haml/scaffold/edit.html.haml    Sat Oct 18 20:21:53 2014
***************
*** 0 ****
--- 1,7 ----
+ .page-header
+   %h1
+     = t_edit(<%= singular_table_name.classify %>)
+ <%- if attributes.collect(&:name).include?('name') then -%>
+     = @<%= singular_table_name %>.name
+ <%- end -%>
+ = render :partial => "form"
diff -Ncr old.dashboard/lib/templates/haml/scaffold/index.html.haml new.dashboard/lib/templates/haml/scaffold/index.html.haml
*** old.dashboard/lib/templates/haml/scaffold/index.html.haml   Wed Dec 31 21:00:00 1969
--- new.dashboard/lib/templates/haml/scaffold/index.html.haml   Sat Oct 18 20:20:57 2014
***************
*** 0 ****
--- 1,21 ----
+ .page-header
+   %h1= t_index(<%= singular_table_name.classify %>)
+ %table.table.table-striped
+   %thead
+     %tr
+ <% for attribute in attributes -%>
+       %th= t_attr(<%= singular_table_name.classify %>, :<%= attribute.name %>)
+ <% end -%>
+       %th{:width => 180}= t_actions
+   %tbody
+     - @<%= plural_table_name %>.each do |<%= singular_table_name %>|
+       %tr
+ <% for attribute in attributes -%>
+         %td= <%= singular_table_name %>.<%= attribute.name %>
+ <% end -%>
+         %td
+           = can_show_btn_mini(<%= singular_table_name %>, <%= singular_table_name %>_path(<%= singular_table_name %>))
+           = can_edit_btn_mini(<%= singular_table_name %>, edit_<%= singular_table_name %>_path(<%= singular_table_name %>))
+           = can_destroy_btn_mini(<%= singular_table_name %>, <%= singular_table_name %>_path(<%= singular_table_name %>))
+ 
+ = can_create_btn_primary(<%= singular_table_name.classify %>, new_<%= singular_table_name %>_path)
diff -Ncr old.dashboard/lib/templates/haml/scaffold/new.html.haml new.dashboard/lib/templates/haml/scaffold/new.html.haml
*** old.dashboard/lib/templates/haml/scaffold/new.html.haml Wed Dec 31 21:00:00 1969
--- new.dashboard/lib/templates/haml/scaffold/new.html.haml Sat Oct 18 20:22:18 2014
***************
*** 0 ****
--- 1,4 ----
+ .page-header
+   %h1
+     = t_new(<%= singular_table_name.classify %>)
+ = render :partial => "form"
\ No newline at end of file
diff -Ncr old.dashboard/lib/templates/haml/scaffold/show.html.haml new.dashboard/lib/templates/haml/scaffold/show.html.haml
*** old.dashboard/lib/templates/haml/scaffold/show.html.haml    Wed Dec 31 21:00:00 1969
--- new.dashboard/lib/templates/haml/scaffold/show.html.haml    Sat Oct 18 20:24:57 2014
***************
*** 0 ****
--- 1,23 ----
+ .page-header
+   %h1
+     = t_show(<%= singular_table_name.classify %>)
+ <%- if attributes.collect(&:name).include?('name') then -%>
+     = @<%= singular_table_name %>.name
+ <%- end -%>
+ 
+ %table.table.table-striped
+   %thead
+     %tr
+ <%- for attribute in attributes -%>
+       %th= t_attr(<%= singular_table_name.classify %>, :<%= attribute.name %>)
+ <%- end -%>
+   %tbody
+     %tr
+ <%- for attribute in attributes -%>
+       %td= @<%= singular_table_name %>.<%= attribute.name %>
+ <%- end -%>
+ 
+ .form-actions
+   = can_index_btn(<%= singular_table_name.classify %>, <%= plural_table_name %>_path)
+   = can_edit_btn(@<%= singular_table_name %>, edit_<%= singular_table_name %>_path)
+   = can_destroy_btn(@<%= singular_table_name %>, <%= singular_table_name %>_path)
diff -Ncr old.dashboard/app/controllers/application_controller.rb new.dashboard/app/controllers/application_controller.rb
*** old.dashboard/app/controllers/application_controller.rb Sat Oct 18 20:30:04 2014
--- new.dashboard/app/controllers/application_controller.rb Sat Oct 18 20:38:36 2014
***************
*** 2,5 ****
--- 2,34 ----
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
+   helper_method :current_user
+   
+   rescue_from CanCan::AccessDenied do |exception|
+     session[:original_url] = request.url if not current_user
+     redirect_to root_path, :alert => exception.message
+   end
+   
+   def t_title(object)
+     object.model_name.human.pluralize(I18n.locale).titleize
+   end
+   
+   def t_title_single(object)
+     object.model_name.human.singularize(I18n.locale).titleize
+   end
+   
+   private
+     def current_user
+       return @current_user if defined?(@current_user)
+       @current_user = current_user_session && current_user_session.record
+     end
+     
+     def current_user_session
+       return @current_user_session if defined?(@current_user_session)
+       @current_user_session = UserSession.find
+     end
+ 
+     def current_ability
+       @current_ability ||= Ability.new(current_user)
+     end
  end
diff -Ncr old.dashboard/app/helpers/application_helper.rb dashboard/app/helpers/application_helper.rb
*** old.dashboard/app/helpers/application_helper.rb	Sat Oct 18 22:54:50 2014
--- dashboard/app/helpers/application_helper.rb	Sat Oct 18 22:55:54 2014
***************
*** 1,2 ****
--- 1,177 ----
  module ApplicationHelper
+   ## TRANSLATIONS ##
+   
+   def t_value(object, attribute_name)
+     t "activerecord.values.#{object.class.name.underscore}.#{attribute_name}.#{object.send(attribute_name).try(:to_s)}"
+   end
+   
+   def t_title(object)
+     human_model_name(object).try(:pluralize, I18n.locale).try(:titleize)
+   end
+   
+   def t_index(object, path = nil, name = nil)
+     if path
+       link_to(t('.title', default: t_title(object)), path, name: name)
+     else
+       t '.title', default: t_title(object)
+     end
+   end
+   
+   def t_new(object)
+     t '.title', default: [:'helpers.titles.new', 'New %{model}'], model: t_model(object)
+   end
+   
+   def t_edit(object)
+     t '.title', default: [:'helpers.titles.edit', 'Edit %{model}'], model: t_model(object)
+   end
+   
+   def t_show(object)
+     t_model(object)
+   end
+   
+   def human_model_name(object)
+     return nil unless object
+     return object.class.model_name.human if object.class.respond_to? :model_name
+     return object.model_name.human if object.respond_to? :model_name
+     return ""
+   end
+   
+   def t_model(object)
+     human_model_name(object).try(:titleize)
+   end
+   
+   def t_action(object, action)
+     t '.title', default: [:"helpers.titles.#{action}", "#{action.to_s.titleize} %{model}"], model: object.model_name.human.titleize
+   end
+   
+   def t_attr(object, attribute)
+     object.human_attribute_name(attribute)
+   end
+   
+   def t_actions
+     t '.actions', default: t("helpers.actions")
+   end
+ 
+   # links btn btn-xs  
+   def btn_mini_primary(title, path)
+     link_to title, path, class: 'btn btn-xs btn-primary'
+   end
+   
+   def can_activate_btn_mini(object, path = nil)
+     link_to t('.activate', default: t("helpers.links.activate")), path || object, class: 'btn btn-xs btn-primary' if can?(:activate, object)
+   end
+   
+   def can_position_up_btn_mini(object, path = nil)
+     link_to(path || object, class: 'btn btn-xs', disabled: cannot?(:position_up, object)) do
+       glyph('circle-arrow-up')
+     end
+   end
+ 
+   def can_position_down_btn_mini(object, path = nil)
+     link_to(path || object, class: 'btn btn-xs', disabled: cannot?(:position_down, object)) do
+       glyph('circle-arrow-down')
+     end
+   end
+   
+   def can_show_btn_mini(object, path = nil)
+     link_to t('.show', default: t("helpers.links.show", model: nil)), path || object, class: 'btn btn-xs btn-success' if can?(:read, object)
+   end
+ 
+   def can_edit_btn_mini(object, path = nil)
+     link_to t('.edit', default: t("helpers.links.edit", model: nil)), path || object, class: 'btn btn-xs btn-success' if can?(:update, object)
+   end
+   
+   def can_destroy_btn_mini(object, path = nil)
+     link_to t('.destroy', default: t("helpers.links.destroy")), path || object, method: :delete, data: { confirm: t('.confirm', default: t("helpers.links.confirm", default: 'Are you sure?')) }, class: 'btn btn-xs btn-danger' if can?(:destroy, object)
+   end
+   
+   def can_success_btn_mini(object, action, path = nil)
+     link_to t('.#{action}', default: t("helpers.links.#{action}", model: nil)), path || object, class: 'btn btn-xs btn-success' if can?(action, object)
+   end
+   
+   # links btn btn-primary
+   def can_activate_btn_primary(object, path = nil, opts = {})
+     opts = { class: 'btn btn-primary' }.merge(opts)
+     link_to t('.activate', default: t("helpers.links.activate")), path || object, opts if can?(:activate, object)
+   end
+   
+   def can_create_btn_primary(object, path = nil, opts = {})
+     opts = { class: 'btn btn-primary' }.merge(opts)
+     link_to t('.new', default: t("helpers.links.new", model: t_model(object))), path || object, opts if can?(:create, object)
+   end
+   
+   # links btn
+   def can_index_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t('.back', default: t("helpers.links.back")), path || object, opts if can?(:index, object)
+   end
+   
+   def can_edit_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t('.edit', default: t("helpers.links.edit")), path || object, opts if can?(:update, object)
+   end
+ 
+   def can_success_btn(object, action, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t(".#{action}", default: t("helpers.links.#{action}", model: t_model(object))), path || object, opts if can?(action, object)
+   end
+   
+   def can_destroy_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-danger', method: "delete", data: { confirm: t('.confirm', default: t("helpers.links.confirm", default: 'Are you sure?')) } }.merge(opts)
+     link_to t('.destroy', default: t("helpers.links.destroy")), path || object, opts if can?(:destroy, object)
+   end
+   
+   def can_edit_btn_mini(object, path = nil)
+     link_to t('.edit', default: t("helpers.links.edit", model: nil)), path || object, class: 'btn btn-xs btn-success' if can?(:update, object)
+   end
+   
+   def can_destroy_btn_mini(object, path = nil)
+     link_to t('.destroy', default: t("helpers.links.destroy")), path || object, method: :delete, data: { confirm: t('.confirm', default: t("helpers.links.confirm", default: 'Are you sure?')) }, class: 'btn btn-xs btn-danger' if can?(:destroy, object)
+   end
+   
+   def can_success_btn_mini(object, action, path = nil)
+     link_to t('.#{action}', default: t("helpers.links.#{action}", model: nil)), path || object, class: 'btn btn-xs btn-success' if can?(action, object)
+   end
+   
+   # links btn btn-primary
+   def can_activate_btn_primary(object, path = nil, opts = {})
+     opts = { class: 'btn btn-primary' }.merge(opts)
+     link_to t('.activate', default: t("helpers.links.activate")), path || object, opts if can?(:activate, object)
+   end
+   
+   def can_create_btn_primary(object, path = nil, opts = {})
+     opts = { class: 'btn btn-primary' }.merge(opts)
+     link_to t('.new', default: t("helpers.links.new", model: t_model(object))), path || object, opts if can?(:create, object)
+   end
+   
+   # links btn
+   def can_index_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t('.back', default: t("helpers.links.back")), path || object, opts if can?(:index, object)
+   end
+   
+   def can_edit_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t('.edit', default: t("helpers.links.edit")), path || object, opts if can?(:update, object)
+   end
+ 
+   def can_success_btn(object, action, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t(".#{action}", default: t("helpers.links.#{action}", model: t_model(object))), path || object, opts if can?(action, object)
+   end
+   
+   def can_destroy_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-danger', method: "delete", data: { confirm: t('.confirm', default: t("helpers.links.confirm", default: 'Are you sure?')) } }.merge(opts)
+     link_to t('.destroy', default: t("helpers.links.destroy")), path || object, opts if can?(:destroy, object)
+   end
+   
+   def can_cancel_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-success' }.merge(opts)
+     link_to t('.cancel', default: t("helpers.links.cancel")), path || object, opts if can?(:index, object)
+   end
+   
+   def can_reset_btn(object, path = nil, opts = {})
+     opts = { class: 'btn btn-default' }.merge(opts)
+     link_to t('.reset', default: t("helpers.links.reset")), path || object, opts if can?(:index, object)
+   end
  end
diff -Ncr old.dashboard/app/models/user_session.rb dashboard/app/models/user_session.rb
*** old.dashboard/app/models/user_session.rb    Wed Dec 31 21:00:00 1969
--- dashboard/app/models/user_session.rb        Sat Oct 18 23:13:41 2014
***************
*** 0 ****
--- 1,2 ----
+ class UserSession < Authlogic::Session::Base
+ end
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
a0_git 'Scaffold para usuarios con email y clave'

# Autenticación con authlogic
gem 'authlogic'
gem 'bcrypt'
gem 'scrypt'
a0_run 'bundle install'
a0_git 'Autenticación con authlogic'

# Pichicatear usuario + autenticación
run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
patch -p1 <<EOF
diff -Ncr old.dashboard/app/views/users/_form.html.haml new.dashboard/app/views/users/_form.html.haml
*** old.dashboard/app/views/users/_form.html.haml Sat Oct 18 23:36:33 2014
--- new.dashboard/app/views/users/_form.html.haml Sun Oct 19 00:07:18 2014
***************
*** 1,9 ****
  = simple_form_for @user do |f|
    = f.error_notification
    = f.input :email
-   = f.input :crypted_password
-   = f.input :password_salt
-   = f.input :persistence_token
    .form-group
      .form-actions.col-sm-offset-3.col-sm-9
        = f.button :submit, :class => 'btn-primary'
--- 1,6 ----
diff -Ncr old.dashboard/app/views/users/index.html.haml new.dashboard/app/views/users/index.html.haml
*** old.dashboard/app/views/users/index.html.haml Sat Oct 18 23:36:33 2014
--- new.dashboard/app/views/users/index.html.haml Sun Oct 19 00:07:26 2014
***************
*** 4,20 ****
    %thead
      %tr
        %th= t_attr(User, :email)
-       %th= t_attr(User, :crypted_password)
-       %th= t_attr(User, :password_salt)
-       %th= t_attr(User, :persistence_token)
        %th{:width => 180}= t_actions
    %tbody
      - @users.each do |user|
        %tr
          %td= user.email
-         %td= user.crypted_password
-         %td= user.password_salt
-         %td= user.persistence_token
          %td
            = can_show_btn_mini(user, user_path(user))
            = can_edit_btn_mini(user, edit_user_path(user))
--- 4,14 ----
diff -Ncr old.dashboard/app/views/users/index.json.jbuilder new.dashboard/app/views/users/index.json.jbuilder
*** old.dashboard/app/views/users/index.json.jbuilder Sat Oct 18 23:36:33 2014
--- new.dashboard/app/views/users/index.json.jbuilder Sun Oct 19 00:08:08 2014
***************
*** 1,4 ****
  json.array!(@users) do |user|
!   json.extract! user, :id, :email, :crypted_password, :password_salt, :persistence_token
    json.url user_url(user, format: :json)
  end
--- 1,4 ----
  json.array!(@users) do |user|
!   json.extract! user, :id, :email
    json.url user_url(user, format: :json)
  end
diff -Ncr old.dashboard/app/views/users/show.html.haml new.dashboard/app/views/users/show.html.haml
*** old.dashboard/app/views/users/show.html.haml Sat Oct 18 23:36:33 2014
--- new.dashboard/app/views/users/show.html.haml Sun Oct 19 00:07:37 2014
***************
*** 6,20 ****
    %thead
      %tr
        %th= t_attr(User, :email)
-       %th= t_attr(User, :crypted_password)
-       %th= t_attr(User, :password_salt)
-       %th= t_attr(User, :persistence_token)
    %tbody
      %tr
        %td= @user.email
-       %td= @user.crypted_password
-       %td= @user.password_salt
-       %td= @user.persistence_token
  
  .form-actions
    = can_index_btn(User, users_path)
--- 6,14 ----
diff -Ncr old.dashboard/app/views/users/show.json.jbuilder new.dashboard/app/views/users/show.json.jbuilder
*** old.dashboard/app/views/users/show.json.jbuilder Sat Oct 18 23:36:33 2014
--- new.dashboard/app/views/users/show.json.jbuilder Sun Oct 19 00:07:58 2014
***************
*** 1 ****
! json.extract! @user, :id, :email, :crypted_password, :password_salt, :persistence_token, :created_at, :updated_at
--- 1 ----
! json.extract! @user, :id, :email, :created_at, :updated_at
diff -Ncr old.dashboard/app/controllers/home_controller.rb dashboard/app/controllers/home_controller.rb
*** old.dashboard/app/controllers/home_controller.rb	Sun Oct 19 00:14:26 2014
--- dashboard/app/controllers/home_controller.rb	Sun Oct 19 00:37:53 2014
***************
*** 1,4 ****
--- 1,30 ----
  class HomeController < ApplicationController
    def index
+     @user_session = UserSession.new if not current_user
+   end
+   
+   def login
+     @user_session = UserSession.new(params[:user_session])
+     if @user_session.save
+       flash[:notice] = t('app.user_session.login.success', :name => current_user.email)
+       uri = session[:original_url]
+       session[:original_url] = nil
+       if uri
+         redirect_to uri
+         return
+       end
+     else
+       flash[:alert] = t('raptor.user_session.login.error')
+     end
+     redirect_to root_path
+   end
+ 
+   def logout
+     if current_user
+       flash[:notice] = t('app.user_session.logout.success', :name => current_user.email)
+       current_user_session.destroy
+       session[:original_url] = nil
+     end
+     redirect_to root_path
    end
  end
diff -Ncr old.dashboard/app/controllers/users_controller.rb dashboard/app/controllers/users_controller.rb
*** old.dashboard/app/controllers/users_controller.rb	Sun Oct 19 00:14:26 2014
--- dashboard/app/controllers/users_controller.rb	Sun Oct 19 00:18:15 2014
***************
*** 69,74 ****
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def user_params
!       params.require(:user).permit(:email, :crypted_password, :password_salt, :persistence_token)
      end
  end
--- 69,74 ----
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def user_params
!       params.require(:user).permit(:email, :password, :password_confirmation)
      end
  end
diff -Ncr old.dashboard/app/models/user.rb dashboard/app/models/user.rb
*** old.dashboard/app/models/user.rb	Sun Oct 19 00:14:26 2014
--- dashboard/app/models/user.rb	Sun Oct 19 00:16:24 2014
***************
*** 1,2 ****
--- 1,4 ----
  class User < ActiveRecord::Base
+   acts_as_authentic
+   validates_presence_of :email
  end
diff -Ncr old.dashboard/app/views/home/_login.html.haml dashboard/app/views/home/_login.html.haml
*** old.dashboard/app/views/home/_login.html.haml	Wed Dec 31 21:00:00 1969
--- dashboard/app/views/home/_login.html.haml	Sun Oct 19 00:42:49 2014
***************
*** 0 ****
--- 1,14 ----
+ .modal-dialog
+   .modal-content
+     = simple_form_for @user_session, url: login_path do |f|
+       .modal-header
+         %h1.text-center Bienvenido a #{A0::App::NAME}
+       .modal-body
+         .form-group= f.input_field :email, class: 'input-lg form-control', placeholder: 'username', autofocus: true
+         .form-group= f.input_field :password, class: 'input-lg form-control', placeholder: 'password'
+         .form-group= f.button :submit, 'Login', class: 'btn btn-primary btn-lg btn-block'
+       .modal-footer
+         .text-muted
+           #{A0::App::NAME} #{A0::App::Version::NUMBER}
+           |
+           =link_to 'Servicios A0 SpA', 'http://a0.cl/'
diff -Ncr old.dashboard/app/views/home/index.html.haml dashboard/app/views/home/index.html.haml
*** old.dashboard/app/views/home/index.html.haml	Sun Oct 19 00:14:26 2014
--- dashboard/app/views/home/index.html.haml	Sun Oct 19 00:28:11 2014
***************
*** 1,2 ****
! %h1 Home#index
! %p Find me in app/views/home/index.html.haml
--- 1,3 ----
! 
! - if not current_user
!   = render 'home/login'
\ No newline at end of file
diff -Ncr old.dashboard/app/views/layouts/application.html.haml dashboard/app/views/layouts/application.html.haml
*** old.dashboard/app/views/layouts/application.html.haml	Sun Oct 19 00:14:26 2014
--- dashboard/app/views/layouts/application.html.haml	Sun Oct 19 00:39:08 2014
***************
*** 8,13 ****
--- 8,17 ----
    %body
      = navbar fixed: :top do
        = navbar_header brand: 'App', brand_link: root_url
+       = navbar_group do
+         = navbar_item t_index(User), users_path if can? :read, User
+       = navbar_group align: :right do
+         = navbar_item 'Logout', logout_path if current_user
        
      .container
        .row
diff -Ncr old.dashboard/config/routes.rb dashboard/config/routes.rb
*** old.dashboard/config/routes.rb	Sun Oct 19 00:53:03 2014
--- dashboard/config/routes.rb	Sun Oct 19 00:53:49 2014
***************
*** 2,8 ****
    resources :users
  
    root to: 'home#index'
!   get 'home/index'
  
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
--- 2,11 ----
    resources :users
  
    root to: 'home#index'
!   controller :home do
!     post  '/login'  => :login
!     get   '/logout' => :logout
!   end
  
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
diff -Ncr old.dashboard/db/seeds.rb dashboard/db/seeds.rb
*** old.dashboard/db/seeds.rb	Sun Oct 19 00:53:03 2014
--- dashboard/db/seeds.rb	Sun Oct 19 00:56:25 2014
***************
*** 5,7 ****
--- 5,9 ----
  #
  #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
  #   Mayor.create(name: 'Emanuel', city: cities.first)
+ 
+ User.create email: 'admin@a0.cl', password: '123123', password_confirmation: '123123' unless User.find_by email: 'admin@a0.cl'
diff -Ncr old.dashboard/app/views/layouts/application.html.haml dashboard/app/views/layouts/application.html.haml
*** old.dashboard/app/views/layouts/application.html.haml	Sun Oct 19 01:03:03 2014
--- dashboard/app/views/layouts/application.html.haml	Sun Oct 19 01:20:35 2014
***************
*** 3,17 ****
    %head
      %title Dashboard
      = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true
      = javascript_include_tag 'application', 'data-turbolinks-track' => true
      = csrf_meta_tags
    %body
      = navbar fixed: :top do
        = navbar_header brand: 'App', brand_link: root_url
!       = navbar_group do
!         = navbar_item t_index(User), users_path if can? :read, User
!       = navbar_group align: :right do
!         = navbar_item 'Logout', logout_path if current_user
        
      .container
        .row
--- 3,19 ----
    %head
      %title Dashboard
      = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true
+     = viewport_meta_tag(:maximum_scale => "1.0")
      = javascript_include_tag 'application', 'data-turbolinks-track' => true
      = csrf_meta_tags
    %body
      = navbar fixed: :top do
        = navbar_header brand: 'App', brand_link: root_url
!       = navbar_collapse do
!         = navbar_group do
!           = navbar_item t_index(User), users_path if can? :read, User
!         = navbar_group align: :right do
!           = navbar_item 'Logout', logout_path if current_user
        
      .container
        .row
diff -Ncr old.dashboard/app/controllers/users_controller.rb dashboard/app/controllers/users_controller.rb
*** old.dashboard/app/controllers/users_controller.rb	Sun Oct 19 01:31:58 2014
--- dashboard/app/controllers/users_controller.rb	Sun Oct 19 01:32:32 2014
***************
*** 1,5 ****
--- 1,6 ----
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
+   authorize_resource
  
    # GET /users
    # GET /users.json
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
cat <<EOF > app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
   return if not user
   can :manage, :all
   cannot :destroy, User do |an_user|
     an_user == user
   end
  end
end
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


run <<-'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
patch -p1 <<EOF
diff -Ncr old.dashboard/config/locales/en.app.yml dashboard/config/locales/en.app.yml
*** old.dashboard/config/locales/en.app.yml	Wed Dec 31 21:00:00 1969
--- dashboard/config/locales/en.app.yml	Sun Oct 19 01:39:22 2014
***************
*** 0 ****
--- 1,22 ----
+ en:
+   activerecord:
+     messages:
+       success:
+         created: "%{model} was successfully created."
+         updated: "%{model} was successfully updated."
+         deleted: "%{model} was successfully deleted."
+         activated: "%{model} was successfully activated."
+       error:
+         delete: "%{model} cannot be deleted."
+   app:
+     user_session:
+       login:
+         success: "Welcome back, %{name}."
+         error: "Wrong username or password."
+       logout:
+         success: "Goodbye, %{name}."
+     navbar:
+       logout: 'Logout'
+   unauthorized:
+     manage:
+       all: "You are not authorized to access %{action} on %{subject}"
diff -Ncr old.dashboard/config/locales/en.bootstrap.yml dashboard/config/locales/en.bootstrap.yml
*** old.dashboard/config/locales/en.bootstrap.yml	Wed Dec 31 21:00:00 1969
--- dashboard/config/locales/en.bootstrap.yml	Sun Oct 19 01:41:00 2014
***************
*** 0 ****
--- 1,16 ----
+ en:
+   helpers:
+     actions: "Actions"
+     links:
+       back: "Back"
+       cancel: "Cancel"
+       confirm: "Are you sure?"
+       destroy: "Delete"
+       new: "New %{model}"
+       edit: "Edit"
+       activate: "Activate"
+     titles:
+       edit: "Edit %{model}"
+       save: "Save"
+       new: "New %{model}"
+       delete: "Delete"
diff -Ncr old.dashboard/app/views/users/_form.html.haml dashboard/app/views/users/_form.html.haml
*** old.dashboard/app/views/users/_form.html.haml	Sun Oct 19 01:50:01 2014
--- dashboard/app/views/users/_form.html.haml	Sun Oct 19 01:50:38 2014
***************
*** 1,6 ****
--- 1,8 ----
  = simple_form_for @user do |f|
    = f.error_notification
    = f.input :email
+   = f.input :password
+   = f.input :password_confirmation
    .form-group
      .form-actions.col-sm-offset-3.col-sm-9
        = f.button :submit, :class => 'btn-primary'
EOF
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

a0_run 'rake db:seed'
a0_git 'Integración de usuarios + authlogic + cancan + locales'

# Quiet assets
gem_group :development, :test do
  gem 'quiet_assets'
end
a0_run 'bundle install'
a0_git 'Soporte silencio quiet_assets'

puts <<EOF
XXXXX

Favor ejecutar:
git add .
git commit -m "Fin de plantilla"

EOF