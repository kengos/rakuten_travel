module PlanDecorator

  def hotel_name
    return 'Invalid hotel' unless hotel

    return hotel.short_name unless hotel.short_name.blank?
    return hotel.long_name
  end

  def point_icon
    css_class = point_rate > 1 ? 'label-success' : 'label-info'
    content_tag(:span, point_rate.to_s + '%', class: "label #{css_class}")
  end

  def gift_icon
    content_tag(:span, icon('gift') + '  ' + number_with_delimiter(quo), class: 'label label-success') if quo >0
  end

  def breakfast_icon
    return '' unless with_breakfast
    build_icon(t('global.with_breakfast'), 'label-primary')
  end

  def dinner_icon
    return '' unless with_dinner
    build_icon(t('global.with_dinner'))
  end

  def payment_icon
    if payment_code == 0
      content_tag(:span, t('global.cash_only'), class: 'label label-warning payment payment-cash')
    elsif payment_code == 1
      content_tag(:span, t('global.cash_and_creditcard'), class: 'label label-default payment payment-cash payment-creditcard')
    else
      content_tag(:span, t('global.creditcard_only'), class: 'label label-warning payment payment-creditcard')
    end
  end

  private

  def build_icon(name, css_class = 'label-primary')
    content_tag(:span, raw(name), class: "label #{css_class}")
  end
end