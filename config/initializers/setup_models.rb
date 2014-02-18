MODEL_BLACKBOX = YAML.load_file("#{::Rails.root}/config/model_blackbox.yml")[::Rails.env]

raise "'#{::Rails.root}/config/model_blackbox.yml > base_path' is not defined" if MODEL_BLACKBOX.blank? || MODEL_BLACKBOX["base_path"].blank?