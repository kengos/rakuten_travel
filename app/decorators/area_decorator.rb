module AreaDecorator
  def import_link
    link_to icon('cloud-download') + raw("&nbsp;&nbsp;") + t('decorators.area_decorator.import_hotel'),
      import_hotels_admin_area_path(self, format: :json), remote: true,
      class: 'btn btn-sm btn-success import-hotel-link', data: {type: 'json', confirm: t('decorators.area_decorator.confirm_import_hotel')}
  end

  def enable_label
    if enabled
      raw('<span class="label label-info">' + t('global.enabled') + '</span>')
    else
      raw('<span class="label label-warning">' + t('global.disabled') + '</span>')
    end
  end

  def toggle_link
    link_to enable_label, toggle_admin_area_path(self, format: :json), class: 'toggle-link', data: {'enabled-label' => t('global.enabled'), 'disabled-label' => t('global.disabled')}
  end

  def section
    [large, middle, small.blank? ? nil : small, detail.blank? ? nil : detail].compact.join(' / ')
  end

end