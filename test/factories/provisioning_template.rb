FactoryGirl.define do
  factory :provisioning_template do
    sequence(:name) { |n| "provisioning_template#{n}" }
    sequence(:template) { |n| "template content #{n}" }

    template_kind
  end

  factory :template_combination do
    provisioning_template
    hostgroup
    environment
  end

  factory :os_default_template do
    template_kind
    provisioning_template { FactoryGirl.create(:provisioning_template, :template_kind => template_kind) }
    operatingsystem { FactoryGirl.create(:operatingsystem, :provisioning_templates => [provisioning_template]) }
  end

  factory :template_kind do
    sequence(:name) { |n| "template_kind_#{n}" }
  end
end
