module Api
  module V2
    class TemplateCombinationsController < V2::BaseController
      before_filter :rename_config_template
      before_filter :find_required_nested_object
      before_filter :find_resource, :only => [:show, :update, :destroy]

      def_param_group :template_combination_identifiers do
        param :config_template_id, String, :desc => N_("ID of config template")
        param :provisioning_template_id, String, :desc => N_("ID of config template")
        param :hostgroup_id, String, :desc => N_("ID of host group")
        param :environment_id, String, :desc => N_("ID of environment")
      end

      api :GET, "/config_templates/:config_template_id/template_combinations", N_("List template combination")
      api :GET, "/provisioning_templates/:provisioning_template_id/template_combinations", N_("List template combination")
      api :GET, "/hostgroups/:hostgroup_id/template_combinations", N_("List template combination")
      api :GET, "/environments/:environment_id/template_combinations", N_("List template combination")
      param_group :template_combination_identifiers
      def index
        @template_combinations = nested_obj.template_combinations
        @total = @template_combinations.count
      end

      def_param_group :template_combination do
        param :template_combination, Hash, :required => true, :action_aware => true do
          param :environment_id, :number, :allow_nil => true, :desc => N_("environment id")
          param :hostgroup_id, :number, :allow_nil => true, :desc => N_("host group id")
        end
      end

      api :POST, "/config_templates/:config_template_id/template_combinations", N_("Add a template combination")
      api :POST, "/hostgroups/:hostgroup_id/template_combinations", N_("Add a template combination")
      api :POST, "/environments/:environment_id/template_combinations", N_("Add a template combination")
      param_group :template_combination_identifiers
      param_group :template_combination, :as => :create

      def create
        @template_combination = nested_obj.template_combinations.build(params[:template_combination])
        process_response @template_combination.save
      end

      api :GET, "/template_combinations/:id", N_("Show template combination")
      param :id, :identifier, :required => true
      def show
      end

      api :PUT, "/config_templates/:config_template_id/template_combinations/:id", N_("Update template combination")
      api :PUT, "/hostgroups/:hostgroup_id/template_combinations/:id", N_("Update template combination")
      api :PUT, "/environments/:environment_id/template_combinations/:id", N_("Update template combination")
      param :id, :identifier, :required => true
      param_group :template_combination_identifiers
      param_group :template_combination

      def update
        process_response @template_combination.update_attributes!(params[:template_combination])
      end

      api :DELETE, "/template_combinations/:id", N_("Delete a template combination")
      param :id, :identifier, :required => true

      def destroy
        process_response @template_combination.destroy
      end

      private

      def allowed_nested_id
        %w(environment_id hostgroup_id provisioning_template_id)
      end

      def rename_config_template
        if !params[:config_template_id].nil?
          params[:provisioning_template_id] = params.delete(:config_template_id)
          ::ActiveSupport::Deprecation.warn('Config templates were renamed to provisioning templates')
        end
      end
    end
  end
end
