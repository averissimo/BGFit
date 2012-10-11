<% 
    javascript 'https://www.google.com/jsapi'

    context_menu = [
        {
            :key => :show, 
            :name => t('navigation.show' , model: DynaModel.model_name.human.downcase), 
            :url => dyna_model_path(@dyna_model),
            :options => {
                :container_class => 'menu'
            }
        },
        {
            :key => :edit, 
            :name => t('action.download_data'), 
            :url => stats_dyna_model_path(@dyna_model, :format => :csv),
            :options => {
                :container_class => 'menu'
            }
        },
        {
            :key => :back, 
            :name => t('navigation.back'), 
            :url => url_for(:back),
            :options => {
                :unless => Proc.new { url_for(:back) == "javascript:history.back()" },
                :container_class => 'menu',
                :class => "text"
            }
        },
        {
            :key => :home, 
            :name => t('navigation.goto' , destination: t('navigation.index' , model: DynaModel.model_name.human).downcase), 
            :url => dyna_models_url,
            :options => {
                :if => Proc.new { url_for(:back) == "javascript:history.back()" },
                :container_class => 'menu',
                :class => "text"
            }
        }]
    menu = nil
    content_for(:context_menu) { menu = render_navigation :items => context_menu }
%>
<% content_for(:title) { t('title.dyna_model.stats' , model: DynaModel.model_name.human) } %>
<p id="notice"><%= notice %></p>

<h1><%= @dyna_model.title %></h1>

<h3>Description:</h3>
<p>
  <%= simple_format (show (@dyna_model.description)) %>
</p>

<h3>Listing <%= pluralize(@dyna_model.params.length, 'parameter')%></h3>

<%= 
    collection_table(@dyna_model.params, :id => 'params' , :class => 'formatted dataTable') do |t|
        t.header :code
        t.header :human_title
        t.header :description

        t.rows.alternate = :odd
        t.rows.each do |row, param, index|
            # Notice there's no need to explicitly define the title
            row.code            param.code
            row.human_title     param.human_title
            row.description     param.description_trimmed.gsub(/\n/, '<br/>')
        end
    end
%>

<div class="menu">
    <%= menu %>
</div>

<h2><%= Model.model_name.human.pluralize%></h2>

<%- @models.each do |m| %>

<%= render partial: "models_summary", :locals => {:m => m} %>

<%- end %>
