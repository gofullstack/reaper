module HarvestModel
  def new_from_harvested_object(harvested_object)
    attributes = {}.tap do |hash|
      (self.reflect_on_all_associations.map(&:name) + self.attribute_names).each do |property|
        next if property.to_s == 'harvest_id'

        # +id+ is used internally as a primary key, so we preserve Harvest's
        # value as +harvest_id+
        if property.to_s == 'id'
          attribute = :harvest_id
        else
          attribute = property
        end

        # if the object returned by harvested doesn't respond to the
        # properties we store, we quietly move on to the next one.
        value = harvested_object.send(property) rescue next
        next if value.nil?

        # Coerce Harvest::LineItem into LineItem.
        if property == :line_items
          value.each_with_index do |hl, index|
            attributes = LineItem.attribute_names.reduce({}) {
              |hash, (attr, v)| hash[attr] = hl.send(attr) rescue nil ; hash
            }
            value[index] = LineItem.new(attributes)
          end
        end

        hash[attribute] = value
      end
    end

    new(attributes)
  end
end